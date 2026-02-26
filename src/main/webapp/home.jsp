<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="Model.congthuc" %>
<%@ page import="Model.danhmuc" %>
<%@ page import="Model.user" %>
<%@ page import="Model.yeuthichdao" %>
<%
    request.setAttribute("pageTitle", "Trang Chủ - CookingShare");
    
    List<congthuc> latestRecipes = (List<congthuc>) request.getAttribute("latestRecipes");
    List<congthuc> topViewed = (List<congthuc>) request.getAttribute("topViewed");
    List<danhmuc> categories = (List<danhmuc>) request.getAttribute("categories");
 // ✅ LẤY USER SESSION (PREFIX: user_) - KHÔNG DÙNG "user" CHUNG
    user currentUser = (user) session.getAttribute("user_user");
    
    // Debug
    if (currentUser != null) {
        System.out.println("✅ home.jsp: User đang xem: " + currentUser.getUsername());
    } else {
        System.out.println("ℹ️ home.jsp: Khách vãng lai (chưa đăng nhập)");
    }
    
    // Nếu đã đăng nhập, lấy danh sách các recipe đã yêu thích
    yeuthichdao ytDao = new yeuthichdao();
%>

<!-- Include Header -->
<jsp:include page="include/header.jsp" />

<!-- Page-specific styles -->
<style>
    /* === HERO === */
    .hero-section {
        width: 100%;
        padding: 2rem 2.5rem 3rem;
        display: flex;
        justify-content: center;
    }

    .hero-container {
        max-width: 1280px;
        width: 100%;
    }

    .hero-banner {
        position: relative;
        width: 100%;
        border-radius: 1rem;
        overflow: hidden;
        min-height: 500px;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        text-align: center;
        padding: 2rem;
        background: linear-gradient(rgba(0, 0, 0, 0.3) 0%, rgba(0, 0, 0, 0.6) 100%),
                    url('https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=1200');
        background-size: cover;
        background-position: center;
        box-shadow: 0 10px 15px rgba(0,0,0,0.1);
    }

    .hero-content {
        display: flex;
        flex-direction: column;
        gap: 1rem;
        max-width: 48rem;
        z-index: 10;
    }

    .hero-title {
        color: white;
        font-size: 3.75rem;
        font-weight: 900;
        line-height: 1.2;
        text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
    }

    .hero-subtitle {
        color: #e5e5e5;
        font-size: 1.125rem;
        font-weight: 500;
        line-height: 1.75;
    }

    .hero-cta {
        margin-top: 1rem;
    }

    .hero-btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border-radius: 9999px;
        background-color: var(--primary);
        padding: 1rem 2.5rem;
        color: white;
        font-size: 1rem;
        font-weight: 700;
        transition: all 0.3s;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    }

    .hero-btn:hover {
        background-color: var(--primary-hover);
        transform: translateY(-2px);
        box-shadow: 0 6px 12px rgba(0,0,0,0.15);
    }

    /* === CATEGORIES SECTION === */
    .categories-section {
        width: 100%;
        padding: 0 2.5rem 3rem;
        display: flex;
        justify-content: center;
    }

    .categories-slider-wrapper {
        position: relative;
        width: 100%;
    }

    .categories-slider {
        display: flex;
        gap: 1.5rem;
        overflow-x: auto;
        scroll-behavior: smooth;
        padding: 1rem 0;
        scrollbar-width: none;
    }

    .categories-slider::-webkit-scrollbar {
        display: none;
    }

    .category-card-slider {
        position: relative;
        flex-shrink: 0;
        width: 300px;
        height: 200px;
        border-radius: 1rem;
        overflow: hidden;
        background-size: cover;
        background-position: center;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        transition: transform 0.3s, box-shadow 0.3s;
        cursor: pointer;
    }

    .category-card-slider:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 20px rgba(0,0,0,0.15);
    }

    .slider-btn {
        display: none;
        position: absolute;
        top: 50%;
        transform: translateY(-50%);
        z-index: 20;
        width: 3rem;
        height: 3rem;
        background: white;
        box-shadow: 0 10px 15px rgba(0,0,0,0.1);
        border-radius: 50%;
        align-items: center;
        justify-content: center;
        transition: all 0.3s;
        border: none;
        cursor: pointer;
    }

    @media (min-width: 768px) {
        .slider-btn {
            display: flex;
        }
    }

    .slider-btn:hover {
        background: var(--primary);
        color: white;
    }

    .slider-btn-left {
        left: -1.5rem;
    }

    .slider-btn-right {
        right: -1.5rem;
    }

    .slider-btn .material-symbols-outlined {
        font-size: 2rem;
    }

    /* === TOP VIEWED SECTION === */
    .top-viewed-section {
        width: 100%;
        padding: 3rem 2.5rem;
        display: flex;
        justify-content: center;
    }

    /* === LATEST RECIPES SECTION === */
    .latest-recipes-section {
        width: 100%;
        padding: 3rem 2.5rem;
        background: white;
        display: flex;
        justify-content: center;
    }
    
    /* === RECIPE CARD STYLES === */
    .recipe-card {
        background: white;
        border-radius: 1rem;
        border: 1px solid var(--border-color);
        overflow: hidden;
        transition: all 0.3s;
        height: 100%;
        display: flex;
        flex-direction: column;
    }

    .recipe-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 10px 20px rgba(0,0,0,0.1);
    }

    .recipe-image-wrapper {
        position: relative;
        width: 100%;
        padding-top: 75%; /* 4:3 aspect ratio */
        overflow: hidden;
        background: var(--bg-secondary);
    }

    .recipe-image {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    /* Badge số lượt xem - góc trên bên trái */
    .recipe-badge {
        position: absolute;
        top: 0.75rem;
        left: 0.75rem;
        display: flex;
        align-items: center;
        gap: 0.25rem;
        padding: 0.375rem 0.75rem;
        border-radius: 9999px;
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(8px);
        font-size: 0.875rem;
        font-weight: 600;
        color: var(--text-main);
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        z-index: 2;
    }

    .badge-icon {
        font-size: 1rem;
        color: var(--primary);
    }

    /* Nút yêu thích - góc trên bên phải */
    .recipe-favorite {
        position: absolute;
        top: 0.75rem;
        right: 0.75rem;
        width: 2.5rem;
        height: 2.5rem;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(8px);
        border: none;
        cursor: pointer;
        transition: all 0.3s;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        z-index: 2;
    }

    .recipe-favorite:hover {
        transform: scale(1.1);
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    }

    .recipe-favorite .material-symbols-outlined {
        font-size: 1.5rem;
        color: #cbd5e1;
        transition: all 0.3s;
    }

    /* Trạng thái đã yêu thích */
    .recipe-favorite.favorited .material-symbols-outlined,
    .recipe-favorite .material-symbols-outlined.filled {
        color: var(--primary);
        font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24;
    }

    .recipe-content {
        padding: 1.25rem;
        display: flex;
        flex-direction: column;
        gap: 0.75rem;
        flex: 1;
    }

    .recipe-category {
        display: inline-block;
        padding: 0.25rem 0.75rem;
        border-radius: 9999px;
        background: #fff4ed;
        color: var(--primary);
        font-size: 0.75rem;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        width: fit-content;
    }

    .recipe-title {
        font-size: 1.125rem;
        font-weight: 700;
        color: var(--text-main);
        line-height: 1.4;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }

    .recipe-meta {
        display: flex;
        align-items: center;
        gap: 1rem;
        flex-wrap: wrap;
        font-size: 0.875rem;
        color: var(--text-secondary);
    }

    .recipe-meta-item {
        display: flex;
        align-items: center;
        gap: 0.25rem;
    }

    .recipe-meta-item .material-symbols-outlined {
        font-size: 1.125rem;
    }

    .recipe-author {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        margin-left: auto;
        font-weight: 500;
    }
    
    .recipe-author-avatar {
        width: 1.5rem;
        height: 1.5rem;
        border-radius: 50%;
        object-fit: cover;
        border: 1.5px solid white;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
    }
    
    .recipe-author-name {
        font-size: 0.875rem;
        color: var(--text-secondary);
    }

    .recipe-btn {
        width: 100%;
        padding: 0.75rem;
        border-radius: 0.5rem;
        background: var(--primary);
        color: white;
        font-weight: 600;
        text-align: center;
        transition: all 0.3s;
        border: none;
        cursor: pointer;
        margin-top: auto;
        text-decoration: none;
        display: block;
    }

    .recipe-btn:hover {
        background: var(--primary-hover);
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.15);
    }
