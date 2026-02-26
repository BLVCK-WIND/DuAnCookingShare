<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, Model.congthuc, Model.danhmuc, Model.user" %>
<%
	user currentUser = (user) session.getAttribute("user_user");
    congthuc recipe = (congthuc) request.getAttribute("recipe");
    
    @SuppressWarnings("unchecked")
    List<danhmuc> categories = (List<danhmuc>) request.getAttribute("categories");
    
    String mode = (String) request.getAttribute("mode");
    if (mode == null) mode = "view";
    
    boolean isViewMode = "view".equals(mode);
    boolean isEditMode = "edit".equals(mode);
    
    if (recipe == null) {
        response.sendRedirect(request.getContextPath() + "/CongThucCuaToiServlet");
        return;
    }
    
 // Parse ingredients và instructions
    String[] ingredients = recipe.getIngredients() != null ? recipe.getIngredients().split("\n") : new String[0];
    // Split instructions by double newline OR by "Bước X:" pattern
    String[] instructions;
    if (recipe.getInstructions() != null) {
        String instText = recipe.getInstructions().trim();
        // Try splitting by "Bước X:" pattern first
        if (instText.contains("Bước")) {
            instructions = instText.split("(?=Bước \\d+:)");
        } else {
            instructions = instText.split("\n\n");
        }
    } else {
        instructions = new String[0];
    }
    
    request.setAttribute("pageTitle", (isViewMode ? "Chi Tiết" : "Sửa") + " Công Thức - CookingShare");
%>

<!-- Include Header -->
<jsp:include page="include/header.jsp" />

