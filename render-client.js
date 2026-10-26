(() => {
  localStorage.removeItem('gemini-key'); localStorage.removeItem('u1.geminiKey');
  window.GEMINI_API_KEY = window.ALX_AI_ENABLED ? 'render-managed' : '';
  const originalFetch = window.fetch.bind(window);
  window.fetch = function(input, options = {}) {
    const url = new URL(typeof input === 'string' ? input : input.url, location.href);
    if (url.origin === 'https://generativelanguage.googleapis.com') {
      const headers = new Headers(options.headers);
      headers.delete('x-goog-api-key');
      let token = '';
      try { token = JSON.parse(localStorage.getItem('alx-sb-auth') || '{}').access_token || ''; } catch (_) {}
      if (token) headers.set('Authorization', 'Bearer ' + token);
      url.searchParams.delete('key');
      return originalFetch('/api/gemini' + url.pathname + url.search, {...options, headers});
    }
    return originalFetch(input, options);
  };
})();
