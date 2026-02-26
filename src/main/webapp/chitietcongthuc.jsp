<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.congthuc" %>
<%@ page import="Model.user" %>
<%@ page import="java.util.List" %>
<%!
    // ✅ HELPER METHOD: Xử lý URL ảnh
    public static String getImageUrl(HttpServletRequest req, String imageUrl) {
        if (imageUrl == null || imageUrl.trim().isEmpty()) {
            return req.getContextPath() + "/images/default-recipe.jpg";
        }
        
        // Nếu là URL từ internet
        if (imageUrl.startsWith("http://") || imageUrl.startsWith("https://")) {
            return imageUrl;
        }
        
        // Nếu là đường dẫn local
        return req.getContextPath() + "/" + imageUrl;
    }
%>
<%
    user currentUser = (user) session.getAttribute("user_user");
    congthuc recipe = (congthuc) request.getAttribute("recipe");
    Boolean isFavorited = (Boolean) request.getAttribute("isFavorited");
    List<congthuc> relatedRecipes = (List<congthuc>) request.getAttribute("relatedRecipes");
    
    if (isFavorited == null) isFavorited = false;
%>

<!-- Include Header -->
<%
    request.setAttribute("pageTitle", recipe.getTitle() + " - CookingShare");
%>
<jsp:include page="include/header.jsp" />

