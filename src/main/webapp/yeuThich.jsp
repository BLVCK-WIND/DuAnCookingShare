<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, Model.congthuc, Model.user, Model.yeuthichdao" %>
<%
    request.setAttribute("pageTitle", "Công Thức Yêu Thích - CookingShare");
    
	user currentUser = (user) session.getAttribute("user_user");
    
    @SuppressWarnings("unchecked")
    List<congthuc> favoriteRecipes = (List<congthuc>) request.getAttribute("favoriteRecipes");
    Integer totalFavorites = (Integer) request.getAttribute("totalFavorites");
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    
    String selectedKeyword = (String) request.getAttribute("selectedKeyword");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    String selectedSort = (String) request.getAttribute("selectedSort");
    
    if (selectedKeyword == null) selectedKeyword = "";
    if (selectedCategory == null) selectedCategory = "all";
    if (selectedSort == null) selectedSort = "";
    if (totalFavorites == null) totalFavorites = 0;
    if (currentPage == null) currentPage = 1;
    if (totalPages == null) totalPages = 0;
    
    yeuthichdao ytDao = new yeuthichdao();
%>

<!-- Include Header -->
<jsp:include page="include/header.jsp" />

<style>
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
        transition: transform 0.5s;
    }

    .recipe-card:hover .recipe-image {
        transform: scale(1.05);
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

    /* === LAYOUT === */
    .main-content {
        min-height: calc(100vh - 200px);
        padding: 2rem 1rem;
    }

    .content-wrapper {
        max-width: 1440px;
        margin: 0 auto;
        width: 100%;
        padding: 0 1rem;
    }

    @media (min-width: 768px) {
        .content-wrapper {
            padding: 0 2.5rem;
        }
    }

    @media (min-width: 1024px) {
        .content-wrapper {
            padding: 0 10rem;
        }
    }

    /* Page header */
    .page-header {
        display: flex;
        flex-wrap: wrap;
        justify-content: space-between;
        align-items: flex-start;
        gap: 1rem;
        margin-bottom: 2rem;
    }

    .page-title-section h1 {
        font-size: 2rem;
        font-weight: 800;
        color: var(--primary);
        margin-bottom: 0.25rem;
        line-height: 1.2;
        letter-spacing: -0.033em;
    }

    .page-subtitle {
        color: var(--text-secondary);
        font-size: 0.875rem;
    }

    @media (min-width: 768px) {
        .page-title-section h1 {
            font-size: 2.5rem;
        }
        
        .page-subtitle {
            font-size: 1rem;
        }
    }

    /* Search & Filter Controls */
    .search-container {
        flex: 1;
        max-width: 28rem;
    }
    
    .search-input-wrapper {
        display: flex;
        align-items: center;
        background: white;
        border: 1px solid var(--border-color);
        border-radius: 0.75rem;
        overflow: hidden;
        transition: all 0.3s;
        box-shadow: 0 1px 2px rgba(0,0,0,0.05);
    }

    .search-input-wrapper:focus-within {
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(238, 134, 43, 0.1);
    }

    .search-icon {
        display: flex;
        align-items: center;
        padding: 0 1rem;
        color: var(--text-secondary);
    }

    .search-input {
        flex: 1;
        padding: 0.75rem 1rem 0.75rem 0;
        border: none;
        outline: none;
        font-size: 0.875rem;
    }

    .filter-btn {
        padding: 0.625rem 1.25rem;
        border-radius: 9999px;
        background: white;
        border: 1px solid var(--border-color);
        color: var(--text-main);
        font-size: 0.875rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
    }

    .filter-btn:hover {
        background: #fff4ed;
        border-color: var(--primary);
        color: var(--primary);
    }

    .filter-btn.active {
        background: var(--primary);
        border-color: var(--primary);
        color: white;
    }

    .controls-section {
        display: flex;
        flex-direction: column;
        gap: 1rem;
        margin-bottom: 2rem;
    }
    
    @media (min-width: 1024px) {
        .controls-section {
            flex-direction: row;
            align-items: center;
            justify-content: space-between;
        }
    }

    .filter-chips {
        display: flex;
        gap: 0.5rem;
        flex-wrap: wrap;
    }

    /* Recipe grid */
    .recipes-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
        gap: 1.5rem;
        margin-bottom: 2rem;
    }

    /* Pagination */
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

    /* Empty State */
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

    .empty-text {
        font-size: 1rem;
        color: var(--text-secondary);
        margin-bottom: 1.5rem;
    }
</style>

