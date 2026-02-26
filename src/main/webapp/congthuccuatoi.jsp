<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.text.SimpleDateFormat, java.util.Date, Model.congthuc, Model.user" %>
<%
    request.setAttribute("pageTitle", "Công Thức Của Tôi - CookingShare");
    
	user currentUser = (user) session.getAttribute("user_user");
    
    @SuppressWarnings("unchecked")
    List<congthuc> myRecipes = (List<congthuc>) request.getAttribute("myRecipes");
    
    Integer totalAll = (Integer) request.getAttribute("totalAll");
    Integer totalApproved = (Integer) request.getAttribute("totalApproved");
    Integer totalPending = (Integer) request.getAttribute("totalPending");
    Integer totalRejected = (Integer) request.getAttribute("totalRejected");
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    
    String selectedStatus = (String) request.getAttribute("selectedStatus");
    String selectedKeyword = (String) request.getAttribute("selectedKeyword");
    String selectedSort = (String) request.getAttribute("selectedSort");
    
    if (totalAll == null) totalAll = 0;
    if (totalApproved == null) totalApproved = 0;
    if (totalPending == null) totalPending = 0;
    if (totalRejected == null) totalRejected = 0;
    if (selectedStatus == null) selectedStatus = "all";
    if (selectedKeyword == null) selectedKeyword = "";
    if (selectedSort == null) selectedSort = "latest";
    if (currentPage == null) currentPage = 1;
    if (totalPages == null) totalPages = 0;
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>

<!-- Include Header -->
<jsp:include page="include/header.jsp" />