</style>

<!-- HERO SECTION -->
<div class="hero-section">
    <div class="hero-container">
        <div class="hero-banner">
            <div class="hero-content">
                <h1 class="hero-title">
                    Khám Phá Hương Vị Tuyệt Vời
                </h1>
                <p class="hero-subtitle">
                    Hàng nghìn công thức nấu ăn từ khắp nơi trên thế giới, được chia sẻ bởi cộng đồng đam mê ẩm thực
                </p>
                <div class="hero-cta">
                    <a href="<%= request.getContextPath() %>/CongThucServlet" class="hero-btn">
                        Khám Phá Ngay
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- CATEGORIES SECTION -->
<div class="categories-section">
    <div class="container">
        <div class="section-header">
            <h2 class="section-title">Danh Mục Công Thức</h2>
            <p class="section-subtitle">Khám phá các món ăn theo sở thích của bạn</p>
        </div>

        <div class="categories-slider-wrapper">
            <button onclick="scrollCategoriesLeft()" class="slider-btn slider-btn-left">
                <span class="material-symbols-outlined">chevron_left</span>
            </button>

            <div class="categories-slider" id="categoriesSlider">
                <% if (categories != null && !categories.isEmpty()) {
                    for (danhmuc category : categories) { 
                        String categoryImage = category.getImageUrl();
                        if (categoryImage == null || categoryImage.isEmpty()) {
                            categoryImage = "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800";
                        }
                %>
                <a href="<%= request.getContextPath() %>/CongThucServlet?keyword=&sort=&category=<%= category.getCategoryId() %>&difficulty=all&time=all"
                   class="category-card-slider"
                   style="background-image: url('<%= categoryImage %>')">
                    <div class="category-overlay">
                        <h3 class="category-name"><%= category.getCategoryName() %></h3>
                    </div>
                </a>
                <% } } %>
            </div>

            <button onclick="scrollCategoriesRight()" class="slider-btn slider-btn-right">
                <span class="material-symbols-outlined">chevron_right</span>
            </button>
        </div>
    </div>
