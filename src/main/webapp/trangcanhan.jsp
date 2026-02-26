<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.user" %>
<%
    user userInfo = (user) request.getAttribute("userInfo");
    Integer totalRecipes = (Integer) request.getAttribute("totalRecipes");
    Integer totalLikesReceived = (Integer) request.getAttribute("totalLikesReceived");
    Integer totalFavoritesSent = (Integer) request.getAttribute("totalFavoritesSent");
    String[] availableAvatars = (String[]) request.getAttribute("availableAvatars");
    
    if (totalRecipes == null) totalRecipes = 0;
    if (totalLikesReceived == null) totalLikesReceived = 0;
    if (totalFavoritesSent == null) totalFavoritesSent = 0;
%>

<%
    request.setAttribute("pageTitle", "Trang Cá Nhân - CookingShare");
%>
<jsp:include page="include/header.jsp" />

<style>
    .profile-container {
        width: 100%;
        max-width: 960px;
        margin: 2rem auto;
        padding: 0 1rem;
    }
    
    .profile-title {
        font-size: 2rem;
        font-weight: 800;
        color: var(--text-main);
        margin-bottom: 0.5rem;
    }
    
    .profile-subtitle {
        color: var(--text-secondary);
        font-size: 0.875rem;
        margin-bottom: 1.5rem;
    }
    
    .profile-card {
        background: white;
        border-radius: 1rem;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        border: 1px solid var(--border-color);
        overflow: hidden;
    }
    
    .avatar-section {
        padding: 2rem;
        border-bottom: 1px solid var(--border-color);
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 1.5rem;
    }
    
    .avatar-container {
        position: relative;
        width: 128px;
        height: 128px;
        cursor: pointer;
    }
    
    .avatar-image {
        width: 100%;
        height: 100%;
        border-radius: 50%;
        object-fit: cover;
        border: 4px solid white;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        transition: transform 0.3s;
    }
    
    .avatar-container:hover .avatar-image {
        transform: scale(1.05);
    }
    
    .avatar-edit-btn {
        position: absolute;
        bottom: 0;
        right: 0;
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background: var(--primary);
        color: white;
        border: 3px solid white;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        transition: all 0.3s;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
    }
    
    .avatar-edit-btn:hover {
        background: var(--primary-dark);
        transform: scale(1.1);
    }
    
    .user-info-text {
        text-align: center;
    }
    
    .user-name {
        font-size: 1.25rem;
        font-weight: 700;
        color: var(--text-main);
        margin-bottom: 0.25rem;
    }
    
    .user-role {
        font-size: 0.875rem;
        color: var(--text-secondary);
    }
    
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        border-top: 1px solid var(--border-color);
        margin-top: 1.5rem;
        padding-top: 1.5rem;
    }
    
    .stat-item {
        display: flex;
        flex-direction: column;
        align-items: center;
        padding: 0.5rem;
        border-right: 1px solid var(--border-color);
    }
    
    .stat-item:last-child {
        border-right: none;
    }
    
    .stat-number {
        font-size: 1.75rem;
        font-weight: 800;
        color: var(--primary);
    }
    
    .stat-label {
        font-size: 0.75rem;
        color: var(--text-secondary);
        font-weight: 600;
        margin-top: 0.25rem;
        text-align: center;
    }
    
    .form-section {
        padding: 2rem;
    }
    
    .section-title {
        font-size: 1.125rem;
        font-weight: 700;
        color: var(--text-main);
        margin-bottom: 1.5rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    
    .section-title .material-symbols-outlined {
        color: var(--primary);
    }
    
    .form-grid {
        display: grid;
        grid-template-columns: 1fr;
        gap: 1.5rem;
    }
    
    @media (min-width: 768px) {
        .form-grid {
            grid-template-columns: repeat(2, 1fr);
        }
    }
    
    .form-field {
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
    }
    
    .form-label {
        font-size: 0.875rem;
        font-weight: 600;
        color: var(--text-main);
    }
    
    .form-input {
        width: 100%;
        padding: 0.75rem;
        border: 1px solid var(--border-color);
        border-radius: 0.5rem;
        font-size: 0.875rem;
        transition: all 0.3s;
    }
    
    .form-input:focus {
        outline: none;
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(238, 134, 43, 0.1);
    }
    
    .form-input:disabled {
        background: #f9f9f9;
        color: #999;
        cursor: not-allowed;
    }
    
    .form-hint {
        font-size: 0.75rem;
        color: var(--text-secondary);
    }
    
    .verified-badge {
        position: absolute;
        right: 0.75rem;
        top: 50%;
        transform: translateY(-50%);
        color: #10b981;
    }
    
    .form-actions {
        display: flex;
        gap: 1rem;
        justify-content: flex-end;
        margin-top: 1.5rem;
        padding-top: 1.5rem;
        border-top: 1px solid var(--border-color);
    }
    
    .btn {
        padding: 0.75rem 1.5rem;
        border-radius: 0.5rem;
        font-size: 0.875rem;
        font-weight: 700;
        cursor: pointer;
        transition: all 0.3s;
        border: none;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    
    .btn-cancel {
        background: transparent;
        color: var(--text-main);
    }
    
    .btn-cancel:hover {
        background: #f3f4f6;
    }
    
    .btn-save {
        background: var(--primary);
        color: white;
        box-shadow: 0 2px 8px rgba(238, 134, 43, 0.3);
    }
    
    .btn-save:hover {
        background: var(--primary-dark);
        box-shadow: 0 4px 12px rgba(238, 134, 43, 0.4);
    }
    
    .section-divider {
        height: 1px;
        background: var(--border-color);
        margin: 0 2rem;
    }
    
    .avatar-modal {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0, 0, 0, 0.5);
        z-index: 1000;
        align-items: center;
        justify-content: center;
    }
    
    .avatar-modal.active {
        display: flex;
    }
    
    .avatar-modal-content {
        background: white;
        border-radius: 1rem;
        padding: 2rem;
        max-width: 500px;
        width: 90%;
        max-height: 80vh;
        overflow-y: auto;
    }
    
    .modal-header {
        font-size: 1.25rem;
        font-weight: 700;
        color: var(--text-main);
        margin-bottom: 1.5rem;
    }
    
    .avatar-grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 1rem;
    }
    
    .avatar-option {
        cursor: pointer;
        border-radius: 50%;
        overflow: hidden;
        border: 3px solid transparent;
        transition: all 0.3s;
        aspect-ratio: 1;
    }
    
    .avatar-option img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }
    
    .avatar-option:hover {
        border-color: var(--primary);
        transform: scale(1.05);
    }
    
    .avatar-option.selected {
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(238, 134, 43, 0.2);
    }