<style>
    /* Main container */
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

    /* Add recipe button */
    .add-recipe-btn {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
        padding: 0.75rem 1.25rem;
        border-radius: 0.5rem;
        background: var(--primary);
        color: white;
        font-weight: 700;
        font-size: 0.875rem;
        transition: all 0.3s;
        box-shadow: 0 4px 12px rgba(238, 134, 43, 0.2);
        text-decoration: none;
        border: none;
        cursor: pointer;
    }

    .add-recipe-btn:hover {
        background: var(--primary-hover);
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(238, 134, 43, 0.3);
    }

    .add-recipe-btn .material-symbols-outlined {
        font-size: 1.25rem;
    }

    /* Tabs */
    .tabs-container {
        border-bottom: 1px solid var(--border-color);
        margin-bottom: 2rem;
    }

    .tabs {
        display: flex;
        gap: 2rem;
        overflow-x: auto;
        scrollbar-width: none;
    }

    .tabs::-webkit-scrollbar {
        display: none;
    }

    .tab {
        display: flex;
        flex-direction: column;
        align-items: center;
        border-bottom: 3px solid transparent;
        padding-bottom: 0.75rem;
        color: var(--text-secondary);
        font-size: 0.875rem;
        font-weight: 700;
        white-space: nowrap;
        cursor: pointer;
        transition: all 0.3s;
        text-decoration: none;
        letter-spacing: 0.015em;
    }

    .tab:hover {
        color: var(--text-main);
        border-bottom-color: rgba(238, 134, 43, 0.3);
    }

    .tab.active {
        color: var(--text-main);
        border-bottom-color: var(--primary);
    }

    /* Controls section */
    .controls-section {
        display: flex;
        flex-direction: column;
        gap: 1rem;
        margin-bottom: 2rem;
    }

    @media (min-width: 768px) {
        .controls-section {
            flex-direction: row;
            justify-content: space-between;
            align-items: center;
        }
    }

    /* Search input */
    .search-wrapper {
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

    /* Sort select */
    .sort-wrapper {
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }

    .sort-label {
        font-size: 0.875rem;
        font-weight: 600;
        color: var(--text-secondary);
        white-space: nowrap;
    }

    .sort-select {
        padding: 0.625rem 0.875rem;
        border: 1px solid var(--border-color);
        border-radius: 0.5rem;
        background: white;
        color: var(--text-main);
        font-size: 0.875rem;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s;
        box-shadow: 0 1px 2px rgba(0,0,0,0.05);
    }

    .sort-select:focus {
        outline: none;
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(238, 134, 43, 0.1);
    }

    /* Recipe cards grid */
    .recipes-grid {
        display: grid;
        gap: 1.5rem;
        margin-bottom: 2.5rem;
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

    /* Recipe card */
    .recipe-card {
        background: white;
        border-radius: 1rem;
        border: 1px solid var(--border-color);
        overflow: hidden;
        transition: all 0.3s;
        display: flex;
        flex-direction: column;
    }

    .recipe-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 12px 24px rgba(0,0,0,0.1);
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

    /* Status badge */
    .status-badge {
        position: absolute;
        top: 0.75rem;
        left: 0.75rem;
        display: flex;
        align-items: center;
        gap: 0.375rem;
        padding: 0.375rem 0.875rem;
        border-radius: 9999px;
        font-size: 0.75rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        backdrop-filter: blur(8px);
        box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        z-index: 2;
    }

    .status-badge .material-symbols-outlined {
        font-size: 1rem;
    }

    .status-badge.approved {
        background: rgba(16, 185, 129, 0.95);
        color: white;
    }

    .status-badge.pending {
        background: rgba(251, 191, 36, 0.95);
        color: #78350f;
    }

    .status-badge.rejected {
        background: rgba(239, 68, 68, 0.95);
        color: white;
    }

    .pulse-dot {
        width: 0.5rem;
        height: 0.5rem;
        border-radius: 50%;
        background: #78350f;
        animation: pulse 2s infinite;
    }

    @keyframes pulse {
        0%, 100% {
            opacity: 1;
        }
        50% {
            opacity: 0.5;
        }
    }

    /* Recipe content */
    .recipe-content {
        padding: 1.25rem;
        flex: 1;
        display: flex;
        flex-direction: column;
        gap: 0.75rem;
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
        margin: 0;
    }

    .recipe-footer {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding-top: 0.75rem;
        border-top: 1px solid #f3f4f6;
        font-size: 0.875rem;
        color: var(--text-secondary);
    }

    .recipe-stats {
        display: flex;
        align-items: center;
        gap: 0.25rem;
    }

    .recipe-stats .material-symbols-outlined {
        font-size: 1.125rem;
    }

    .menu-button {
        background: none;
        border: none;
        padding: 0.25rem;
        cursor: pointer;
        color: var(--text-secondary);
        transition: color 0.3s;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .menu-button:hover {
        color: var(--text-main);
    }

    .menu-button .material-symbols-outlined {
        font-size: 1.25rem;
    }

    /* Rejection alert */
    .rejection-alert {
        margin: 1rem 1.25rem 0;
        padding: 0.875rem;
        background: #fef2f2;
        border: 1px solid #fecaca;
        border-radius: 0.5rem;
        color: #991b1b;
        font-size: 0.875rem;
        display: flex;
        align-items: flex-start;
        gap: 0.625rem;
    }

    .rejection-alert .material-symbols-outlined {
        flex-shrink: 0;
        font-size: 1.125rem;
        color: #dc2626;
    }

    /* Action buttons */
    .action-buttons {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 0.5rem;
        padding: 1rem 1.25rem 1.25rem;
        border-top: 1px solid var(--border-color);
    }

    .action-btn {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        gap: 0.25rem;
        padding: 0.625rem;
        border-radius: 0.5rem;
        font-size: 0.75rem;
        font-weight: 600;
        border: 1px solid var(--border-color);
        background: white;
        color: var(--text-main);
        cursor: pointer;
        transition: all 0.3s;
        text-decoration: none;
    }

    .action-btn .material-symbols-outlined {
        font-size: 1.25rem;
    }

    .action-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }

    .action-btn-primary {
        border-color: var(--primary);
        color: var(--primary);
    }

    .action-btn-primary:hover {
        background: var(--primary);
        color: white;
    }

    .action-btn-secondary {
        border-color: #3b82f6;
        color: #3b82f6;
    }

    .action-btn-secondary:hover {
        background: #3b82f6;
        color: white;
    }

    .action-btn-danger {
        border-color: #ef4444;
        color: #ef4444;
    }

    .action-btn-danger:hover {
        background: #ef4444;
        color: white;
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

    /* Empty state */
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

<main class="main-content">
    <div class="content-wrapper">
        <!-- Page Header -->
        <header class="page-header">
            <div class="page-title-section">
                <h1>Công Thức Của Tôi</h1>
                <p class="page-subtitle">Quản lý và theo dõi các công thức của bạn</p>
            </div>
            <a href="<%= request.getContextPath() %>/ThemCongThucServlet" class="add-recipe-btn">
                <span class="material-symbols-outlined">add_circle</span>
                <span>Thêm công thức mới</span>
            </a>
        </header>

        <!-- Status Tabs -->
        <div class="tabs-container">
            <div class="tabs">
                <a href="?status=all&keyword=<%= selectedKeyword %>&sort=<%= selectedSort %>" 
                   class="tab <%= "all".equals(selectedStatus) ? "active" : "" %>">
                    Tất cả (<%= totalAll %>)
                </a>
                <a href="?status=approved&keyword=<%= selectedKeyword %>&sort=<%= selectedSort %>" 
                   class="tab <%= "approved".equals(selectedStatus) ? "active" : "" %>">
                    Đã đăng (<%= totalApproved %>)
                </a>
                <a href="?status=pending&keyword=<%= selectedKeyword %>&sort=<%= selectedSort %>" 
                   class="tab <%= "pending".equals(selectedStatus) ? "active" : "" %>">
                    Chờ duyệt (<%= totalPending %>)
                </a>
                <a href="?status=rejected&keyword=<%= selectedKeyword %>&sort=<%= selectedSort %>" 
                   class="tab <%= "rejected".equals(selectedStatus) ? "active" : "" %>">
                    Từ chối (<%= totalRejected %>)
                </a>
            </div>
        </div>

        <!-- Controls: Search and Sort -->
        <form id="filterForm" action="<%= request.getContextPath() %>/CongThucCuaToiServlet" method="get" class="controls-section">
            <input type="hidden" name="status" value="<%= selectedStatus %>">
            
            <!-- Search -->
            <div class="search-wrapper">
                <div class="search-input-wrapper">
                    <div class="search-icon">
                        <span class="material-symbols-outlined">search</span>
                    </div>
                    <input type="text" 
                           name="keyword" 
                           class="search-input" 
                           placeholder="Tìm kiếm công thức..." 
                           value="<%= selectedKeyword %>">
                </div>
            </div>

            <!-- Sort -->
            <div class="sort-wrapper">
                <label class="sort-label">Sắp xếp:</label>
                <select name="sort" class="sort-select" onchange="this.form.submit()">
                    <option value="latest" <%= "latest".equals(selectedSort) ? "selected" : "" %>>Mới nhất</option>
                    <option value="oldest" <%= "oldest".equals(selectedSort) ? "selected" : "" %>>Cũ nhất</option>
                    <option value="most-viewed" <%= "most-viewed".equals(selectedSort) ? "selected" : "" %>>Nhiều lượt xem</option>
                    <option value="most-favorited" <%= "most-favorited".equals(selectedSort) ? "selected" : "" %>>Yêu thích nhiều</option>
                </select>
            </div>
        </form>

        <!-- Recipes Grid -->
        <div class="recipes-grid">
            <% if (myRecipes != null && !myRecipes.isEmpty()) {
                for (congthuc recipe : myRecipes) { 
                    String statusBadgeClass = "";
                    String statusIcon = "";
                    String statusText = "";
                    
                    if ("approved".equals(recipe.getStatus())) {
                        statusBadgeClass = "approved";
                        statusIcon = "check_circle";
                        statusText = "Đã đăng";
                    } else if ("pending".equals(recipe.getStatus())) {
                        statusBadgeClass = "pending";
                        statusIcon = "";
                        statusText = "Chờ phê duyệt";
                    } else if ("rejected".equals(recipe.getStatus())) {
                        statusBadgeClass = "rejected";
                        statusIcon = "cancel";
                        statusText = "Bị từ chối";
                    }
                    
                    // Tính thời gian
                    String timeAgo = "";
                    if (recipe.getCreatedAt() != null) {
                        long diff = new Date().getTime() - recipe.getCreatedAt().getTime();
                        long days = diff / (24 * 60 * 60 * 1000);
                        if (days == 0) {
                            timeAgo = "Hôm nay";
                        } else if (days == 1) {
                            timeAgo = "Hôm qua";
                        } else if (days < 7) {
                            timeAgo = days + " ngày trước";
                        } else if (days < 30) {
                            timeAgo = (days / 7) + " tuần trước";
                        } else if (days < 365) {
                            timeAgo = (days / 30) + " tháng trước";
                        } else {
                            timeAgo = sdf.format(recipe.getCreatedAt());
                        }
                    }
            %>
                <div class="recipe-card">
                    <div class="recipe-image-wrapper">
                        <div class="status-badge <%= statusBadgeClass %>">
                            <% if ("pending".equals(recipe.getStatus())) { %>
                                <span class="pulse-dot"></span>
                            <% } else if (!statusIcon.isEmpty()) { %>
                                <span class="material-symbols-outlined"><%= statusIcon %></span>
                            <% } %>
                            <%= statusText %>
                        </div>
                        
                        <img src="<%= recipe.getImageUrl() != null ? recipe.getImageUrl() : request.getContextPath() + "/images/default-recipe.jpg" %>" 
                             alt="<%= recipe.getTitle() %>" 
                             class="recipe-image">
                    </div>

                    <div class="recipe-content">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                            <p class="recipe-category">
                                <%= recipe.getCategoryName() != null ? recipe.getCategoryName() : "Chưa phân loại" %>
                            </p>
                            <button class="menu-button" onclick="alert('Menu options coming soon!')">
                                <span class="material-symbols-outlined">more_horiz</span>
                            </button>
                        </div>

                        <h3 class="recipe-title">
                            <%= recipe.getTitle() %>
                        </h3>

                        <div class="recipe-footer">
						    <span><%= timeAgo %></span>
						    <div class="recipe-stats">
						        <span class="material-symbols-outlined">visibility</span>
						        <!-- Only show view count for approved recipes, otherwise always 0 -->
						        <% if ("approved".equals(recipe.getStatus())) { %>
						            <%= recipe.getViewCount() %>
						        <% } else { %>
						            0
						        <% } %>
						    </div>
						</div>
                    </div>
                    
                    <!-- Rejection reason -->
                    <% if ("rejected".equals(recipe.getStatus()) && recipe.getRejectionReason() != null && !recipe.getRejectionReason().isEmpty()) { %>
                    <div class="rejection-alert">
                        <span class="material-symbols-outlined">error</span>
                        <strong>Lý do:</strong> <%= recipe.getRejectionReason() %>
                    </div>
                    <% } %>

                    <!-- Action buttons -->
                    <div class="action-buttons">
                        <a href="<%= request.getContextPath() %>/SuaCongThucServlet?id=<%= recipe.getRecipeId() %>&mode=view" 
                           class="action-btn action-btn-primary">
                            <span class="material-symbols-outlined">visibility</span>
                            Xem
                        </a>
                        <% if ("pending".equals(recipe.getStatus()) || "rejected".equals(recipe.getStatus())) { %>
                        <a href="<%= request.getContextPath() %>/SuaCongThucServlet?id=<%= recipe.getRecipeId() %>&mode=edit" 
                           class="action-btn action-btn-secondary">
                            <span class="material-symbols-outlined">edit</span>
                            Sửa
                        </a>
                        <% } %>
                        <button onclick="confirmDelete(<%= recipe.getRecipeId() %>)" 
                                class="action-btn action-btn-danger">
                            <span class="material-symbols-outlined">delete</span>
                            Xóa
                        </button>
                    </div>
                </div>
            <% } 
            } else { %>
                <!-- Empty State -->
                <div class="empty-state">
                    <span class="material-symbols-outlined empty-icon">restaurant</span>
                    <h2 class="empty-title">
                        <% if ("pending".equals(selectedStatus)) { %>
                            Chưa có công thức chờ duyệt
                        <% } else if ("rejected".equals(selectedStatus)) { %>
                            Không có công thức bị từ chối
                        <% } else if ("approved".equals(selectedStatus)) { %>
                            Chưa có công thức đã đăng
                        <% } else { %>
                            Chưa có công thức nào
                        <% } %>
                    </h2>
                    <p class="empty-text">Hãy bắt đầu chia sẻ công thức nấu ăn của bạn!</p>
                    <a href="<%= request.getContextPath() %>/ThemCongThucServlet" class="add-recipe-btn">
                        <span class="material-symbols-outlined">add_circle</span>
                        <span>Thêm công thức mới</span>
                    </a>
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
    </div>
</main>

<script>
    // Auto submit search form
    let searchTimeout;
    const searchInput = document.querySelector('.search-input');
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(function() {
                document.getElementById('filterForm').submit();
            }, 500);
        });
    }

    // Go to page function
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

    // ✅ XÓA CÔNG THỨC (ĐÃ SỬA - Dùng POST và xóa ảnh)
    function confirmDelete(recipeId) {
        // Lấy tên công thức để hiển thị
        const recipeCard = event.target.closest('.recipe-card');
        const recipeTitle = recipeCard ? recipeCard.querySelector('.recipe-title')?.textContent : 'công thức này';
        
        // Confirm
        if (!confirm('Bạn có chắc chắn muốn xóa món này không?\n\nHành động này sẽ xóa:\n- Công thức khỏi database\n- Ảnh khỏi thư mục images\n\nKhông thể hoàn tác!')) {
            return;
        }
        
        // Hiển thị loading
        const btnDelete = event.target.closest('button');
        const originalHTML = btnDelete.innerHTML;
        btnDelete.disabled = true;
        btnDelete.innerHTML = '<span class="material-symbols-outlined">progress_activity</span> Đang xóa...';
        
        // Gửi request xóa (POST)
        fetch('<%= request.getContextPath() %>/XoaCongThucServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'id=' + recipeId
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Xóa thành công
                alert('✅ ' + data.message);
                
                // Reload trang
                window.location.reload();
                
            } else {
                // Xóa thất bại
                alert('❌ ' + data.message);
                
                // Khôi phục nút
                btnDelete.disabled = false;
                btnDelete.innerHTML = originalHTML;
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('❌ Có lỗi xảy ra khi xóa công thức!');
            
            // Khôi phục nút
            btnDelete.disabled = false;
            btnDelete.innerHTML = originalHTML;
        });
    }
</script>

<!-- Include Footer -->
<jsp:include page="include/footer.jsp" />