</div>

<!-- TOP VIEWED SECTION -->
<div class="top-viewed-section">
    <div class="container">
        <div class="section-header">
            <h2 class="section-title">Các Công Thức Nổi Bật</h2>
            <p class="section-subtitle">Những công thức được cộng đồng xem nhiều nhất</p>
        </div>

        <div class="slider-wrapper">
            <button onclick="scrollLeftTop()" class="slider-btn slider-btn-left">
                <span class="material-symbols-outlined">chevron_left</span>
            </button>

            <div class="slider-container" id="topViewedSlider">
                <% if (topViewed != null && !topViewed.isEmpty()) {
                    for (congthuc recipe : topViewed) { 
                        boolean isFavorited = false;
                        if (currentUser != null) {
                            isFavorited = ytDao.isFavorite(currentUser.getUserId(), recipe.getRecipeId());
                        }
                %>
                <div class="slider-card">
                    <div class="recipe-card">
                        <div class="recipe-image-wrapper">
                            <!-- Badge số lượt xem -->
                            <div class="recipe-badge">
                                <span class="material-symbols-outlined badge-icon">visibility</span>
                                <%= recipe.getViewCount() %>
                            </div>

                            <!-- Nút yêu thích -->
                            <% if (currentUser != null) { %>
                            <button class="recipe-favorite <%= isFavorited ? "favorited" : "" %>" 
                                    onclick="toggleFavorite(<%= recipe.getRecipeId() %>, this)"
                                    data-recipe-id="<%= recipe.getRecipeId() %>">
                                <span class="material-symbols-outlined <%= isFavorited ? "filled" : "" %>">favorite</span>
                            </button>
                            <% } %>

                            <img src="<%= recipe.getImageUrl() %>"
                                 alt="<%= recipe.getTitle() %>"
                                 class="recipe-image">
                        </div>

                        <div class="recipe-content">
                            <span class="recipe-category">
                                <%= recipe.getCategoryName() %>
                            </span>

                            <h3 class="recipe-title">
                                <%= recipe.getTitle() %>
                            </h3>

                            <div class="recipe-meta">
                                <div class="recipe-meta-item">
                                    <span class="material-symbols-outlined">schedule</span>
                                    <%= recipe.getCookingTime() %>p
                                </div>

                                <div class="recipe-meta-item">
                                    <span class="material-symbols-outlined">bar_chart</span>
                                    <% if ("easy".equals(recipe.getDifficultyLevel())) { %>
                                        Dễ
                                    <% } else if ("medium".equals(recipe.getDifficultyLevel())) { %>
                                        TB
                                    <% } else { %>
                                        Khó
                                    <% } %>
                                </div>

                                <div class="recipe-author">
								    <img src="<%= request.getContextPath() %>/avatars/<%= recipe.getAuthorAvatar() != null ? recipe.getAuthorAvatar() : "avatar1" %>.jpg" 
								         alt="<%= recipe.getAuthorName() %>"
								         class="recipe-author-avatar"
								         onerror="this.src='<%= request.getContextPath() %>/avatars/avatar1.jpg'">
								    <span class="recipe-author-name"><%= recipe.getAuthorName() %></span>
								</div>
                            </div>

                            <a href="<%= request.getContextPath() %>/ChiTietCongThucServlet?id=<%= recipe.getRecipeId() %>"
                               class="recipe-btn">
                                Xem Chi Tiết
                            </a>
                        </div>
                    </div>
                </div>
                <% } } %>
            </div>

            <button onclick="scrollRightTop()" class="slider-btn slider-btn-right">
                <span class="material-symbols-outlined">chevron_right</span>
            </button>
        </div>
    </div>
