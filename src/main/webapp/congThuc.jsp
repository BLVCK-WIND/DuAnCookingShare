<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="Model.congthuc" %>
<%@ page import="Model.danhmuc" %>
<%@ page import="Model.user" %>
<%@ page import="Model.yeuthichdao" %>
<%
	user currentUser = (user) session.getAttribute("user_user");
    List<congthuc> recipes = (List<congthuc>) request.getAttribute("recipes");
    List<danhmuc> categories = (List<danhmuc>) request.getAttribute("categories");
    
    Integer totalRecipes = (Integer) request.getAttribute("totalRecipes");
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    
    String selectedKeyword = (String) request.getAttribute("selectedKeyword");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    String selectedDifficulty = (String) request.getAttribute("selectedDifficulty");
    String selectedTime = (String) request.getAttribute("selectedTime");
    String selectedSort = (String) request.getAttribute("selectedSort");
    
    if (selectedKeyword == null) selectedKeyword = "";
    if (selectedCategory == null) selectedCategory = "all";
    if (selectedDifficulty == null) selectedDifficulty = "all";
    if (selectedTime == null) selectedTime = "all";
    if (selectedSort == null) selectedSort = "";
    if (currentPage == null) currentPage = 1;
    if (totalPages == null) totalPages = 0;
    
    // Khởi tạo DAO để kiểm tra trạng thái yêu thích
    yeuthichdao ytDao = new yeuthichdao();
%>

<!-- Include Header -->
<%
    request.setAttribute("pageTitle", "Khám Phá Công Thức - CookingShare");
%>
<jsp:include page="include/header.jsp" />