<style>
    /* Recipe Detail Specific Styles */
    .recipe-detail-container {
        width: 100%;
        max-width: 1280px;
        margin: 0 auto;
        padding: 2rem 2.5rem;
    }
    
    /* Breadcrumb */
    .breadcrumb {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        font-size: 0.75rem;
        color: var(--text-secondary);
        margin-bottom: 1.5rem;
    }
    
    .breadcrumb a {
        color: var(--text-secondary);
        transition: color 0.3s;
    }
    
    .breadcrumb a:hover {
        color: var(--primary);
    }
    
    .breadcrumb span:last-child {
        color: var(--text-main);
        font-weight: 600;
    }
    
    /* Hero Section */
    .recipe-hero {
        display: grid;
        grid-template-columns: 1fr;
        gap: 2rem;
        margin-bottom: 3rem;
    }
    
    @media (min-width: 1024px) {
        .recipe-hero {
            grid-template-columns: 7fr 5fr;
            gap: 2.5rem;
        }
    }
    
    .recipe-image-container {
        position: relative;
        border-radius: 1.5rem;
        overflow: hidden;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        aspect-ratio: 16/9;
    }
    
    @media (min-width: 1024px) {
        .recipe-image-container {
            height: 420px;
            aspect-ratio: auto;
        }
    }
    
    .recipe-main-image {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.7s;
    }
    
    .recipe-image-container:hover .recipe-main-image {
        transform: scale(1.05);
    }
    
    .recipe-category-badge {
        position: absolute;
        top: 1rem;
        left: 1rem;
        background: rgba(255, 255, 255, 0.9);
        backdrop-filter: blur(10px);
        color: var(--primary);
        font-size: 0.75rem;
        font-weight: 700;
        padding: 0.5rem 1rem;
        border-radius: 9999px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }
    
    /* Recipe Info */
    .recipe-info {
        display: flex;
        flex-direction: column;
    }
    
    .recipe-title {
        font-size: 2rem;
        font-weight: 900;
        color: var(--text-main);
        line-height: 1.2;
        margin-bottom: 1rem;
    }
    
    @media (min-width: 640px) {
        .recipe-title {
            font-size: 2.5rem;
        }
    }
    
    /* ✅ META ROW - NGANG, BÊN TRÁI */
    .recipe-meta-row {
        display: flex;
        align-items: center;
        gap: 1rem;
        margin-bottom: 1.5rem;
        flex-wrap: wrap;
    }
    
    .recipe-author {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        font-weight: 500;
        margin-left: 0 !important;
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
    
    .recipe-description {
        color: var(--primary);
        font-size: 0.9rem;
        font-weight:500;
        line-height: 1.6;
        margin-bottom: 1.5rem;
    }
    
    /* Stats Grid */
    .recipe-stats-grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 0.75rem;
        margin-bottom: 1.5rem;
    }
    
    .recipe-stat-card {
        background: var(--bg-light);
        padding: 0.75rem;
        border-radius: 0.75rem;
        border: 1px solid var(--border-color);
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }
    
    .stat-icon {
        width: 2rem;
        height: 2rem;
        border-radius: 50%;
        background: white;
        display: flex;
        align-items: center;
        justify-content: center;
        color: var(--primary);
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
    }
    
    .stat-icon .material-symbols-outlined {
        font-size: 1.125rem;
    }
    
    .stat-content {
        flex: 1;
    }
    
    .stat-label {
        font-size: 0.625rem;
        text-transform: uppercase;
        font-weight: 700;
        letter-spacing: 0.05em;
        color: var(--text-secondary);
        margin-bottom: 0.125rem;
    }
    
    .stat-value {
        font-size: 0.875rem;
        font-weight: 700;
        color: var(--text-main);
    }
    
    /* Action Buttons */
    .recipe-actions {
        display: flex;
        gap: 0.75rem;
        margin-top: auto;
    }
    
    .btn-favorite {
        flex: 1;
        background: var(--primary);
        color: white;
        font-size: 0.875rem;
        font-weight: 700;
        padding: 0.75rem 1rem;
        border-radius: 0.75rem;
        border: none;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
        transition: all 0.3s;
    }
    
    .btn-favorite:hover {
        background: #e65039;
        color: white !important;
        transform: translateY(-2px);
        box-shadow: 0 8px 15px rgba(255, 99, 71, 0.3);
    }
    
    .btn-favorite.favorited {
        background: #ff1744;
    }
    
    .btn-favorite.favorited:hover {
        background: #d50032;
        color: white !important;
    }
    
    .btn-share {
        width: 2.75rem;
        height: 2.75rem;
        border-radius: 0.75rem;
        border: 1px solid var(--border-color);
        background: white;
        color: var(--text-secondary);
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.3s;
    }
    
    .btn-share:hover {
        color: var(--primary);
        background: var(--bg-light);
        border-color: var(--primary);
    }
    
    /* Content Section */
    .recipe-content {
        display: grid;
        grid-template-columns: 1fr;
        gap: 2.5rem;
    }
    
    @media (min-width: 1024px) {
        .recipe-content {
            grid-template-columns: 350px 1fr;
            gap: 3rem;
        }
    }
    
    /* Ingredients Box */
    .ingredients-box {
        background: white;
        border: 1px solid var(--border-color);
        border-radius: 1rem;
        padding: 1.5rem;
        position: sticky;
        top: 6rem;
        height: fit-content;
    }
    
    .ingredients-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding-bottom: 1rem;
        margin-bottom: 1rem;
        border-bottom: 1px dashed var(--border-color);
    }
    
    .ingredients-title {
        font-size: 1.125rem;
        font-weight: 700;
        color: var(--text-main);
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    
    .ingredients-title .material-symbols-outlined {
        color: var(--primary);
    }
    
    .ingredients-count {
        font-size: 0.625rem;
        font-weight: 700;
        color: var(--primary);
        background: rgba(238, 108, 43, 0.1);
        padding: 0.25rem 0.5rem;
        border-radius: 9999px;
    }
    
    .ingredients-list {
        list-style: none;
        padding: 0;
        margin: 0;
        max-height: 500px;
        overflow-y: auto;
        padding-right: 0.25rem;
    }
    
    .ingredients-list::-webkit-scrollbar {
        width: 4px;
    }
    
    .ingredients-list::-webkit-scrollbar-track {
        background: transparent;
    }
    
    .ingredients-list::-webkit-scrollbar-thumb {
        background: var(--border-color);
        border-radius: 10px;
    }
    
    .ingredient-item {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        padding: 0.5rem;
        margin-bottom: 0.25rem;
        border-radius: 0.5rem;
        transition: background 0.3s;
        cursor: pointer;
    }
    
    .ingredient-item:hover {
        background: var(--bg-light);
    }
    
    .ingredient-checkbox {
        width: 1rem;
        height: 1rem;
        border-radius: 0.25rem;
        border: 2px solid #d1d5db;
        cursor: pointer;
        accent-color: var(--primary);
    }
    
    .ingredient-text {
        flex: 1;
        font-size: 0.875rem;
        color: var(--text-main);
    }
    
    /* Instructions Section */
    .chef-tip {
        background: #fff3e6;
        border-left: 4px solid var(--primary);
        padding: 1rem;
        border-radius: 0.5rem;
        display: flex;
        gap: 0.75rem;
        margin-bottom: 2rem;
    }
    
    .chef-tip .material-symbols-outlined {
        color: var(--primary);
        font-size: 1.25rem;
        flex-shrink: 0;
    }
    
    .chef-tip-title {
        font-weight: 700;
        font-size: 0.875rem;
        color: var(--text-main);
        margin-bottom: 0.25rem;
    }
    
    .chef-tip-text {
        font-size: 0.875rem;
        color: var(--text-secondary);
        line-height: 1.5;
    }
    
    .instructions-header {
        font-size: 1.25rem;
        font-weight: 700;
        color: var(--text-main);
        margin-bottom: 1.5rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    
    .instructions-header .material-symbols-outlined {
        color: var(--primary);
    }
    
    .instructions-list {
        display: flex;
        flex-direction: column;
        gap: 1.5rem;
    }
    
    .instruction-step {
        display: flex;
        gap: 1rem;
    }
    
    .step-number-container {
        display: flex;
        flex-direction: column;
        align-items: center;
    }
    
    .step-number {
        width: 2rem;
        height: 2rem;
        border-radius: 50%;
        background: var(--primary);
        color: white;
        font-weight: 700;
        font-size: 0.875rem;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 2px 8px rgba(238, 108, 43, 0.3);
        flex-shrink: 0;
    }
    
    .step-line {
        width: 2px;
        flex: 1;
        background: var(--border-color);
        margin-top: 0.5rem;
    }
    
    .step-content {
        flex: 1;
        padding-bottom: 1rem;
    }
    
    .step-title {
        font-size: 1rem;
        font-weight: 700;
        color: var(--text-main);
        margin-bottom: 0.5rem;
    }
    
    .step-description {
        background: white;
        padding: 1rem;
        border-radius: 0.75rem;
        border: 1px solid var(--border-color);
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
    }
    
    .step-text {
        color: var(--text-secondary);
        font-size: 0.875rem;
        line-height: 1.6;
    }
    
    /* Related Recipes */
    .related-section {
        margin-top: 4rem;
        padding-top: 2rem;
        border-top: 1px solid var(--border-color);
    }
    
    .related-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 1.5rem;
    }
    
    .related-title {
        font-size: 1.25rem;
        font-weight: 700;
        color: var(--text-main);
    }
    
    .related-view-all {
        color: var(--primary);
        font-size: 0.875rem;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 0.25rem;
        transition: gap 0.3s;
    }
    
    .related-view-all:hover {
        gap: 0.5rem;
    }
    
    .related-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 1rem;
    }
    
    @media (min-width: 768px) {
        .related-grid {
            grid-template-columns: repeat(4, 1fr);
            gap: 1.5rem;
        }
    }
    
    .related-card {
        background: white;
        border-radius: 0.75rem;
        overflow: hidden;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        transition: all 0.3s;
        border: 1px solid var(--border-color);
    }
    
    .related-card:hover {
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        transform: translateY(-2px);
    }
    
    .related-card-image-wrapper {
        aspect-ratio: 4/3;
        width: 100%;
        overflow: hidden;
    }
    
    .related-card-image {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.5s;
    }
    
    .related-card:hover .related-card-image {
        transform: scale(1.05);
    }
    
    .related-card-content {
        padding: 0.75rem;
    }
    
    .related-card-title {
        font-size: 0.875rem;
        font-weight: 700;
        color: var(--text-main);
        margin-bottom: 0.5rem;
        display: -webkit-box;
        -webkit-line-clamp: 1;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }
    
    .related-card:hover .related-card-title {
        color: var(--primary);
    }
    
    .related-card-meta {
        display: flex;
        align-items: center;
        justify-content: space-between;
    }
    
    .related-card-time {
        display: flex;
        align-items: center;
        gap: 0.25rem;
        font-size: 0.75rem;
        color: var(--text-secondary);
    }
    
    .related-card-time .material-symbols-outlined {
        font-size: 0.875rem;
    }
    
    .related-card-rating {
        display: flex;
        align-items: center;
        gap: 0.25rem;
        font-size: 0.75rem;
        color: var(--text-secondary);
    }
    
    .related-card-rating .material-symbols-outlined {
        font-size: 0.875rem;
    }