<style>
    /* Reuse styles from themCongThuc.jsp */
    .main-content {
        min-height: calc(100vh - 200px);
        padding: 2rem 1rem;
    }
    
    .content-wrapper {
        max-width: <%= isViewMode ? "1024px" : "960px" %>;
        margin: 0 auto;
        width: 100%;
    }
    
    @media (min-width: 768px) {
        .main-content {
            padding: 2rem 2.5rem;
        }
    }
    
    @media (min-width: 1024px) {
        .main-content {
            padding: 2rem <%= isViewMode ? "6rem" : "10rem" %>;
        }
    }
    
    /* Breadcrumbs */
    .breadcrumbs {
        display: flex;
        flex-wrap: wrap;
        gap: 0.5rem;
        margin-bottom: 1.5rem;
        font-size: 0.875rem;
        font-weight: 500;
    }
    
    .breadcrumb-link {
        color: var(--text-secondary);
        transition: color 0.3s;
        text-decoration: none;
    }
    
    .recipe-image-display {
	    width: 100%;
	    aspect-ratio: 4 / 3;      /* Giữ khung 4:3 */
	    background: #f7f7f7;      /* nền nhạt như hình */
	    border-radius: 16px;
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    overflow: hidden;
	}
	
	.recipe-image-display img {
	    max-width: 90%;           /* BÓP ẢNH LẠI */
	    max-height: 90%;
	    object-fit: contain;      /* KHÔNG CẮT ẢNH */
	    object-position: center;
	    border-radius: 12px;
	}

	    
    
    .breadcrumb-link:hover {
        color: var(--primary);
    }
    
    /* Status badge */
    .status-badge {
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        padding: 0.5rem 1rem;
        border-radius: 9999px;
        font-size: 0.875rem;
        font-weight: 700;
        margin-bottom: 1rem;
    }
    
    .status-badge.approved {
        background: rgba(16, 185, 129, 0.1);
        color: #059669;
        border: 1px solid #10b981;
    }
    
    .status-badge.pending {
        background: rgba(251, 146, 60, 0.1);
        color: #ea580c;
        border: 1px solid #fb923c;
    }
    
    .status-badge.rejected {
        background: rgba(239, 68, 68, 0.1);
        color: #dc2626;
        border: 1px solid #ef4444;
    }
    
    /* Page heading */
    .page-heading {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: 2rem;
        gap: 1rem;
        flex-wrap: wrap;
    }
    
    .page-heading h1 {
        font-size: 2.5rem;
        font-weight: 800;
        color: var(--text-main);
        line-height: 1.2;
        letter-spacing: -0.033em;
        margin-bottom: 0.5rem;
    }
    
    .page-heading p {
        font-size: 1rem;
        color: var(--text-secondary);
    }
    
    /* Action buttons */
    .mode-actions {
        display: flex;
        gap: 0.75rem;
    }
    
    .btn {
        padding: 0.75rem 1.5rem;
        border-radius: 0.5rem;
        font-size: 0.875rem;
        font-weight: 700;
        cursor: pointer;
        transition: all 0.3s;
        border: 1px solid transparent;
        display: flex;
        align-items: center;
        gap: 0.5rem;
        text-decoration: none;
    }
    
    .btn-edit {
        background: var(--primary);
        color: white;
        box-shadow: 0 2px 4px rgba(238, 134, 43, 0.2);
    }
    
    .btn-edit:hover {
        background: var(--primary-hover);
    }
    
    .btn-back {
        background: white;
        color: var(--text-main);
        border-color: var(--border-color);
    }
    
    .btn-back:hover {
        background: #f9fafb;
    }
    
    /* Image display */
    .recipe-image-display {
        width: 100%;
        border-radius: 1rem;
        overflow: hidden;
        margin-bottom: 2rem;
        max-height: 500px;
    }
    
    .recipe-image-display img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }
    
    /* Info grid */
    .info-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1.5rem;
        margin-bottom: 2rem;
        padding: 1.5rem;
        background: white;
        border-radius: 0.75rem;
        box-shadow: 0 1px 2px rgba(0,0,0,0.05);
    }
    
    .info-item {
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }
    
    .info-icon {
        width: 3rem;
        height: 3rem;
        border-radius: 50%;
        background: rgba(238, 134, 43, 0.1);
        color: var(--primary);
        display: flex;
        align-items: center;
        justify-content: center;
    }
    
    .info-content {
        flex: 1;
    }
    
    .info-label {
        font-size: 0.75rem;
        color: var(--text-secondary);
        font-weight: 600;
        text-transform: uppercase;
    }
    
    .info-value {
        font-size: 1.125rem;
        font-weight: 700;
        color: var(--text-main);
    }
    
    /* Section */
    .content-section {
        background: white;
        border-radius: 0.75rem;
        padding: 1.5rem;
        box-shadow: 0 1px 2px rgba(0,0,0,0.05);
        margin-bottom: 2rem;
    }
    
    .section-title {
        font-size: 1.5rem;
        font-weight: 700;
        color: var(--text-main);
        margin-bottom: 1.5rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    
    .section-title .material-symbols-outlined {
        color: var(--primary);
        font-size: 1.75rem;
    }
    
    /* Ingredients list */
    .ingredients-display {
        display: grid;
        gap: 0.75rem;
    }
    
    .ingredient-item {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        padding: 0.75rem;
        background: #f9fafb;
        border-radius: 0.5rem;
    }
    
    .ingredient-item .material-symbols-outlined {
        color: var(--primary);
        font-size: 1.25rem;
    }
    
    /* Steps list */
    .steps-display {
        display: flex;
        flex-direction: column;
        gap: 1.5rem;
    }
    
    .step-display {
        display: flex;
        gap: 1rem;
    }
    
    .step-number {
        width: 2.5rem;
        height: 2.5rem;
        border-radius: 50%;
        background: var(--primary);
        color: white;
        font-weight: 700;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
        box-shadow: 0 2px 4px rgba(238, 134, 43, 0.2);
    }
    
    .step-text {
        flex: 1;
        padding-top: 0.25rem;
        line-height: 1.6;
        color: var(--text-main);
    }
    
    /* Rejection alert */
    .rejection-alert {
        background: #fef2f2;
        border: 1px solid #fecaca;
        border-radius: 0.75rem;
        padding: 1rem;
        margin-bottom: 2rem;
        display: flex;
        gap: 0.75rem;
    }
    
    .rejection-alert .material-symbols-outlined {
        color: #dc2626;
        font-size: 1.5rem;
    }
    
    .rejection-content {
        flex: 1;
    }
    
    .rejection-title {
        font-weight: 700;
        color: #991b1b;
        margin-bottom: 0.25rem;
    }
    
    .rejection-reason {
        color: #7f1d1d;
        font-size: 0.875rem;
    }
    
    /* Form styles - reuse from themCongThuc.jsp */
    .form-section {
        background: white;
        border-radius: 0.75rem;
        padding: 1.5rem;
        box-shadow: 0 1px 2px rgba(0,0,0,0.05);
        margin-bottom: 2rem;
    }
    
    .form-grid {
        display: grid;
        grid-template-columns: 1fr;
        gap: 2rem;
    }
    
    @media (min-width: 1024px) {
        .form-grid {
            grid-template-columns: 1fr 2fr;
        }
    }
    
    .detail-grid {
        display: grid;
        grid-template-columns: 1fr;
        gap: 1rem;
    }
    
    @media (min-width: 640px) {
        .detail-grid {
            grid-template-columns: repeat(2, 1fr);
        }
    }
    
    @media (min-width: 1024px) {
        .detail-grid {
            grid-template-columns: repeat(4, 1fr);
        }
    }
    
    .form-group {
        margin-bottom: 1.25rem;
    }
    
    .form-group:last-child {
        margin-bottom: 0;
    }
    
    .form-label {
        display: block;
        font-size: 0.875rem;
        font-weight: 700;
        color: var(--text-main);
        margin-bottom: 0.5rem;
    }
    
    .form-label.with-icon {
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    
    .form-label .material-symbols-outlined {
        color: var(--primary);
        font-size: 1.25rem;
    }
    
    .required {
        color: #ef4444;
    }
    
    .form-input,
    .form-textarea,
    .form-select {
        width: 100%;
        padding: 0.75rem 1rem;
        border: 1px solid var(--border-color);
        border-radius: 0.5rem;
        background: white;
        color: var(--text-main);
        font-size: 1rem;
        transition: all 0.3s;
    }
    
    .form-input:focus,
    .form-textarea:focus,
    .form-select:focus {
        outline: none;
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(238, 134, 43, 0.1);
    }
    
    .form-textarea {
        resize: vertical;
        min-height: 100px;
    }
    
    .input-with-unit {
        position: relative;
    }
    
    .input-unit {
        position: absolute;
        right: 1rem;
        top: 50%;
        transform: translateY(-50%);
        font-size: 0.875rem;
        color: var(--text-secondary);
    }
    
    /* Image upload area */
    .image-upload-area {
        position: relative;
        min-height: 280px;
        width: 100%;
        border: 2px dashed var(--border-color);
        border-radius: 0.75rem;
        background: #fafafa;
        cursor: pointer;
        transition: all 0.3s;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        padding: 2rem;
    }
    
    .image-upload-area:hover {
        border-color: var(--primary);
        background: rgba(238, 134, 43, 0.05);
    }
    
    .upload-icon-wrapper {
        width: 4rem;
        height: 4rem;
        border-radius: 50%;
        background: rgba(238, 134, 43, 0.1);
        color: var(--primary);
        display: flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 1rem;
        transition: all 0.3s;
    }
    
    .image-upload-area:hover .upload-icon-wrapper {
        background: var(--primary);
        color: white;
    }
    
    .upload-icon {
        font-size: 2.5rem;
    }
    
    .upload-text {
        text-align: center;
    }
    
    .upload-title {
        font-size: 1rem;
        font-weight: 700;
        color: var(--text-main);
        margin-bottom: 0.25rem;
    }
    
    .upload-subtitle {
        font-size: 0.875rem;
        color: var(--text-secondary);
        margin-bottom: 0.5rem;
    }
    
    .upload-hint {
        font-size: 0.75rem;
        color: var(--text-secondary);
    }
    
    .image-preview {
        display: none;
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        border-radius: 0.75rem;
        overflow: hidden;
    }
    
    .image-preview img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }
    
    .image-preview.active {
        display: block;
    }
    
    .remove-image-btn {
        position: absolute;
        top: 0.5rem;
        right: 0.5rem;
        width: 2.5rem;
        height: 2.5rem;
        border-radius: 50%;
        background: rgba(239, 68, 68, 0.9);
        color: white;
        border: none;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        z-index: 10;
        transition: all 0.3s;
    }
    
    .remove-image-btn:hover {
        background: #dc2626;
        transform: scale(1.1);
    }
    
    /* Ingredients & steps in edit mode */
    .ingredients-list,
    .steps-list {
        display: flex;
        flex-direction: column;
        gap: 0.75rem;
    }
    
    .ingredient-row {
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
    }
    
    @media (min-width: 640px) {
        .ingredient-row {
            flex-direction: row;
            align-items: center;
        }
    }
    
    .ingredient-quantity {
        width: 100%;
    }
    
    @media (min-width: 640px) {
        .ingredient-quantity {
            width: 25%;
        }
    }
    
    .ingredient-name-wrapper {
        display: flex;
        flex: 1;
        gap: 0.5rem;
    }
    
    .ingredient-name {
        flex: 1;
    }
    
    .remove-btn {
        width: 2.5rem;
        height: 2.5rem;
        border-radius: 0.5rem;
        background: transparent;
        border: none;
        color: var(--text-secondary);
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        transition: all 0.3s;
    }
    
    .remove-btn:hover {
        background: #fef2f2;
        color: #ef4444;
    }
    
    .step-item {
        display: flex;
        gap: 1rem;
    }
    
    .step-content {
        flex: 1;
    }
    
    .step-actions {
        display: flex;
        justify-content: flex-end;
        margin-top: 0.5rem;
    }
    
    .step-remove {
        font-size: 0.75rem;
        font-weight: 500;
        color: var(--text-secondary);
        background: none;
        border: none;
        cursor: pointer;
        transition: color 0.3s;
    }
    
    .step-remove:hover {
        color: #ef4444;
    }
    
    .add-btn {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        font-size: 0.875rem;
        font-weight: 600;
        color: var(--primary);
        background: none;
        border: none;
        cursor: pointer;
        transition: all 0.3s;
    }
    
    .add-btn:hover {
        opacity: 0.8;
    }
    
    .add-btn .material-symbols-outlined {
        font-size: 1.25rem;
    }
    
    /* Action bar */
    .action-bar {
        position: sticky;
        bottom: 1rem;
        z-index: 50;
        margin-top: 2rem;
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(8px);
        border: 1px solid var(--border-color);
        border-radius: 0.75rem;
        padding: 1rem;
        display: flex;
        justify-content: flex-end;
        gap: 1rem;
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }
    
    .btn-cancel {
        background: transparent;
        color: var(--text-secondary);
        border-color: var(--border-color);
    }
    
    .btn-cancel:hover {
        background: #f9fafb;
        color: var(--text-main);
    }
    
    .btn-reset {
        background: white;
        color: var(--text-main);
        border-color: var(--border-color);
        box-shadow: 0 1px 2px rgba(0,0,0,0.05);
    }
    
    .btn-reset:hover {
        background: #f9fafb;
    }
    
    .btn-submit {
        background: var(--primary);
        color: white;
        box-shadow: 0 2px 4px rgba(238, 134, 43, 0.2);
    }
    
    .btn-submit:hover {
        background: var(--primary-hover);
        box-shadow: 0 4px 8px rgba(238, 134, 43, 0.3);
    }
    
    .btn .material-symbols-outlined {
        font-size: 1.25rem;
    }
</style>

<main class="main-content">
    <div class="content-wrapper">
        <!-- Breadcrumbs -->
        <div class="breadcrumbs">
            <a href="<%= request.getContextPath() %>/HomeServlet" class="breadcrumb-link">Trang chủ</a>
            <span style="color: var(--text-secondary);">/</span>
            <a href="<%= request.getContextPath() %>/CongThucCuaToiServlet" class="breadcrumb-link">Công thức của tôi</a>
            <span style="color: var(--text-secondary);">/</span>
            <span style="color: var(--text-main);"><%= isViewMode ? "Chi tiết" : "Sửa công thức" %></span>
        </div>

        <!-- Status badge -->
        <%
            String statusClass = "";
            String statusIcon = "";
            String statusText = "";
            
            if ("approved".equals(recipe.getStatus())) {
                statusClass = "approved";
                statusIcon = "check_circle";
                statusText = "Đã đăng";
            } else if ("pending".equals(recipe.getStatus())) {
                statusClass = "pending";
                statusIcon = "";
                statusText = "Chờ phê duyệt";
            } else if ("rejected".equals(recipe.getStatus())) {
                statusClass = "rejected";
                statusIcon = "cancel";
                statusText = "Bị từ chối";
            }
        %>
        <div class="status-badge <%= statusClass %>">
            <% if (!statusIcon.isEmpty()) { %>
                <span class="material-symbols-outlined"><%= statusIcon %></span>
            <% } %>
            <%= statusText %>
        </div>

        <!-- Rejection alert -->
        <% if ("rejected".equals(recipe.getStatus()) && recipe.getRejectionReason() != null && !recipe.getRejectionReason().isEmpty()) { %>
        <div class="rejection-alert">
            <span class="material-symbols-outlined">error</span>
            <div class="rejection-content">
                <div class="rejection-title">Lý do từ chối:</div>
                <div class="rejection-reason"><%= recipe.getRejectionReason() %></div>
            </div>
        </div>
        <% } %>

        <% if (isViewMode) { %>
            <!-- VIEW MODE -->
            
            <!-- Page heading with actions -->
            <div class="page-heading">
                <div>
                    <h1><%= recipe.getTitle() %></h1>
                    <% if (recipe.getDescription() != null && !recipe.getDescription().isEmpty()) { %>
                        <p><%= recipe.getDescription() %></p>
                    <% } %>
                </div>
                <div class="mode-actions">
                    <a href="<%= request.getContextPath() %>/CongThucCuaToiServlet" class="btn btn-back">
                        <span class="material-symbols-outlined">arrow_back</span>
                        Quay lại
                    </a>
                    <% if ("pending".equals(recipe.getStatus()) || "rejected".equals(recipe.getStatus())) { %>
                    <a href="<%= request.getContextPath() %>/SuaCongThucServlet?id=<%= recipe.getRecipeId() %>&mode=edit" class="btn btn-edit">
                        <span class="material-symbols-outlined">edit</span>
                        Sửa công thức
                    </a>
                    <% } %>
                </div>
            </div>

            <!-- Recipe image -->
            <% if (recipe.getImageUrl() != null && !recipe.getImageUrl().isEmpty()) { %>
            <div class="recipe-image-display">
                <img src="<%= recipe.getImageUrl() %>" alt="<%= recipe.getTitle() %>">
            </div>
            <% } %>

            <!-- Info grid -->
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-icon">
                        <span class="material-symbols-outlined">schedule</span>
                    </div>
                    <div class="info-content">
                        <div class="info-label">Thời gian</div>
                        <div class="info-value"><%= recipe.getCookingTime() %> phút</div>
                    </div>
                </div>
                
                <div class="info-item">
                    <div class="info-icon">
                        <span class="material-symbols-outlined">signal_cellular_alt</span>
                    </div>
                    <div class="info-content">
                        <div class="info-label">Độ khó</div>
                        <div class="info-value">
                            <% 
                                String diffText = "";
                                if ("easy".equals(recipe.getDifficultyLevel())) diffText = "Dễ";
                                else if ("medium".equals(recipe.getDifficultyLevel())) diffText = "Trung bình";
                                else if ("hard".equals(recipe.getDifficultyLevel())) diffText = "Khó";
                            %>
                            <%= diffText %>
                        </div>
                    </div>
                </div>
                
                <div class="info-item">
                    <div class="info-icon">
                        <span class="material-symbols-outlined">restaurant_menu</span>
                    </div>
                    <div class="info-content">
                        <div class="info-label">Khẩu phần</div>
                        <div class="info-value"><%= recipe.getServings() %> người</div>
                    </div>
                </div>
                
                <div class="info-item">
                    <div class="info-icon">
                        <span class="material-symbols-outlined">category</span>
                    </div>
                    <div class="info-content">
                        <div class="info-label">Danh mục</div>
                        <div class="info-value"><%= recipe.getCategoryName() %></div>
                    </div>
                </div>
            </div>

            <!-- Ingredients -->
            <div class="content-section">
                <h2 class="section-title">
                    <span class="material-symbols-outlined">shopping_cart</span>
                    Nguyên liệu
                </h2>
                <div class="ingredients-display">
                    <% for (String ingredient : ingredients) {
                        if (ingredient != null && !ingredient.trim().isEmpty()) { %>
                        <div class="ingredient-item">
                            <span class="material-symbols-outlined">check_circle</span>
                            <span><%= ingredient.trim() %></span>
                        </div>
                    <% } } %>
                </div>
            </div>

            <!-- Instructions -->
            <div class="content-section">
                <h2 class="section-title">
                    <span class="material-symbols-outlined">menu_book</span>
                    Các bước thực hiện
                </h2>
                <div class="steps-display">
                    <% 
                    int stepNum = 0;
                    for (String instruction : instructions) {
                        if (instruction != null && !instruction.trim().isEmpty()) {
                            stepNum++;
                            // Remove "Bước X:" if present
                            String stepText = instruction.replaceFirst("^Bước \\d+:\\s*", "").trim();
                    %>
                        <div class="step-display">
                            <div class="step-number"><%= stepNum %></div>
                            <div class="step-text"><%= stepText %></div>
                        </div>
                    <% } } %>
                </div>
            </div>

            <!-- Notes -->
            <% if (recipe.getNotes() != null && !recipe.getNotes().isEmpty()) { %>
            <div class="content-section">
                <h2 class="section-title">
                    <span class="material-symbols-outlined">notes</span>
                    Ghi chú
                </h2>
                <p style="line-height: 1.6; color: var(--text-main);"><%= recipe.getNotes() %></p>
            </div>
            <% } %>

        <% } else { %>
            <!-- EDIT MODE -->
            
            <div class="page-heading">
                <div>
                    <h1>Sửa Công Thức</h1>
                    <p>Cập nhật thông tin công thức của bạn</p>
                </div>
            </div>

            <form method="post" action="<%= request.getContextPath() %>/SuaCongThucServlet" enctype="multipart/form-data" id="editForm">
                <input type="hidden" name="recipeId" value="<%= recipe.getRecipeId() %>">
                <input type="hidden" name="oldImageUrl" value="<%= recipe.getImageUrl() != null ? recipe.getImageUrl() : "" %>">
                
                <!-- Section 1: Image & Basic Info -->
                <div class="form-grid">
                    <!-- Image Upload -->
                    <div>
                        <label class="image-upload-area" id="imageUploadArea">
                            <div class="upload-icon-wrapper">
                                <span class="material-symbols-outlined upload-icon">cloud_upload</span>
                            </div>
                            <div class="upload-text">
                                <div class="upload-title">Thay đổi ảnh</div>
                                <div class="upload-subtitle">Kéo thả hoặc nhấn để tải lên</div>
                                <div class="upload-hint">(Để trống nếu giữ ảnh cũ)</div>
                            </div>
                            <input type="file" 
                                   name="image" 
                                   id="imageInput" 
                                   accept="image/*" 
                                   style="display: none;">
                            
                            <div class="image-preview active" id="imagePreview">
                                <img src="<%= recipe.getImageUrl() %>" alt="Preview" id="previewImage">
                                <button type="button" class="remove-image-btn" id="removeImageBtn">
                                    <span class="material-symbols-outlined">close</span>
                                </button>
                            </div>
                        </label>
                    </div>

                    <!-- Basic Details -->
                    <div class="form-section">
                        <h3 class="section-title" style="font-size: 1.125rem;">Thông tin cơ bản</h3>
                        
                        <div class="form-group">
                            <label class="form-label">
                                Tiêu đề công thức <span class="required">*</span>
                            </label>
                            <input type="text" 
                                   name="title" 
                                   class="form-input" 
                                   value="<%= recipe.getTitle() %>"
                                   required>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Mô tả nhanh</label>
                            <textarea name="description" 
                                      class="form-textarea" 
                                      rows="3"><%= recipe.getDescription() != null ? recipe.getDescription() : "" %></textarea>
                        </div>
                    </div>
                </div>

                <!-- Section 2: Details Grid -->
                <div class="detail-grid">
                    <div class="form-section">
                        <div class="form-group">
                            <label class="form-label with-icon">
                                <span class="material-symbols-outlined">schedule</span>
                                Thời gian nấu
                            </label>
                            <div class="input-with-unit">
                                <input type="number" 
                                       name="cookingTime" 
                                       class="form-input" 
                                       value="<%= recipe.getCookingTime() %>"
                                       min="1" 
                                       required>
                                <span class="input-unit">phút</span>
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="form-group">
                            <label class="form-label with-icon">
                                <span class="material-symbols-outlined">signal_cellular_alt</span>
                                Độ khó
                            </label>
                            <select name="difficulty" class="form-select" required>
                                <option value="easy" <%= "easy".equals(recipe.getDifficultyLevel()) ? "selected" : "" %>>Dễ</option>
                                <option value="medium" <%= "medium".equals(recipe.getDifficultyLevel()) ? "selected" : "" %>>Trung bình</option>
                                <option value="hard" <%= "hard".equals(recipe.getDifficultyLevel()) ? "selected" : "" %>>Khó</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="form-group">
                            <label class="form-label with-icon">
                                <span class="material-symbols-outlined">restaurant_menu</span>
                                Khẩu phần
                            </label>
                            <div class="input-with-unit">
                                <input type="number" 
                                       name="servings" 
                                       class="form-input" 
                                       value="<%= recipe.getServings() %>"
                                       min="1" 
                                       required>
                                <span class="input-unit">người</span>
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="form-group">
                            <label class="form-label with-icon">
                                <span class="material-symbols-outlined">category</span>
                                Danh mục
                            </label>
                            <select name="categoryId" class="form-select" required>
                                <% if (categories != null) {
                                    for (danhmuc category : categories) { %>
                                        <option value="<%= category.getCategoryId() %>" 
                                                <%= category.getCategoryId() == recipe.getCategoryId() ? "selected" : "" %>>
                                            <%= category.getCategoryName() %>
                                        </option>
                                <%  }
                                } %>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Section 3: Ingredients -->
                <div class="form-section">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                        <h3 class="section-title" style="margin: 0; font-size: 1.125rem;">Nguyên liệu</h3>
                        <button type="button" class="add-btn" onclick="addIngredient()">
                            <span class="material-symbols-outlined">add_circle</span>
                            Thêm nguyên liệu
                        </button>
                    </div>
                    
                    <div class="ingredients-list" id="ingredientsList">
                        <% 
                        for (String ingredient : ingredients) {
                            if (ingredient != null && !ingredient.trim().isEmpty()) {
                                String[] parts = ingredient.trim().split(" ", 2);
                                String quantity = parts.length > 0 ? parts[0] : "";
                                String name = parts.length > 1 ? parts[1] : "";
                        %>
                        <div class="ingredient-row">
                            <input type="text" 
                                   name="ingredientQuantity[]" 
                                   class="form-input ingredient-quantity" 
                                   value="<%= quantity %>"
                                   placeholder="Số lượng">
                            <div class="ingredient-name-wrapper">
                                <input type="text" 
                                       name="ingredientName[]" 
                                       class="form-input ingredient-name" 
                                       value="<%= name %>"
                                       placeholder="Tên nguyên liệu">
                                <button type="button" class="remove-btn" onclick="removeIngredient(this)">
                                    <span class="material-symbols-outlined">delete</span>
                                </button>
                            </div>
                        </div>
                        <% } } %>
                    </div>
                </div>

                <!-- Section 4: Steps -->
                <div class="form-section">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                        <h3 class="section-title" style="margin: 0; font-size: 1.125rem;">Các bước thực hiện</h3>
                        <button type="button" class="add-btn" onclick="addStep()">
                            <span class="material-symbols-outlined">add_circle</span>
                            Thêm bước
                        </button>
                    </div>
                    
                    <div class="steps-list" id="stepsList">
                        <% 
                        int stepCount = 0;
                        for (String instruction : instructions) {
                            if (instruction != null && !instruction.trim().isEmpty()) {
                                stepCount++;
                                String stepText = instruction.replaceFirst("^Bước \\d+:\\s*", "").trim();
                        %>
                        <div class="step-item">
                            <div class="step-number"><%= stepCount %></div>
                            <div class="step-content">
                                <textarea name="step[]" 
                                          class="form-textarea" 
                                          rows="3"><%= stepText %></textarea>
                                <div class="step-actions">
                                    <button type="button" class="step-remove" onclick="removeStep(this)">Xóa bước</button>
                                </div>
                            </div>
                        </div>
                        <% } } %>
                    </div>
                </div>

                <!-- Section 5: Notes -->
                <div class="form-section">
                    <h3 class="section-title" style="font-size: 1.125rem;">
                        Ghi chú thêm <span style="font-weight: 400; font-size: 0.875rem; color: var(--text-secondary);">(Không bắt buộc)</span>
                    </h3>
                    <textarea name="notes" 
                              class="form-textarea" 
                              rows="4"><%= recipe.getNotes() != null ? recipe.getNotes() : "" %></textarea>
                </div>

                <!-- Action Bar -->
                <div class="action-bar">
                    <a href="<%= request.getContextPath() %>/CongThucCuaToiServlet" 
                       class="btn btn-cancel">Hủy bỏ</a>
                    <button type="button" class="btn btn-reset" onclick="location.reload()">Nhập lại</button>
                    <button type="submit" class="btn btn-submit">
                        <span class="material-symbols-outlined">save</span>
                        Lưu thay đổi
                    </button>
                </div>
            </form>

            <script>
                // Image upload preview
                const imageInput = document.getElementById('imageInput');
                const imagePreview = document.getElementById('imagePreview');
                const previewImage = document.getElementById('previewImage');
                const removeImageBtn = document.getElementById('removeImageBtn');

                imageInput.addEventListener('change', function(e) {
                    const file = e.target.files[0];
                    if (file) {
                        if (!file.type.startsWith('image/')) {
                            alert('Chỉ được upload file ảnh!');
                            this.value = '';
                            return;
                        }
                        
                        if (file.size > 5 * 1024 * 1024) {
                            alert('Kích thước file không được vượt quá 5MB!');
                            this.value = '';
                            return;
                        }
                        
                        const reader = new FileReader();
                        reader.onload = function(e) {
                            previewImage.src = e.target.result;
                            imagePreview.classList.add('active');
                        };
                        reader.readAsDataURL(file);
                    }
                });

                removeImageBtn.addEventListener('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    if (confirm('Bạn có muốn xóa ảnh này? Sẽ giữ lại ảnh cũ khi lưu.')) {
                        imageInput.value = '';
                        previewImage.src = '<%= recipe.getImageUrl() %>';
                    }
                });

                // Add ingredient
                function addIngredient() {
                    const ingredientsList = document.getElementById('ingredientsList');
                    const newIngredient = document.createElement('div');
                    newIngredient.className = 'ingredient-row';
                    newIngredient.innerHTML = `
                        <input type="text" 
                               name="ingredientQuantity[]" 
                               class="form-input ingredient-quantity" 
                               placeholder="Số lượng">
                        <div class="ingredient-name-wrapper">
                            <input type="text" 
                                   name="ingredientName[]" 
                                   class="form-input ingredient-name" 
                                   placeholder="Tên nguyên liệu">
                            <button type="button" class="remove-btn" onclick="removeIngredient(this)">
                                <span class="material-symbols-outlined">delete</span>
                            </button>
                        </div>
                    `;
                    ingredientsList.appendChild(newIngredient);
                }

                function removeIngredient(btn) {
                    const ingredientRow = btn.closest('.ingredient-row');
                    if (document.querySelectorAll('.ingredient-row').length > 1) {
                        ingredientRow.remove();
                    } else {
                        alert('Phải có ít nhất 1 nguyên liệu!');
                    }
                }

                // Add step
                let stepCounter = <%= stepCount %>;
                function addStep() {
                    stepCounter++;
                    const stepsList = document.getElementById('stepsList');
                    const newStep = document.createElement('div');
                    newStep.className = 'step-item';
                    newStep.innerHTML = `
                        <div class="step-number">${stepCounter}</div>
                        <div class="step-content">
                            <textarea name="step[]" 
                                      class="form-textarea" 
                                      rows="3"
                                      placeholder="Mô tả chi tiết bước này..."></textarea>
                            <div class="step-actions">
                                <button type="button" class="step-remove" onclick="removeStep(this)">Xóa bước</button>
                            </div>
                        </div>
                    `;
                    stepsList.appendChild(newStep);
                    updateStepNumbers();
                }

                function removeStep(btn) {
                    const stepItem = btn.closest('.step-item');
                    if (document.querySelectorAll('.step-item').length > 1) {
                        stepItem.remove();
                        stepCounter--;
                        updateStepNumbers();
                    } else {
                        alert('Phải có ít nhất 1 bước thực hiện!');
                    }
                }

                function updateStepNumbers() {
                    const stepItems = document.querySelectorAll('.step-item');
                    stepItems.forEach((item, index) => {
                        item.querySelector('.step-number').textContent = index + 1;
                    });
                }

                // Form submission
                document.getElementById('editForm').addEventListener('submit', function(e) {
                    // Combine ingredients
                    const quantities = document.querySelectorAll('input[name="ingredientQuantity[]"]');
                    const names = document.querySelectorAll('input[name="ingredientName[]"]');
                    let ingredientsText = '';
                    
                    for (let i = 0; i < quantities.length; i++) {
                        const qty = quantities[i].value.trim();
                        const name = names[i].value.trim();
                        if (qty && name) {
                            ingredientsText += qty + ' ' + name + '\n';
                        }
                    }
                    
                    const ingredientsInput = document.createElement('input');
                    ingredientsInput.type = 'hidden';
                    ingredientsInput.name = 'ingredients';
                    ingredientsInput.value = ingredientsText.trim();
                    this.appendChild(ingredientsInput);
                    
                    // Combine steps
                    const steps = document.querySelectorAll('textarea[name="step[]"]');
                    let instructionsText = '';
                    
                    steps.forEach((step, index) => {
                        const stepText = step.value.trim();
                        if (stepText) {
                            instructionsText += 'Bước ' + (index + 1) + ': ' + stepText + '\n\n';
                        }
                    });
                    
                    const instructionsInput = document.createElement('input');
                    instructionsInput.type = 'hidden';
                    instructionsInput.name = 'instructions';
                    instructionsInput.value = instructionsText.trim();
                    this.appendChild(instructionsInput);
                });
            </script>
        <% } %>
    </div>
</main>

<jsp:include page="include/footer.jsp" />
