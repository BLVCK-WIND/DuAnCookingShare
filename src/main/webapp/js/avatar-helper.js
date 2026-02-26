/**
 * Avatar Helper - Tự động render avatar cho các elements
 * Usage: Thêm data-avatar="avatar1" và data-letter="N" vào element
 */

document.addEventListener('DOMContentLoaded', function() {
    renderAllAvatars();
});

function renderAllAvatars() {
    const avatarElements = document.querySelectorAll('[data-avatar]');
    
    avatarElements.forEach(element => {
        const avatarName = element.getAttribute('data-avatar');
        const fallbackLetter = element.getAttribute('data-letter') || '?';
        const contextPath = getContextPath();
        
        if (!avatarName || avatarName === 'null' || avatarName === '') {
            renderFallbackAvatar(element, fallbackLetter);
            return;
        }
        
        // Tạo URL ảnh
        const avatarUrl = `${contextPath}/avatars/${avatarName}.jpg`;
        
        // Tạo img element
        const img = document.createElement('img');
        img.src = avatarUrl;
        img.alt = 'Avatar';
        img.style.width = '100%';
        img.style.height = '100%';
        img.style.objectFit = 'cover';
        img.style.borderRadius = '50%';
        
        // Xử lý lỗi load ảnh
        img.onerror = function() {
            console.warn(`Failed to load avatar: ${avatarUrl}`);
            renderFallbackAvatar(element, fallbackLetter);
        };
        
        // Clear và add img
        element.innerHTML = '';
        element.appendChild(img);
    });
}

function renderFallbackAvatar(element, letter) {
    const colors = [
        'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
        'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)',
        'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)',
        'linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)',
        'linear-gradient(135deg, #fa709a 0%, #fee140 100%)',
        'linear-gradient(135deg, #30cfd0 0%, #330867 100%)',
        'linear-gradient(135deg, #a8edea 0%, #fed6e3 100%)'
    ];
    
    const colorIndex = letter.charCodeAt(0) % colors.length;
    const gradient = colors[colorIndex];
    
    element.style.background = gradient;
    element.style.display = 'flex';
    element.style.alignItems = 'center';
    element.style.justifyContent = 'center';
    element.style.color = 'white';
    element.style.fontWeight = '700';
    element.style.fontSize = '1.5rem';
    element.innerHTML = letter.toUpperCase();
}

function getContextPath() {
    const path = window.location.pathname;
    const contextPath = path.substring(0, path.indexOf('/', 1));
    return contextPath || '';
}

// Export functions cho global use
window.renderAllAvatars = renderAllAvatars;
window.renderFallbackAvatar = renderFallbackAvatar;