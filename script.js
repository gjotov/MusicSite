const tabButtons = document.querySelectorAll('.tab-button');
const tabContents = document.querySelectorAll('.tab-content');

tabButtons.forEach(button => {
    button.addEventListener('click', () => {
        const tabId = button.getAttribute('data-tab');
        tabButtons.forEach(btn => {
            if (btn.getAttribute('data-tab') === tabId) {
                btn.classList.add('active');
            } else {
                btn.classList.remove('active');
            }
        });
        tabContents.forEach(content => {
            if (content.id === tabId) {
                content.classList.remove('hidden');
            } else {
                content.classList.add('hidden');
            }
        });
    });
});

const registerMessage = document.getElementById('register-message');

if (registerMessage) {
  setTimeout(() => {
    registerMessage.textContent = '';
  }, 5000); // clear message after 5 seconds
}

window.handleLogout = function() {
    localStorage.removeItem('user');
    window.location.href = '../index.html';
   };