</style>

<main class="profile-container">
    <div>
        <h1 class="profile-title">Hồ Sơ Cá Nhân</h1>
        <p class="profile-subtitle">Quản lý thông tin cá nhân và xem thống kê hoạt động của bạn</p>
    </div>
    
    <div class="profile-card">
        <div class="avatar-section">
            <div class="avatar-container" onclick="openAvatarModal()">
                <img src="<%= request.getContextPath() %>/avatars/<%= userInfo.getAvatar() != null ? userInfo.getAvatar() : "avatar1" %>.jpg" 
                     alt="Avatar"
                     class="avatar-image"
                     id="currentAvatar">
                <div class="avatar-edit-btn">
                    <span class="material-symbols-outlined" style="font-size: 20px;">photo_camera</span>
                </div>
            </div>
            
            <div class="user-info-text">
                <h3 class="user-name"><%= userInfo.getFullName() %></h3>
                <p class="user-role">Thành viên • <%= userInfo.getCreatedAt() != null ? new java.text.SimpleDateFormat("yyyy").format(userInfo.getCreatedAt()) : "2024" %></p>
            </div>
            
            <div class="stats-grid">
                <div class="stat-item">
                    <span class="stat-number"><%= totalRecipes %></span>
                    <span class="stat-label">Công thức đã đăng</span>
                </div>
                <div class="stat-item">
                    <span class="stat-number"><%= totalLikesReceived %></span>
                    <span class="stat-label">Lượt thích nhận được</span>
                </div>
                <div class="stat-item">
                    <span class="stat-number"><%= totalFavoritesSent %></span>
                    <span class="stat-label">Đã yêu thích</span>
                </div>
            </div>
        </div>
        
        <form id="profileForm" method="post" action="<%= request.getContextPath() %>/TrangCaNhanServlet">
            <input type="hidden" name="action" value="updateProfile">
            <input type="hidden" name="avatar" id="selectedAvatar" value="<%= userInfo.getAvatar() != null ? userInfo.getAvatar() : "avatar1" %>">
            
            <div class="form-section">
                <h3 class="section-title">
                    <span class="material-symbols-outlined">person</span>
                    Thông tin cơ bản
                </h3>
                
                <div class="form-grid">
                    <div class="form-field">
                        <label class="form-label">Tên hiển thị</label>
                        <input type="text" name="fullName" class="form-input" value="<%= userInfo.getFullName() %>" required>
                    </div>
                    
                    <div class="form-field" style="position: relative;">
                        <label class="form-label">Địa chỉ Email</label>
                        <input type="email" name="email" class="form-input" value="<%= userInfo.getEmail() %>" disabled>
                        <span class="material-symbols-outlined verified-badge" title="Đã xác thực">check_circle</span>
                        <p class="form-hint">Email không thể thay đổi trực tiếp</p>
                    </div>
                </div>
                
                <div class="form-actions">
                    <button type="button" class="btn btn-cancel" onclick="window.location.href='<%= request.getContextPath() %>/HomeServlet'">Hủy</button>
                    <button type="submit" class="btn btn-save">
                        <span class="material-symbols-outlined" style="font-size: 18px;">save</span>
                        Lưu thay đổi
                    </button>
                </div>
            </div>
        </form>
        
        <div class="section-divider"></div>
        
        <form id="passwordForm" method="post" action="<%= request.getContextPath() %>/TrangCaNhanServlet" onsubmit="return validatePassword()">
            <input type="hidden" name="action" value="changePassword">
            
            <div class="form-section">
                <h3 class="section-title">
                    <span class="material-symbols-outlined">lock</span>
                    Đổi mật khẩu
                </h3>
                
                <div class="form-grid">
                    <div class="form-field" style="grid-column: 1 / -1;">
                        <label class="form-label">Mật khẩu hiện tại</label>
                        <input type="password" name="currentPassword" class="form-input" placeholder="••••••••">
                    </div>
                    
                    <div class="form-field">
                        <label class="form-label">Mật khẩu mới</label>
                        <input type="password" name="newPassword" id="newPassword" class="form-input" placeholder="Nhập mật khẩu mới">
                    </div>
                    
                    <div class="form-field">
                        <label class="form-label">Xác nhận mật khẩu</label>
                        <input type="password" name="confirmPassword" id="confirmPassword" class="form-input" placeholder="Nhập lại mật khẩu mới">
                    </div>
                </div>
                
                <div class="form-actions">
                    <button type="button" class="btn btn-cancel" onclick="this.form.reset()">Hủy</button>
                    <button type="submit" class="btn btn-save">
                        <span class="material-symbols-outlined" style="font-size: 18px;">save</span>
                        Đổi mật khẩu
                    </button>
                </div>
            </div>
        </form>
    </div>