</div>

<!-- LATEST RECIPES SECTION -->
<div class="latest-recipes-section">
    <div class="container">
        <div class="section-header-simple">
            <h2 class="latest-title">Công Thức Mới Nhất</h2>
        </div>

        <div class="recipes-grid">
            <% if (latestRecipes != null && !latestRecipes.isEmpty()) {
                for (congthuc recipe : latestRecipes) { 
                    boolean isFavorited = false;
                    if (currentUser != null) {
                        isFavorited = ytDao.isFavorite(currentUser.getUserId(), recipe.getRecipeId());
                    }
            %>
            <div class="recipe-card">
                <div class="recipe-image-wrapper">
                    <!-- Badge số lượt xem -->
                    <div class="recipe-badge">
                        <span class="material-symbols-outlined badge-icon">visibility</span>
                        <%= recipe.getViewCount() %>
                    </div>

                    <!-- Nút yêu thích -->
                    <% if (currentUser != null) { %>
                    <button class="recipe-favorite <%= isFavorited ? "favorited" : "" %>" 
                            onclick="toggleFavorite(<%= recipe.getRecipeId() %>, this)"
                            data-recipe-id="<%= recipe.getRecipeId() %>">
                        <span class="material-symbols-outlined <%= isFavorited ? "filled" : "" %>">favorite</span>
                    </button>
                    <% } %>

                    <img src="<%= recipe.getImageUrl() %>"
                         alt="<%= recipe.getTitle() %>"
                         class="recipe-image" />
                </div>

                <div class="recipe-content">
                    <span class="recipe-category">
                        <%= recipe.getCategoryName() %>
                    </span>

                    <h3 class="recipe-title">
                        <%= recipe.getTitle() %>
                    </h3>

                    <div class="recipe-meta">
                        <div class="recipe-meta-item">
                            <span class="material-symbols-outlined">schedule</span>
                            <%= recipe.getCookingTime() %>p
                        </div>

                        <div class="recipe-meta-item">
                            <span class="material-symbols-outlined">bar_chart</span>
                            <% if ("easy".equals(recipe.getDifficultyLevel())) { %>
                                Dễ
                            <% } else if ("medium".equals(recipe.getDifficultyLevel())) { %>
                                TB
                            <% } else { %>
                                Khó
                            <% } %>
                        </div>

                        <span class="recipe-author">
                            <%= recipe.getAuthorName() %>
                        </span>
                    </div>

                    <a href="<%= request.getContextPath() %>/ChiTietCongThucServlet?id=<%= recipe.getRecipeId() %>"
                       class="recipe-btn">
                        Xem Chi Tiết
                    </a>
                </div>
            </div>
            <% } } else { %>
            <div class="empty-state">
                Chưa có công thức nào
            </div>
            <% } %>
        </div>

        <% if (latestRecipes != null && latestRecipes.size() >= 6) { %>
        <div class="view-more-container">
            <a href="<%= request.getContextPath() %>/CongThucServlet?keyword=&sort=latest&category=all&difficulty=all&time=all" class="view-more-btn">
                Xem thêm công thức
            </a>
        </div>
        <% } %>
    </div>