</style>

<main class="recipe-detail-container">
    <!-- Breadcrumb -->
    <nav class="breadcrumb">
        <a href="<%= request.getContextPath() %>/HomeServlet">Trang chủ</a>
        <span>/</span>
        <a href="<%= request.getContextPath() %>/CongThucServlet?category=<%= recipe.getCategoryId() %>">
            <%= recipe.getCategoryName() %>
        </a>
        <span>/</span>
        <span><%= recipe.getTitle() %></span>
    </nav>
    
    <!-- Hero Section -->
    <div class="recipe-hero">
        <!-- Image -->
        <div class="recipe-image-container">
            <!-- ✅ SỬA: Dùng helper method -->
            <img src="<%= getImageUrl(request, recipe.getImageUrl()) %>" 
                 alt="<%= recipe.getTitle() %>"
                 class="recipe-main-image"
                 onerror="this.src='<%= request.getContextPath() %>/images/default-recipe.jpg'">
            <div class="recipe-category-badge">
                <%= recipe.getCategoryName() %>
            </div>
        </div>
        
        <!-- Info -->
        <div class="recipe-info">
            <h1 class="recipe-title"><%= recipe.getTitle() %></h1>
            
            <!-- ✅ META ROW - AVATAR + LƯỢT XEM -->
            <div class="recipe-meta-row">
                <div class="recipe-author">
                    <!-- ✅ SỬA: Avatar cũng dùng helper method -->
                    <img src="<%= getImageUrl(request, "avatars/" + (recipe.getAuthorAvatar() != null ? recipe.getAuthorAvatar() : "avatar1") + ".jpg") %>" 
                         alt="<%= recipe.getAuthorName() %>"
                         class="recipe-author-avatar"
                         onerror="this.src='<%= request.getContextPath() %>/avatars/avatar1.jpg'">
                    <span class="recipe-author-name"><%= recipe.getAuthorName() %></span>
                </div>
                <span style="color: var(--text-secondary);">•</span>
                <span style="font-size: 0.875rem; color: var(--text-secondary);">
                    <%= recipe.getViewCount() %> lượt xem
                </span>
                <span style="color: var(--text-secondary);">•</span>
                <span style="font-size: 0.875rem; color: #ef4444; display: flex; align-items: center; gap: 0.25rem;">
			        <span class="material-symbols-outlined" style="font-size: 1rem; font-variation-settings: 'FILL' 1;">favorite</span>
			        <span id="favoriteCount"><%= recipe.getTotalFavorites() %></span> yêu thích
			    </span>
            </div>
            
            <p class="recipe-description"><%= recipe.getDescription() %></p>
            
            <!-- Stats Grid -->
            <div class="recipe-stats-grid">
                <div class="recipe-stat-card">
                    <div class="stat-icon">
                        <span class="material-symbols-outlined">schedule</span>
                    </div>
                    <div class="stat-content">
                        <div class="stat-label">Thời gian</div>
                        <div class="stat-value"><%= recipe.getCookingTime() %> phút</div>
                    </div>
                </div>
                
                <div class="recipe-stat-card">
                    <div class="stat-icon">
                        <span class="material-symbols-outlined">
                            <%= recipe.getDifficultyLevel().equals("easy") ? "sentiment_satisfied" : 
                               recipe.getDifficultyLevel().equals("hard") ? "sentiment_stressed" : "sentiment_neutral" %>
                        </span>
                    </div>
                    <div class="stat-content">
                        <div class="stat-label">Độ khó</div>
                        <div class="stat-value">
                            <%= recipe.getDifficultyLevel().equals("easy") ? "Dễ" : 
                               recipe.getDifficultyLevel().equals("hard") ? "Khó" : "Trung bình" %>
                        </div>
                    </div>
                </div>
                
                <div class="recipe-stat-card">
                    <div class="stat-icon">
                        <span class="material-symbols-outlined">group</span>
                    </div>
                    <div class="stat-content">
                        <div class="stat-label">Khẩu phần</div>
                        <div class="stat-value"><%= recipe.getServings() %> người</div>
                    </div>
                </div>
            </div>
            
            <!-- Actions -->
            <div class="recipe-actions">
                <% if (currentUser != null) { %>
                    <button class="btn-favorite <%= isFavorited ? "favorited" : "" %>" 
                            onclick="toggleFavorite(<%= recipe.getRecipeId() %>)">
                        <span class="material-symbols-outlined">favorite</span>
                        <%= isFavorited ? "Đã yêu thích" : "Thêm vào yêu thích" %>
                    </button>
                <% } else { %>
                    <button class="btn-favorite" onclick="alert('Vui lòng đăng nhập để thêm vào yêu thích!')">
                        <span class="material-symbols-outlined">favorite</span>
                        Thêm vào yêu thích
                    </button>
                <% } %>
                
                <button class="btn-share" onclick="shareRecipe()">
                    <span class="material-symbols-outlined">share</span>
                </button>
            </div>
        </div>
    </div>
    
    <!-- Content Section -->
    <div class="recipe-content">
        <!-- Ingredients -->
        <div class="ingredients-box">
            <div class="ingredients-header">
                <h3 class="ingredients-title">
                    <span class="material-symbols-outlined">shopping_basket</span>
                    Nguyên liệu
                </h3>
                <span class="ingredients-count" id="ingredientCount">0 món</span>
            </div>
            
            <ul class="ingredients-list">
                <%
                    String ingredients = recipe.getIngredients();
                    if (ingredients != null && !ingredients.trim().isEmpty()) {
                        String[] ingredientLines = ingredients.split("\n");
                        int count = 0;
                        for (String line : ingredientLines) {
                            line = line.trim();
                            if (!line.isEmpty()) {
                                count++;
                %>
                <li class="ingredient-item">
                    <input type="checkbox" class="ingredient-checkbox">
                    <div class="ingredient-text"><%= line %></div>
                </li>
                <%
                            }
                        }
                %>
                <script>
                    document.getElementById('ingredientCount').textContent = '<%= count %> món';
                </script>
                <%
                    } else {
                %>
                <li class="ingredient-item">
                    <div class="ingredient-text">Chưa có thông tin nguyên liệu</div>
                </li>
                <%
                    }
                %>
            </ul>
        </div>
        
        <!-- Instructions -->
        <div class="instructions-section">
            <% if (recipe.getNotes() != null && !recipe.getNotes().trim().isEmpty()) { %>
            <div class="chef-tip">
                <span class="material-symbols-outlined">lightbulb</span>
                <div>
                    <h4 class="chef-tip-title">Mẹo nhỏ từ Chef</h4>
                    <p class="chef-tip-text"><%= recipe.getNotes() %></p>
                </div>
            </div>
            <% } %>
            
            <h3 class="instructions-header">
                <span class="material-symbols-outlined">menu_book</span>
                Các bước thực hiện
            </h3>
            
            <div class="instructions-list">
                <%
                    String instructions = recipe.getInstructions();
                    if (instructions != null && !instructions.trim().isEmpty()) {
                        String[] instructionSteps = instructions.split("\n");
                        int stepNumber = 1;
                        int totalSteps = 0;
                        
                        // Count non-empty steps
                        for (String s : instructionSteps) {
                            if (s.trim().length() > 0) totalSteps++;
                        }
                        
                        for (String step : instructionSteps) {
                            step = step.trim();
                            if (!step.isEmpty()) {
                                String stepTitle = "Bước " + stepNumber;
                                String stepContent = step;
                                
                                if (step.contains(":")) {
                                    String[] parts = step.split(":", 2);
                                    stepTitle = parts[0].trim();
                                    stepContent = parts[1].trim();
                                }
                                
                                boolean isLastStep = (stepNumber == totalSteps);
                %>
                <div class="instruction-step">
                    <div class="step-number-container">
                        <div class="step-number"><%= stepNumber %></div>
                        <% if (!isLastStep) { %>
                        <div class="step-line"></div>
                        <% } %>
                    </div>
                    <div class="step-content">
                        <h4 class="step-title"><%= stepTitle %></h4>
                        <div class="step-description">
                            <p class="step-text"><%= stepContent %></p>
                        </div>
                    </div>
                </div>
                <%
                                stepNumber++;
                            }
                        }
                    } else {
                %>
                <div class="instruction-step">
                    <div class="step-number-container">
                        <div class="step-number">1</div>
                    </div>
                    <div class="step-content">
                        <div class="step-description">
                            <p class="step-text">Chưa có hướng dẫn chi tiết</p>
                        </div>
                    </div>
                </div>
                <%
                    }
                %>
            </div>
        </div>
    </div>
    
    <!-- Related Recipes -->
    <% if (relatedRecipes != null && !relatedRecipes.isEmpty()) { %>
    <section class="related-section">
        <div class="related-header">
            <h3 class="related-title">Bạn có thể thích</h3>
            <a href="<%= request.getContextPath() %>/CongThucServlet?category=<%= recipe.getCategoryId() %>" 
               class="related-view-all">
                Xem thêm
                <span class="material-symbols-outlined">arrow_forward</span>
            </a>
        </div>
        
        <div class="related-grid">
            <% for (congthuc relatedRecipe : relatedRecipes) { %>
            <a href="<%= request.getContextPath() %>/ChiTietCongThucServlet?id=<%= relatedRecipe.getRecipeId() %>" 
               class="related-card">
                <div class="related-card-image-wrapper">
                    <!-- ✅ SỬA: Dùng helper method cho related recipes -->
                    <img src="<%= getImageUrl(request, relatedRecipe.getImageUrl()) %>" 
                         alt="<%= relatedRecipe.getTitle() %>"
                         class="related-card-image"
                         onerror="this.src='<%= request.getContextPath() %>/images/default-recipe.jpg'">
                </div>
                <div class="related-card-content">
                    <h4 class="related-card-title"><%= relatedRecipe.getTitle() %></h4>
                    <div class="related-card-meta">
                        <div class="related-card-time">
                            <span class="material-symbols-outlined">schedule</span>
                            <%= relatedRecipe.getCookingTime() %>'
                        </div>
                        <div class="related-card-rating">
                            <span class="material-symbols-outlined">visibility</span>
                            <%= relatedRecipe.getViewCount() %>
                        </div>
                    </div>
                </div>
            </a>
            <% } %>
        </div>
    </section>
    <% } %>