<!-- MAIN CONTENT -->
<main class="main-content">
    <div class="content-wrapper">
        <!-- Page Header -->
        <div class="page-header">
            <div class="page-title-section">
                <h1>Công Thức Yêu Thích</h1>
                <p class="page-subtitle">
                    Bạn có <%= totalFavorites %> công thức yêu thích
                </p>
            </div>
        </div>

        <!-- Controls Section -->
        <form id="searchForm" method="get" action="<%= request.getContextPath() %>/YeuThichServlet">
            <input type="hidden" name="category" value="<%= selectedCategory %>">
            <input type="hidden" name="sort" value="<%= selectedSort %>">

            <div class="controls-section">
                <!-- Search Bar -->
                <div class="search-container">
                    <div class="search-input-wrapper">
                        <div class="search-icon">
                            <span class="material-symbols-outlined">search</span>
                        </div>
                        <input 
                            type="text" 
                            name="keyword" 
                            value="<%= selectedKeyword %>"
                            placeholder="Tìm kiếm trong yêu thích..." 
                            class="search-input">
                    </div>
                </div>

                <!-- Sort Chips -->
                <div class="filter-chips">
                    <button type="button" 
                            onclick="sortBy('latest')" 
                            class="filter-btn <%= "latest".equals(selectedSort) ? "active" : "" %>">
                        Mới nhất
                    </button>
                    <button type="button" 
                            onclick="sortBy('time-asc')" 
                            class="filter-btn <%= "time-asc".equals(selectedSort) ? "active" : "" %>">
                        Nấu nhanh
                    </button>
                </div>
            </div>
        </form>

        <!-- Recipes Grid -->
        <% if (favoriteRecipes != null && !favoriteRecipes.isEmpty()) { %>
            <div class="recipes-grid">
                <% for (congthuc recipe : favoriteRecipes) { 
                    // Tất cả công thức trong danh sách này đều đã được yêu thích
                    boolean isFavorited = true;
                %>
                    <div class="recipe-card">
                        <div class="recipe-image-wrapper">
                            <!-- Badge số lượt xem -->
                            <div class="recipe-badge">
                                <span class="material-symbols-outlined badge-icon">visibility</span>
                                <%= recipe.getViewCount() %>
                            </div>
                            
                            <!-- Nút yêu thích (luôn filled vì đang trong trang yêu thích) -->
                            <button class="recipe-favorite favorited" 
                                    onclick="toggleFavorite(<%= recipe.getRecipeId() %>, this)"
                                    data-recipe-id="<%= recipe.getRecipeId() %>">
                                <span class="material-symbols-outlined filled">favorite</span>
                            </button>

                            <img src="<%= recipe.getImageUrl() != null ? recipe.getImageUrl() : request.getContextPath() + "/images/default-recipe.jpg" %>" 
                                 alt="<%= recipe.getTitle() %>" 
                                 class="recipe-image">
                        </div>

                        <div class="recipe-content">
                            <!-- Category -->
                            <span class="recipe-category">
                                <%= recipe.getCategoryName() != null ? recipe.getCategoryName() : "Chưa phân loại" %>
                            </span>

                            <!-- Title -->
                            <h3 class="recipe-title">
                                <%= recipe.getTitle() %>
                            </h3>

                            <!-- Meta Info -->
                            <div class="recipe-meta">
                                <!-- Thời gian nấu -->
                                <div class="recipe-meta-item">
                                    <span class="material-symbols-outlined">schedule</span>
                                    <%= recipe.getCookingTime() %>p
                                </div>

                                <!-- Độ khó -->
                                <div class="recipe-meta-item">
                                    <span class="material-symbols-outlined">bar_chart</span>
                                    <% 
                                        String difficulty = recipe.getDifficultyLevel();
                                        if ("easy".equals(difficulty)) {
                                            out.print("Dễ");
                                        } else if ("medium".equals(difficulty)) {
                                            out.print("TB");
                                        } else if ("hard".equals(difficulty)) {
                                            out.print("Khó");
                                        } else {
                                            out.print("N/A");
                                        }
                                    %>
                                </div>

                                <!-- Tác giả -->
                                <div class="recipe-author">
								    <img src="<%= request.getContextPath() %>/avatars/<%= recipe.getAuthorAvatar() != null ? recipe.getAuthorAvatar() : "avatar1" %>.jpg" 
								         alt="<%= recipe.getAuthorName() %>"
								         class="recipe-author-avatar"
								         onerror="this.src='<%= request.getContextPath() %>/avatars/avatar1.jpg'">
								    <span class="recipe-author-name"><%= recipe.getAuthorName() %></span>
								</div>
                            </div>

                            <!-- View Button -->
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
                <span class="material-symbols-outlined empty-icon">favorite_border</span>
                <h2 class="empty-title">Chưa có công thức yêu thích</h2>
                <p class="empty-text">Hãy khám phá và lưu những công thức bạn yêu thích nhé!</p>
                <a href="<%= request.getContextPath() %>/CongThucServlet" class="recipe-btn" 
                   style="display: inline-block; margin-top: 1.5rem; text-decoration: none; width: auto; padding: 0.75rem 2rem;">
                    Khám phá công thức
                </a>
            </div>
        <% } %>
    </div>
</main>

<script>
    // Tự động submit form khi nhập keyword
    let searchTimeout;
    document.querySelector('.search-input').addEventListener('input', function() {
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(function() {
            document.getElementById('searchForm').submit();
        }, 500);
    });

    // Sort recipes
    function sortBy(sortType) {
        const form = document.getElementById('searchForm');
        const currentSort = form.querySelector('input[name="sort"]').value;
        
        // Toggle sort if clicking same button
        if (currentSort === sortType) {
            form.querySelector('input[name="sort"]').value = '';
        } else {
            form.querySelector('input[name="sort"]').value = sortType;
        }
        form.submit();
    }

    // Go to page function
    function goToPage(page) {
        const form = document.getElementById('searchForm');
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

    // Toggle favorite
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
                if (data.isFavorited) {
                    // Added to favorites
                    button.classList.add('favorited');
                    button.querySelector('.material-symbols-outlined').classList.add('filled');
                    showMessage(data.message || 'Đã thêm vào yêu thích!', 'success');
                } else {
                    // Removed from favorites - reload page to update the list
                    showMessage(data.message || 'Đã bỏ yêu thích!', 'success');
                    setTimeout(() => {
                        window.location.reload();
                    }, 1000);
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

    // Add CSS animation
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