</div>

<script>
    function scrollCategoriesLeft() {
        const slider = document.getElementById('categoriesSlider');
        slider.scrollBy({ left: -320, behavior: 'smooth' });
    }

    function scrollCategoriesRight() {
        const slider = document.getElementById('categoriesSlider');
        slider.scrollBy({ left: 320, behavior: 'smooth' });
    }

    function scrollLeftTop() {
        const slider = document.getElementById('topViewedSlider');
        slider.scrollBy({ left: -350, behavior: 'smooth' });
    }

    function scrollRightTop() {
        const slider = document.getElementById('topViewedSlider');
        slider.scrollBy({ left: 350, behavior: 'smooth' });
    }
    
    // Toggle favorite function
    function toggleFavorite(recipeId, button) {
        <% if (currentUser == null) { %>
            alert('Vui lòng đăng nhập để sử dụng chức năng này!');
            window.location.href = '<%= request.getContextPath() %>/LoginServlet';
            return;
        <% } %>

        fetch('<%= request.getContextPath() %>/ThemYeuThichServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'recipeId=' + recipeId
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                const icon = button.querySelector('.material-symbols-outlined');
                if (data.isFavorited) {
                    // Đã thêm vào yêu thích
                    button.classList.add('favorited');
                    icon.classList.add('filled');
                    showMessage('Đã thêm vào yêu thích!', 'success');
                } else {
                    // Đã bỏ yêu thích
                    button.classList.remove('favorited');
                    icon.classList.remove('filled');
                    showMessage('Đã bỏ yêu thích!', 'success');
                }
            } else {
                showMessage(data.message || 'Có lỗi xảy ra!', 'error');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showMessage('Có lỗi xảy ra. Vui lòng thử lại!', 'error');
        });
    }

    // Show message function
    function showMessage(message, type) {
        const msgDiv = document.createElement('div');
        msgDiv.textContent = message;
        msgDiv.style.position = 'fixed';
        msgDiv.style.top = '20px';
        msgDiv.style.right = '20px';
        msgDiv.style.padding = '1rem 1.5rem';
        msgDiv.style.borderRadius = '0.5rem';
        msgDiv.style.color = 'white';
        msgDiv.style.fontWeight = '600';
        msgDiv.style.zIndex = '9999';
        msgDiv.style.boxShadow = '0 4px 6px rgba(0,0,0,0.1)';
        msgDiv.style.animation = 'slideIn 0.3s ease-out';
        
        if (type === 'success') {
            msgDiv.style.backgroundColor = '#10b981';
        } else {
            msgDiv.style.backgroundColor = '#ef4444';
        }
        
        document.body.appendChild(msgDiv);
        
        setTimeout(function() {
            msgDiv.style.animation = 'slideOut 0.3s ease-out';
            setTimeout(function() {
                msgDiv.remove();
            }, 300);
        }, 3000);
    }

    // Add CSS animations
    const style = document.createElement('style');
    style.textContent = `
        @keyframes slideIn {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
        @keyframes slideOut {
            from {
                transform: translateX(0);
                opacity: 1;
            }
            to {
                transform: translateX(100%);
                opacity: 0;
            }
        }
    `;
    document.head.appendChild(style);
</script>

<!-- Include Footer -->
<jsp:include page="include/footer.jsp" />
