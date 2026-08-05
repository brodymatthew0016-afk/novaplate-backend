if (token) showApp();

  document.getElementById('login-password').addEventListener('keydown', e => {
    if (e.key === 'Enter') login();
  });