<!-- Page-specific styles -->
<style>
     /* === HERO SECTION === */
    .hero-section {
        width: 100%;
        padding: 2rem 2.5rem 2.5rem;
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
        min-height: 320px;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        text-align: center;
        padding: 2rem;
        background: linear-gradient(rgba(0, 0, 0, 0.4) 0%, rgba(0, 0, 0, 0.6) 100%),
                    url('https://images.unsplash.com/photo-1505935428862-770b6f24f629?w=1200');
        background-size: cover;
        background-position: center;
        box-shadow: 0 10px 15px rgba(0,0,0,0.1);
    }

    .hero-content {
        display: flex;
        flex-direction: column;
        gap: 0.75rem;
        max-width: 48rem;
        z-index: 10;
        margin-bottom: 1.5rem;
    }

    .hero-title {
        color: white;
        font-size: 2.5rem;
        font-weight: 900;
        line-height: 1.2;
        text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
    }

    .hero-subtitle {
        color: #e5e5e5;
        font-size: 1rem;
        font-weight: 500;
    }

    .search-container {
        width: 100%;
        max-width: 600px;
        z-index: 10;
    }

    .search-form {
        display: flex;
        background: white;
        border-radius: 9999px;
        overflow: hidden;
        box-shadow: 0 10px 25px rgba(0,0,0,0.15);
    }

    .search-icon-wrapper {
        display: flex;
        align-items: center;
        padding-left: 1.5rem;
        color: var(--text-secondary);
    }

    .search-input {
        flex: 1;
        padding: 1rem 1rem 1rem 0.75rem;
        border: none;
        outline: none;
        font-size: 1rem;
        font-family: inherit;
    }

    .search-btn {
        padding: 0 2rem;
        background-color: var(--primary);
        color: white;
        font-weight: 700;
        border: none;
        cursor: pointer;
        transition: background-color 0.3s;
        white-space: nowrap;
    }

    .search-btn:hover {
        background-color: var(--primary-hover);
    }

    /* === MAIN CONTENT === */
    .content-section {
        width: 100%;
        padding: 0 2.5rem 3rem;
        display: flex;
        justify-content: center;
    }

    .container {
        max-width: 1280px;
        width: 100%;
        display: flex;
        gap: 2rem;
    }

    /* === SIDEBAR === */
    .sidebar {
        width: 280px;
        flex-shrink: 0;
    }

    .filter-box {
        background: white;
        border-radius: 0.75rem;
        border: 1px solid var(--border-color);
        padding: 1.5rem;
        margin-bottom: 1.5rem;
    }

    .filter-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 1.25rem;
    }

    .filter-title {
        font-size: 1rem;
        font-weight: 700;
        color: var(--text-main);
    }

    .clear-filter {
        font-size: 0.75rem;
        color: var(--primary);
        font-weight: 600;
        cursor: pointer;
        transition: opacity 0.3s;
    }

    .clear-filter:hover {
        opacity: 0.8;
    }

    .filter-section {
        margin-bottom: 1.25rem;
    }

    .filter-section:last-child {
        margin-bottom: 0;
    }

    .filter-label {
        font-size: 0.75rem;
        font-weight: 700;
        color: var(--text-main);
        text-transform: uppercase;
        letter-spacing: 0.05em;
        margin-bottom: 0.75rem;
        display: block;
    }

    .filter-select {
        width: 100%;
        padding: 0.5rem 0.75rem;
        border: 1px solid var(--input-border);
        border-radius: 0.5rem;
        font-size: 0.875rem;
        background: white;
        color: var(--text-main);
        cursor: pointer;
        transition: border-color 0.3s;
    }

    .filter-select:focus {
        outline: none;
        border-color: var(--primary);
    }

    .filter-radio-group {
        display: flex;
        flex-direction: column;
        gap: 0.625rem;
    }

    .filter-radio-item {
        display: flex;
        align-items: center;
        cursor: pointer;
    }

    .filter-radio-item input[type="radio"] {
        width: 1.125rem;
        height: 1.125rem;
        cursor: pointer;
        margin-right: 0.625rem;
        accent-color: var(--primary);
    }

    .filter-radio-item label {
        flex: 1;
        cursor: pointer;
        font-size: 0.875rem;
        color: var(--text-main);
    }

    /* === MAIN CONTENT AREA === */
    .main-content {
        flex: 1;
        min-width: 0;
    }

    .recipes-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 1.5rem;
        flex-wrap: wrap;
        gap: 1rem;
    }

    .results-count {
        font-size: 0.875rem;
        color: var(--text-secondary);
        font-weight: 500;
    }

    .results-count strong {
        color: var(--text-main);
        font-weight: 700;
    }

    .filter-tabs {
        display: flex;
        gap: 0.5rem;
        flex-wrap: wrap;
    }

    .filter-tab {
        padding: 0.5rem 1rem;
        border-radius: 9999px;
        background: white;
        border: 1px solid var(--border-color);
        color: var(--text-main);
        font-size: 0.875rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
    }

    .filter-tab:hover {
        background: #fff4ed;
        border-color: var(--primary);
        color: var(--primary);
    }

    .filter-tab.active {
        background: var(--primary);
        border-color: var(--primary);
        color: white;
    }

    /* === RECIPES GRID === */
    .recipes-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
        gap: 1.5rem;
        margin-bottom: 2rem;
    }

    @media (min-width: 768px) {
        .recipes-grid {
            grid-template-columns: repeat(2, 1fr);
        }
    }

    @media (min-width: 1024px) {
        .recipes-grid {
            grid-template-columns: repeat(3, 1fr);
        }
    }

    /* === RECIPE CARD === */
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
        padding-top: 75%;
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
        transition: transform 0.5s;
    }

    .recipe-card:hover .recipe-image {
        transform: scale(1.05);
    }

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

    .recipe-favorite-count {
        position: absolute;
        bottom: 0.75rem;
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

    .favorite-count-icon {
        font-size: 1rem;
        color: var(--primary);
        font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24;
    }

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

    .recipe-card:hover .recipe-title {
        color: var(--primary);
    }

    .recipe-meta {
        display: flex;
        align-items: center;
        gap: 1rem;
        flex-wrap: wrap;
        font-size: 0.875rem;
        color: var(--text-secondary);
        padding-top: 0.5rem;
        border-top: 1px solid #f3f4f6;
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

    /* === PAGINATION === */
    .pagination-wrapper {
        display: flex;
        justify-content: center;
        margin: 2.5rem 0 2rem;
    }

    .pagination {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        flex-wrap: wrap;
    }

    .page-btn {
        min-width: 2.5rem;
        height: 2.5rem;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 0 0.75rem;
        border-radius: 0.5rem;
        background: white;
        border: 1px solid var(--border-color);
        color: var(--text-main);
        font-size: 0.875rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
        text-decoration: none;
    }

    .page-btn:hover:not(.active):not(:disabled) {
        background: #fff4ed;
        border-color: var(--primary);
        color: var(--primary);
    }

    .page-btn.active {
        background: var(--primary);
        border-color: var(--primary);
        color: white;
        cursor: default;
    }

    .page-btn:disabled {
        opacity: 0.4;
        cursor: not-allowed;
    }

    .page-btn .material-symbols-outlined {
        font-size: 1.25rem;
    }

    .page-ellipsis {
        padding: 0 0.5rem;
        color: var(--text-secondary);
        font-weight: 600;
    }

    /* === EMPTY STATE === */
    .empty-state {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        padding: 4rem 2rem;
        text-align: center;
    }

    .empty-icon {
        font-size: 4rem;
        color: var(--text-secondary);
        margin-bottom: 1rem;
    }

    .empty-title {
        font-size: 1.5rem;
        font-weight: 700;
        color: var(--text-main);
        margin-bottom: 0.5rem;
    }

    .empty-description {
        font-size: 1rem;
        color: var(--text-secondary);
        margin-bottom: 1.5rem;
    }


    /* ✅ FILTER ACTIONS - NÚT ÁP DỤNG BỘ LỌC */
    .filter-actions {
        display: flex;
        gap: 0.75rem;
        margin-top: 1.5rem;
        padding-top: 1.5rem;
        border-top: 1px solid var(--border-color);
    }

    .btn-apply-filter {
        flex: 1;
        background: var(--primary);
        color: white;
        border: none;
        padding: 0.75rem 1.5rem;
        border-radius: 0.5rem;
        font-weight: 600;
        font-size: 0.875rem;
        cursor: pointer;
        transition: all 0.3s;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
    }

    .btn-apply-filter:hover {
        background: #d5701a;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(238, 108, 43, 0.3);
    }

    .btn-reset-filter {
        background: white;
        color: var(--text-secondary);
        border: 1px solid var(--border-color);
        padding: 0.75rem 1rem;
        border-radius: 0.5rem;
        font-weight: 600;
        font-size: 0.875rem;
        cursor: pointer;
        transition: all 0.3s;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
    }

    .btn-reset-filter:hover {
        background: var(--bg-light);
        color: var(--primary);
        border-color: var(--primary);
    }
    /* === RESPONSIVE === */
    @media (max-width: 1024px) {
        .sidebar {
            display: none;
        }
    }

    @media (max-width: 768px) {
        .hero-title {
            font-size: 1.875rem;
        }

        .search-btn {
            padding: 0 1.5rem;
        }
    }
</style>

<!-- Hero Section -->
<section class="hero-section">
    <div class="hero-container">
        <div class="hero-banner">
            <div class="hero-content">
                <h1 class="hero-title">Khám Phá Thế Giới Ẩm Thực</h1>
                <p class="hero-subtitle">Hàng nghìn công thức nấu ăn đang chờ bạn khám phá</p>
            </div>

            <div class="search-container">
                <form action="<%= request.getContextPath() %>/CongThucServlet" method="get" class="search-form">
                    <div class="search-icon-wrapper">
                        <span class="material-symbols-outlined">search</span>
                    </div>
                    <input type="text" 
                           name="keyword" 
                           class="search-input" 
                           placeholder="Tìm kiếm công thức..." 
                           value="<%= selectedKeyword %>">
                    <button type="submit" class="search-btn">Tìm kiếm</button>
                </form>
            </div>
        </div>
    </div>
</section>

<!-- Main Content -->
<div class="content-section">
    <div class="container">
        <!-- Sidebar Filter -->
        <aside class="sidebar">
            <form id="filterForm" action="<%= request.getContextPath() %>/CongThucServlet" method="get">
                <input type="hidden" name="keyword" value="<%= selectedKeyword %>">
                <input type="hidden" name="sort" value="<%= selectedSort %>">
                
                <div class="filter-box">
                    <div class="filter-header">
                        <h3 class="filter-title">Bộ lọc</h3>
                        <a href="<%= request.getContextPath() %>/CongThucServlet" class="clear-filter">Xóa bộ lọc</a>
                    </div>

                    <!-- Category Filter -->
                    <div class="filter-section">
                        <label class="filter-label">Danh mục</label>
                        <select name="category" class="filter-select">
                            <option value="all" <%= "all".equals(selectedCategory) ? "selected" : "" %>>Tất cả</option>
                            <% if (categories != null) {
                                for (danhmuc cat : categories) { %>
                                    <option value="<%= cat.getCategoryId() %>" 
                                            <%= String.valueOf(cat.getCategoryId()).equals(selectedCategory) ? "selected" : "" %>>
                                        <%= cat.getCategoryName() %>
                                    </option>
                                <% }
                            } %>
                        </select>
                    </div>

                    <!-- Difficulty Filter -->
                    <div class="filter-section">
                        <label class="filter-label">Độ khó</label>
                        <div class="filter-radio-group">
                            <div class="filter-radio-item">
                                <input type="radio" id="diff-all" name="difficulty" value="all" 
                                       <%= "all".equals(selectedDifficulty) ? "checked" : "" %>
                                       >
                                <label for="diff-all">Tất cả</label>
                            </div>
                            <div class="filter-radio-item">
                                <input type="radio" id="diff-easy" name="difficulty" value="easy" 
                                       <%= "easy".equals(selectedDifficulty) ? "checked" : "" %>
                                       >
                                <label for="diff-easy">Dễ</label>
                            </div>
                            <div class="filter-radio-item">
                                <input type="radio" id="diff-medium" name="difficulty" value="medium" 
                                       <%= "medium".equals(selectedDifficulty) ? "checked" : "" %>
                                       >
                                <label for="diff-medium">Trung bình</label>
                            </div>
                            <div class="filter-radio-item">
                                <input type="radio" id="diff-hard" name="difficulty" value="hard" 
                                       <%= "hard".equals(selectedDifficulty) ? "checked" : "" %>
                                       >
                                <label for="diff-hard">Khó</label>
                            </div>
                        </div>
                    </div>

                    <!-- Time Filter -->
                    <div class="filter-section">
                        <label class="filter-label">Thời gian nấu</label>
                        <div class="filter-radio-group">
                            <div class="filter-radio-item">
                                <input type="radio" id="time-all" name="time" value="all" 
                                       <%= "all".equals(selectedTime) ? "checked" : "" %>
                                       >
                                <label for="time-all">Tất cả</label>
                            </div>
                            <div class="filter-radio-item">
                                <input type="radio" id="time-fast" name="time" value="fast" 
                                       <%= "fast".equals(selectedTime) ? "checked" : "" %>
                                       >
                                <label for="time-fast">Dưới 15 phút</label>
                            </div>
                            <div class="filter-radio-item">
                                <input type="radio" id="time-quick" name="time" value="quick" 
                                       <%= "quick".equals(selectedTime) ? "checked" : "" %>
                                       >
                                <label for="time-quick">15-30 phút</label>
                            </div>
                            <div class="filter-radio-item">
                                <input type="radio" id="time-medium" name="time" value="medium" 
                                       <%= "medium".equals(selectedTime) ? "checked" : "" %>
                                       >
                                <label for="time-medium">30-60 phút</label>
                            </div>
                            <div class="filter-radio-item">
                                <input type="radio" id="time-long" name="time" value="long" 
                                       <%= "long".equals(selectedTime) ? "checked" : "" %>
                                       >
                                <label for="time-long">Trên 60 phút</label>
                            </div>
                        </div>
                    </div>

                    <!-- ✅ NÚT ÁP DỤNG BỘ LỌC -->
                    <div class="filter-actions">
                        <button type="submit" class="btn-apply-filter">
                            <span class="material-symbols-outlined" style="font-size: 1.125rem;">check_circle</span>
                            Áp dụng bộ lọc
                        </button>
                    </div>
                </div>
            </form>
        </aside>

        <!-- Main Content Area -->
        <div class="main-content">
            <!-- Sort Tabs -->
            <div class="filter-tabs" style="margin-bottom: 20px">
                <button onclick="applySort('')" class="filter-tab <%= "".equals(selectedSort) ? "active" : "" %>">
                    Tất cả
                </button>
                <button onclick="applySort('latest')" class="filter-tab <%= "latest".equals(selectedSort) ? "active" : "" %>">
                    Mới nhất
                </button>
                <button onclick="applySort('view')" class="filter-tab <%= "view".equals(selectedSort) ? "active" : "" %>">
                    Yêu thích nhất
                </button>
            </div>

            <!-- Recipes Grid -->
            <% if (recipes != null && !recipes.isEmpty()) { %>
                <div class="recipes-grid">
                    <% for (congthuc recipe : recipes) { 
                        boolean isFavorited = false;
                        if (currentUser != null) {
                            isFavorited = ytDao.isFavorite(currentUser.getUserId(), recipe.getRecipeId());
                        }
                    %>
                        <div class="recipe-card">
                            <!-- Image -->
                            <div class="recipe-image-wrapper">
                                <!-- Badge số lượt xem - góc trên bên trái -->
                                <div class="recipe-badge">
                                    <span class="material-symbols-outlined badge-icon">visibility</span>
                                    <%= recipe.getViewCount() %>
                                </div>

                                <!-- ✅ NEW: Badge số lượt yêu thích - góc dưới bên trái -->
                                <div class="recipe-favorite-count">
                                    <span class="material-symbols-outlined favorite-count-icon">favorite</span>
                                    <%= recipe.getTotalFavorites() %>
                                </div>

                                <!-- Nút yêu thích - góc trên bên phải -->
                                <% if (currentUser != null) { %>
                                <button class="recipe-favorite <%= isFavorited ? "favorited" : "" %>" 
                                        onclick="toggleFavorite(<%= recipe.getRecipeId() %>, this)"
                                        data-recipe-id="<%= recipe.getRecipeId() %>">
                                    <span class="material-symbols-outlined <%= isFavorited ? "filled" : "" %>">favorite</span>
                                </button>
                                <% } %>

                                <img src="<%= recipe.getImageUrl() %>"
                                     alt="<%= recipe.getTitle() %>"
                                     class="recipe-image"/>
                            </div>

                            <!-- Content -->
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
                    <% } %>
                </div>

                <!-- Pagination -->
                <% if (totalPages > 1) { %>
                <div class="pagination-wrapper">
                    <div class="pagination">
                        <!-- Previous Button -->
                        <button class="page-btn" 
                                onclick="goToPage(<%= currentPage - 1 %>)"
                                <%= currentPage <= 1 ? "disabled" : "" %>>
                            <span class="material-symbols-outlined">chevron_left</span>
                        </button>

                        <!-- Page Numbers -->
                        <% 
                        int startPage = Math.max(1, currentPage - 2);
                        int endPage = Math.min(totalPages, currentPage + 2);
                        
                        // Show first page if not in range
                        if (startPage > 1) { %>
                            <button class="page-btn" onclick="goToPage(1)">1</button>
                            <% if (startPage > 2) { %>
                                <span class="page-ellipsis">...</span>
                            <% } %>
                        <% }
                        
                        // Show page range
                        for (int i = startPage; i <= endPage; i++) { %>
                            <button class="page-btn <%= i == currentPage ? "active" : "" %>" 
                                    onclick="goToPage(<%= i %>)">
                                <%= i %>
                            </button>
                        <% }
                        
                        // Show last page if not in range
                        if (endPage < totalPages) { %>
                            <% if (endPage < totalPages - 1) { %>
                                <span class="page-ellipsis">...</span>
                            <% } %>
                            <button class="page-btn" onclick="goToPage(<%= totalPages %>)"><%= totalPages %></button>
                        <% } %>

                        <!-- Next Button -->
                        <button class="page-btn" 
                                onclick="goToPage(<%= currentPage + 1 %>)"
                                <%= currentPage >= totalPages ? "disabled" : "" %>>
                            <span class="material-symbols-outlined">chevron_right</span>
                        </button>
                    </div>
                </div>
                <% } %>

            <% } else { %>
                <!-- Empty State -->
                <div class="empty-state">
                    <span class="material-symbols-outlined empty-icon">search_off</span>
                    <h3 class="empty-title">Không tìm thấy công thức nào</h3>
                    <p class="empty-description">Thử thay đổi bộ lọc hoặc tìm kiếm từ khóa khác</p>
                    <a href="<%= request.getContextPath() %>/CongThucServlet" class="btn-register">
                        Xem tất cả công thức
                    </a>
                </div>
            <% } %>
        </div>
    </div>
</div>

<script>
    function applySort(sortValue) {
        const form = document.getElementById('filterForm');
        form.querySelector('input[name="sort"]').value = sortValue;
        form.submit();
    }
    
    // ✅ HÀM RESET FILTER
    function resetFilter() {
        window.location.href = '<%= request.getContextPath() %>/CongThucServlet';
    }
    
    function goToPage(page) {
        const form = document.getElementById('filterForm');
        let pageInput = form.querySelector('input[name="page"]');
        if (!pageInput) {
            pageInput = document.createElement('input');
            pageInput.type = 'hidden';
            pageInput.name = 'page';
            form.appendChild(pageInput);
        }
        pageInput.value = page;
        form.submit();
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
