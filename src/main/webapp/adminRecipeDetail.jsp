<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.congthuc" %>
<%@ page import="Model.user" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    user adminUser = (user) session.getAttribute("admin_user");
    if (adminUser == null || !adminUser.isAdmin()) {
        response.sendRedirect("LoginServlet");
        return;
    }
    
    congthuc recipe = (congthuc) request.getAttribute("recipe");
    if (recipe == null) {
        response.sendRedirect("AdminCongThucServlet");
        return;
    }
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết món ăn - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #2ecc71;
            --secondary-color: #27ae60;
            --warning-color: #f39c12;
            --danger-color: #e74c3c;
            --dark-color: #2c3e50;
            --light-bg: #f8f9fa;
        }
        
        body {
            background-color: var(--light-bg);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .navbar {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .recipe-detail-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            margin-top: 30px;
            overflow: hidden;
        }
        
        .recipe-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
        }
        
        .recipe-image {
            width: 100%;
            max-height: 500px;
            object-fit: cover;
            border-radius: 10px;
        }
        
        .status-badge {
            padding: 8px 20px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            display: inline-block;
        }
        
        .status-pending {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
        }
        
        .status-approved {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            color: white;
        }
        
        .status-rejected {
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            color: white;
        }
        
        .info-section {
            padding: 30px;
        }
        
        .info-row {
            padding: 15px 0;
            border-bottom: 1px solid #e9ecef;
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 600;
            color: var(--dark-color);
            min-width: 150px;
            display: inline-block;
        }
        
        .info-value {
            color: #555;
        }
        
        .ingredients-section, .instructions-section {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 10px;
            margin: 20px 0;
        }
        
        .section-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--dark-color);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .section-title i {
            color: var(--primary-color);
        }
        
        .ingredient-item {
            padding: 10px 0;
            border-bottom: 1px dashed #dee2e6;
        }
        
        .ingredient-item:last-child {
            border-bottom: none;
        }
        
        .instruction-step {
            background: white;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 15px;
            border-left: 4px solid var(--primary-color);
        }
        
        .step-number {
            background: var(--primary-color);
            color: white;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-right: 10px;
        }
        
        .action-buttons {
            padding: 30px;
            background: #f8f9fa;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        
        .btn-approve {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .btn-approve:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(67, 233, 123, 0.4);
            color: white;
        }
        
        .btn-reject {
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .btn-reject:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(250, 112, 154, 0.4);
            color: white;
        }
        
        .btn-delete {
            background: linear-gradient(135deg, #eb3349 0%, #f45c43 100%);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .btn-delete:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(235, 51, 73, 0.4);
            color: white;
        }
        
        .btn-back {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 10px 30px;
            border-radius: 25px;
            transition: all 0.3s;
        }
        
        .btn-back:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            color: white;
        }
        
        .rejection-reason {
            background: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 15px;
            border-radius: 5px;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Nút quay lại -->
        <div class="mt-4">
            <a href="AdminCongThucServlet" class="btn btn-back">
                <i class="fas fa-arrow-left"></i> Quay lại danh sách
            </a>
        </div>

        <!-- Card chi tiết món ăn -->
        <div class="recipe-detail-card">
            <!-- Header -->
            <div class="recipe-header">
                <div class="d-flex justify-content-between align-items-start flex-wrap">
                    <div>
                        <h2 class="mb-2"><%= recipe.getTitle() %></h2>
                        <p class="mb-0">
                            <i class="fas fa-user"></i> 
                            Đăng bởi: <strong><%= recipe.getAuthorName() != null ? recipe.getAuthorName() : "User ID " + recipe.getUserId() %></strong>
                        </p>
                    </div>
                    <div>
                        <% 
                        String status = recipe.getStatus();
                        String statusClass = "";
                        String statusText = "";
                        String statusIcon = "";
                        
                        if ("pending".equals(status)) {
                            statusClass = "status-pending";
                            statusText = "Chờ duyệt";
                            statusIcon = "fa-clock";
                        } else if ("approved".equals(status)) {
                            statusClass = "status-approved";
                            statusText = "Đã duyệt";
                            statusIcon = "fa-check-circle";
                        } else if ("rejected".equals(status)) {
                            statusClass = "status-rejected";
                            statusText = "Đã từ chối";
                            statusIcon = "fa-times-circle";
                        }
                        %>
                        <span class="status-badge <%= statusClass %>">
                            <i class="fas <%= statusIcon %>"></i> <%= statusText %>
                        </span>
                    </div>
                </div>
            </div>

            <!-- Ảnh món ăn -->
            <div class="info-section">
                <div class="text-center mb-4">
                    <img src="<%= recipe.getImageUrl() != null ? recipe.getImageUrl() : "images/default-recipe.jpg" %>" 
                         alt="<%= recipe.getTitle() %>" 
                         class="recipe-image">
                </div>

                <!-- Thông tin cơ bản -->
                <div class="row mb-4">
                    <div class="col-md-6">
                        <div class="info-row">
                            <span class="info-label">
                                <i class="fas fa-tag"></i> Danh mục:
                            </span>
                            <span class="info-value"><%= recipe.getCategoryName() != null ? recipe.getCategoryName() : "N/A" %></span>
                        </div>
                        
                        <div class="info-row">
                            <span class="info-label">
                                <i class="fas fa-clock"></i> Thời gian:
                            </span>
                            <span class="info-value"><%= recipe.getCookingTime() %> phút</span>
                        </div>
                        
                        <div class="info-row">
                            <span class="info-label">
                                <i class="fas fa-users"></i> Khẩu phần:
                            </span>
                            <span class="info-value"><%= recipe.getServings() %> người</span>
                        </div>
                    </div>
                    
                    <div class="col-md-6">
                        <div class="info-row">
                            <span class="info-label">
                                <i class="fas fa-signal"></i> Độ khó:
                            </span>
                            <span class="info-value">
                                <% 
                                String difficultyEN = recipe.getDifficultyLevel();
                                String difficulty = "";
                                String diffColor = "";
                                
                                // Chuyển đổi từ tiếng Anh sang tiếng Việt
                                if ("Easy".equalsIgnoreCase(difficultyEN)) {
                                    difficulty = "Dễ";
                                    diffColor = "text-success";
                                } else if ("Medium".equalsIgnoreCase(difficultyEN)) {
                                    difficulty = "Trung bình";
                                    diffColor = "text-warning";
                                } else if ("Hard".equalsIgnoreCase(difficultyEN)) {
                                    difficulty = "Khó";
                                    diffColor = "text-danger";
                                } else {
                                    difficulty = difficultyEN != null ? difficultyEN : "N/A";
                                    diffColor = "text-secondary";
                                }
                                %>
                                <strong class="<%= diffColor %>"><%= difficulty %></strong>
                            </span>
                        </div>
                        
                        <div class="info-row">
                            <span class="info-label">
                                <i class="fas fa-calendar-alt"></i> Ngày đăng:
                            </span>
                            <span class="info-value">
                                <%= recipe.getCreatedAt() != null ? sdf.format(recipe.getCreatedAt()) : "N/A" %>
                            </span>
                        </div>
                        
                        <div class="info-row">
                            <span class="info-label">
                                <i class="fas fa-eye"></i> Lượt xem:
                            </span>
                            <span class="info-value"><%= recipe.getViewCount() %></span>
                        </div>
                    </div>
                </div>

                <!-- Mô tả -->
                <% if (recipe.getDescription() != null && !recipe.getDescription().isEmpty()) { %>
                <div class="mb-4">
                    <h5><i class="fas fa-info-circle text-primary"></i> Mô tả</h5>
                    <p class="text-muted"><%= recipe.getDescription() %></p>
                </div>
                <% } %>

                <!-- Nguyên liệu -->
                <div class="ingredients-section">
                    <h4 class="section-title">
                        <i class="fas fa-carrot"></i> Nguyên liệu
                    </h4>
                    <% 
                    String ingredients = recipe.getIngredients();
                    if (ingredients != null && !ingredients.isEmpty()) {
                        String[] ingredientList = ingredients.split("\n");
                        for (String ingredient : ingredientList) {
                            if (!ingredient.trim().isEmpty()) {
                    %>
                        <div class="ingredient-item">
                            <i class="fas fa-check text-success me-2"></i>
                            <%= ingredient.trim() %>
                        </div>
                    <%      }
                        }
                    }
                    %>
                </div>

                <!-- Hướng dẫn -->
                <div class="instructions-section">
                    <h4 class="section-title">
                        <i class="fas fa-list-ol"></i> Cách làm
                    </h4>
                    <% 
                    String instructions = recipe.getInstructions();
                    if (instructions != null && !instructions.isEmpty()) {
                        String[] steps = instructions.split("\n");
                        int stepNumber = 1;
                        for (String step : steps) {
                            if (!step.trim().isEmpty()) {
                    %>
                        <div class="instruction-step">
                            <span class="step-number"><%= stepNumber++ %></span>
                            <%= step.trim() %>
                        </div>
                    <%      }
                        }
                    }
                    %>
                </div>

                <!-- Lý do từ chối (nếu có) -->
                <% if ("rejected".equals(recipe.getStatus()) && recipe.getRejectionReason() != null) { %>
                <div class="rejection-reason">
                    <h5 class="text-warning">
                        <i class="fas fa-exclamation-triangle"></i> Lý do từ chối
                    </h5>
                    <p class="mb-0"><%= recipe.getRejectionReason() %></p>
                </div>
                <% } %>
            </div>

            <!-- Action buttons -->
            <div class="action-buttons">
                <% if ("pending".equals(recipe.getStatus())) { %>
                    <!-- Nút duyệt -->
                    <form action="AdminCongThucServlet" method="post" style="display: inline;">
                        <input type="hidden" name="action" value="approve">
                        <input type="hidden" name="recipeId" value="<%= recipe.getRecipeId() %>">
                        <button type="submit" class="btn btn-approve" 
                                onclick="return confirm('Bạn có chắc muốn duyệt món ăn này?')">
                            <i class="fas fa-check"></i> Duyệt món ăn
                        </button>
                    </form>

                    <!-- Nút từ chối -->
                    <button class="btn btn-reject" data-bs-toggle="modal" data-bs-target="#rejectModal">
                        <i class="fas fa-times"></i> Từ chối
                    </button>
                <% } %>

                <!-- Nút xóa -->
                <form action="AdminCongThucServlet" method="post" style="display: inline;">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="recipeId" value="<%= recipe.getRecipeId() %>">
                    <input type="hidden" name="currentStatus" value="<%= recipe.getStatus() %>">
                    <button type="submit" class="btn btn-delete" 
                            onclick="return confirm('Bạn có chắc muốn XÓA VĨNH VIỄN món ăn này?')">
                        <i class="fas fa-trash"></i> Xóa món ăn
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal từ chối -->
    <div class="modal fade" id="rejectModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-exclamation-triangle text-warning"></i> 
                        Từ chối món ăn
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="AdminCongThucServlet" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="reject">
                        <input type="hidden" name="recipeId" value="<%= recipe.getRecipeId() %>">
                        
                        <div class="mb-3">
                            <label class="form-label">Lý do từ chối: <span class="text-danger">*</span></label>
                            <textarea name="reason" class="form-control" rows="4" 
                                      placeholder="Vui lòng nhập lý do từ chối..." required></textarea>
                        </div>
                        
                        <div class="alert alert-warning">
                            <i class="fas fa-info-circle"></i>
                            Lý do này sẽ được gửi đến người dùng để họ có thể chỉnh sửa.
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-times"></i> Xác nhận từ chối
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
