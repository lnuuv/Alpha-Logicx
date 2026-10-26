import http from 'node:http';
import {readFile} from 'node:fs/promises';
const root = new URL('./', import.meta.url);
const env = process.env;
const url = (env.SUPABASE_URL || '').replace(/\/$/, '');
const key = env.SUPABASE_PUBLISHABLE_KEY || '';
if (key.startsWith('sb_secret_')) throw new Error('Use a Supabase publishable key, never a secret key');
if (url && !/^https:\/\/[a-z0-9-]+\.supabase\.co$/.test(url)) throw new Error('Invalid SUPABASE_URL');
const limits = new Map();
setInterval(() => { const now=Date.now(); for(const [id,v] of limits) if(now-v.at>60000) limits.delete(id); },60000).unref();
const json = (res,status,data) => {res.writeHead(status,{'Content-Type':'application/json','Cache-Control':'no-store'});res.end(JSON.stringify(data));};
const fail = (res,status,message) => json(res,status,{error:{message}});
http.createServer(async (req,res) => {
 try {
  const u = new URL(req.url, 'http://localhost');
  if(u.pathname === '/health') return json(res,200,{ok:true});
  if(u.pathname === '/runtime-config.js' && req.method === 'GET') {
    const code='window.ALX_CLOUD='+JSON.stringify({url,key,turn:''})+';window.ALX_AI_ENABLED='+Boolean(env.GEMINI_API_KEY)+';';
    res.writeHead(200,{'Content-Type':'application/javascript','Cache-Control':'no-store'});return res.end(code);
  }
  if(u.pathname.startsWith('/api/gemini/')) {
    if(!env.GEMINI_API_KEY || !url || !key) return fail(res,503,'إعدادات Render غير مكتملة.');
    const path=u.pathname.slice('/api/gemini'.length);
    if(!((req.method==='POST' && /^\/v1beta\/models\/[a-zA-Z0-9._-]+:generateContent$/.test(path)) || (req.method==='GET' && path==='/v1beta/models'))) return fail(res,404,'Unknown API route');
    if(!/^Bearer [a-zA-Z0-9._-]+$/.test(req.headers.authorization||'')) return fail(res,401,'سجّل الدخول بحساب المنصة لاستخدام الذكاء الاصطناعي.');
    const auth=await fetch(url+'/auth/v1/user',{headers:{apikey:key,Authorization:req.headers.authorization},signal:AbortSignal.timeout(10000)});
    if(!auth.ok) return fail(res,401,'انتهت الجلسة؛ سجّل الدخول مجددًا.');
    const user=await auth.json();
    const profiles=await fetch(url+'/rest/v1/profiles?id=eq.'+encodeURIComponent(user.id)+'&select=active',{headers:{apikey:key,Authorization:req.headers.authorization},signal:AbortSignal.timeout(10000)});
    if(!profiles.ok || !(await profiles.json()).some(p=>p.active)) return fail(res,403,'الحساب غير مفعّل.');
    let count=limits.get(user.id); if(!count || Date.now()-count.at>60000) {count={at:Date.now(),n:0};limits.set(user.id,count);}
    if(++count.n>30) return fail(res,429,'طلبات كثيرة؛ انتظر دقيقة.');
    let body; if(req.method==='POST') { const chunks=[];let size=0;for await(const chunk of req){size+=chunk.length;if(size>2*1024*1024){fail(res,413,'الطلب كبير جدًا.');return;}chunks.push(chunk);}body=Buffer.concat(chunks);try{JSON.parse(body.toString());}catch{return fail(res,400,'Invalid JSON');} }
    const upstream=await fetch('https://generativelanguage.googleapis.com'+path+(req.method==='GET'?'?pageSize=100':''),{method:req.method,headers:{'Content-Type':'application/json','x-goog-api-key':env.GEMINI_API_KEY},body,signal:AbortSignal.timeout(90000)});
    res.writeHead(upstream.status,{'Content-Type':'application/json','Cache-Control':'no-store'});return res.end(await upstream.text());
  }
  const files={'/':'index.html','/index.html':'index.html','/render-client.js':'render-client.js','/alpha-ax.png':'alpha-ax.png'};
  if(req.method!=='GET' || !files[u.pathname]) return fail(res,404,'Not found');
  const data=await readFile(new URL(files[u.pathname],root));
  const type=u.pathname.endsWith('.js')?'application/javascript':u.pathname.endsWith('.png')?'image/png':'text/html; charset=utf-8';
  res.writeHead(200,{'Content-Type':type,'X-Content-Type-Options':'nosniff'});res.end(data);
 } catch(e) { if(!res.headersSent) fail(res,502,'تعذّر الاتصال بالخدمة. حاول مجددًا.');else res.end(); }
}).listen(Number(env.PORT||3000),'0.0.0.0');
