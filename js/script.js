// Common Utilities

// Show a simple toast message (simulated with alert for now or a custom div)
function showToast(message, type = 'info') {
    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    toast.style.position = 'fixed';
    toast.style.top = '20px';
    toast.style.left = '50%';
    toast.style.transform = 'translateX(-50%)';
    toast.style.padding = '10px 20px';
    toast.style.borderRadius = '4px';
    toast.style.color = '#fff';
    toast.style.zIndex = '1000';
    toast.style.fontSize = '14px';
    toast.style.boxShadow = '0 4px 12px rgba(0,0,0,0.15)';
    toast.style.transition = 'opacity 0.3s';

    if (type === 'success') toast.style.backgroundColor = '#52c41a';
    else if (type === 'error') toast.style.backgroundColor = '#ff4d4f';
    else toast.style.backgroundColor = '#1890ff';

    toast.innerText = message;
    document.body.appendChild(toast);

    setTimeout(() => {
        toast.style.opacity = '0';
        setTimeout(() => toast.remove(), 300);
    }, 3000);
}

// Simulate Logout
function logout() {
    if(confirm('确定要退出登录吗？')) {
        localStorage.removeItem('userRole');
        localStorage.removeItem('userName');
        window.location.href = '/login.html'; // Assuming root is served
    }
}

// Check Login Status (Simple simulation)
function checkLogin() {
    const userRole = localStorage.getItem('userRole');
    if (!userRole && !window.location.pathname.includes('login.html') && !window.location.pathname.includes('register.html')) {
        window.location.href = '../login.html';
    }
}

// Highlight active menu based on current path
document.addEventListener('DOMContentLoaded', () => {
    const path = window.location.pathname;
    const menuItems = document.querySelectorAll('.menu-item');
    menuItems.forEach(item => {
        if (path.includes(item.getAttribute('data-path'))) {
            item.classList.add('active');
        }
    });
});