</main>

<div class="avatar-modal" id="avatarModal">
    <div class="avatar-modal-content">
        <h2 class="modal-header">Chọn ảnh đại diện</h2>
        <div class="avatar-grid">
            <% for (String avatar : availableAvatars) { %>
            <div class="avatar-option <%= avatar.equals(userInfo.getAvatar()) ? "selected" : "" %>" onclick="selectAvatar('<%= avatar %>')">
                <img src="<%= request.getContextPath() %>/avatars/<%= avatar %>.jpg" alt="<%= avatar %>">
            </div>
            <% } %>
        </div>
        <div class="form-actions">
            <button type="button" class="btn btn-cancel" onclick="closeAvatarModal()">Đóng</button>
        </div>
    </div>
</div>

<script>
    function openAvatarModal() {
        document.getElementById('avatarModal').classList.add('active');
    }
    
    function closeAvatarModal() {
        document.getElementById('avatarModal').classList.remove('active');
    }
    
    function selectAvatar(avatarName) {
        document.getElementById('selectedAvatar').value = avatarName;
        document.getElementById('currentAvatar').src = '<%= request.getContextPath() %>/avatars/' + avatarName + '.jpg';
        document.querySelectorAll('.avatar-option').forEach(opt => opt.classList.remove('selected'));
        event.currentTarget.classList.add('selected');
        closeAvatarModal();
    }
    
    function validatePassword() {
        const newPassword = document.getElementById('newPassword').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        
        if (newPassword !== confirmPassword) {
            alert('Mật khẩu mới không khớp!');
            return false;
        }
        
        if (newPassword.length < 6) {
            alert('Mật khẩu phải có ít nhất 6 ký tự!');
            return false;
        }
        
        return true;
    }
    
    document.getElementById('avatarModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeAvatarModal();
        }
    });
</script>

<jsp:include page="include/footer.jsp" />