</main>

<script>
    // Toggle favorite
    function toggleFavorite(recipeId) {
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
                const btn = document.querySelector('.btn-favorite');
                const favoriteCountElement = document.getElementById('favoriteCount');
                const currentCount = parseInt(favoriteCountElement.textContent);
                
                if (data.isFavorited) {
                    btn.classList.add('favorited');
                    btn.innerHTML = '<span class="material-symbols-outlined">favorite</span>Đã yêu thích';
                    favoriteCountElement.textContent = currentCount + 1;
                } else {
                    btn.classList.remove('favorited');
                    btn.innerHTML = '<span class="material-symbols-outlined">favorite</span>Thêm vào yêu thích';
                    favoriteCountElement.textContent = Math.max(0, currentCount - 1);
                }
            } else {
                alert(data.message || 'Có lỗi xảy ra!');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Có lỗi xảy ra!');
        });
    }
    
    // Share recipe
    function shareRecipe() {
        if (navigator.share) {
            navigator.share({
                title: '<%= recipe.getTitle() %>',
                text: '<%= recipe.getDescription() %>',
                url: window.location.href
            }).catch(err => console.log('Error sharing:', err));
        } else {
            navigator.clipboard.writeText(window.location.href).then(() => {
                alert('Đã copy link công thức!');
            });
        }
    }
</script>

<jsp:include page="include/footer.jsp" />
