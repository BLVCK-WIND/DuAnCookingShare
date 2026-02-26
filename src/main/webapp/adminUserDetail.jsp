<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.user" %>
<%
    user userDetail = (user) request.getAttribute("userDetail");
    Integer recipeCount = (Integer) request.getAttribute("recipeCount");
    Integer favoritesReceived = (Integer) request.getAttribute("favoritesReceived");
    Integer favoritesSent = (Integer) request.getAttribute("favoritesSent");
    
    // Kiểm tra session admin
    user adminUser = (user) session.getAttribute("admin_user");
    if (adminUser == null || !adminUser.isAdmin()) {
        response.sendRedirect("LoginServlet");
        return;
    }
    
    if (userDetail == null) {
        response.sendRedirect("AdminUserServlet");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết người dùng - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #2ecc71;
            --secondary-color: #27ae60;
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
        
        .user-detail-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            padding: 30px;
            margin-top: 30px;
        }
        
        .avatar-large {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 5px solid var(--primary-color);
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
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
        
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            margin-bottom: 20px;
            transition: transform 0.3s;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-card.recipes {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
        
        .stat-card.likes {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }
        
        .stat-card.favorites {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
        }
        
        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            margin: 10px 0;
        }
        
        .stat-label {
            font-size: 0.9rem;
            opacity: 0.9;
        }
        
        .badge-admin {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 0.85rem;
        }
        
        .badge-user {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 0.85rem;
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
    </style>
</head>
<body> 
    <div class="container">
        <!-- Nút quay lại -->
        <div class="mt-4">
            <a href="AdminUserServlet" class="btn btn-back">
                <i class="fas fa-arrow-left"></i> Quay lại danh sách
            </a>
        </div>

        <!-- Card thông tin người dùng -->
        <div class="user-detail-card">
            <div class="row">
                <!-- Avatar và thông tin cơ bản -->
                <div class="col-md-4 text-center">
                    
                    <h3 class="mb-2"><%= userDetail.getFullName() %></h3>
                    
                    <% if (userDetail.isAdmin()) { %>
                        <span class="badge badge-admin">
                            <i class="fas fa-crown"></i> Administrator
                        </span>
                    <% } else { %>
                        <span class="badge badge-user">
                            <i class="fas fa-user"></i> Người dùng
                        </span>
                    <% } %>
                </div>

                <!-- Thông tin chi tiết -->
                <div class="col-md-8">
                    <h4 class="mb-4">
                        <i class="fas fa-info-circle text-primary"></i> Thông tin chi tiết
                    </h4>
                    
                    <div class="info-row">
                        <span class="info-label">
                            <i class="fas fa-id-badge"></i> ID:
                        </span>
                        <span class="info-value"><%= userDetail.getUserId() %></span>
                    </div>
                    
                    <div class="info-row">
                        <span class="info-label">
                            <i class="fas fa-user"></i> Tên đăng nhập:
                        </span>
                        <span class="info-value"><%= userDetail.getUsername() %></span>
                    </div>
                    
                    <div class="info-row">
                        <span class="info-label">
                            <i class="fas fa-signature"></i> Họ tên:
                        </span>
                        <span class="info-value"><%= userDetail.getFullName() %></span>
                    </div>
                    
                    <div class="info-row">
                        <span class="info-label">
                            <i class="fas fa-envelope"></i> Email:
                        </span>
                        <span class="info-value"><%= userDetail.getEmail() %></span>
                    </div>
                    
                    <div class="info-row">
                        <span class="info-label">
                            <i class="fas fa-calendar-alt"></i> Ngày tạo:
                        </span>
                        <span class="info-value">
                            <%= userDetail.getCreatedAt() != null ? 
                                new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(userDetail.getCreatedAt()) : 
                                "N/A" %>
                        </span>
                    </div>
                    
                    <div class="info-row">
                        <span class="info-label">
                            <i class="fas fa-shield-alt"></i> Quyền:
                        </span>
                        <span class="info-value">
                            <%= userDetail.isAdmin() ? "Administrator" : "Người dùng thường" %>
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Thống kê hoạt động -->
        <div class="row mt-4 mb-5">
            <div class="col-md-4">
                <div class="stat-card recipes">
                    <i class="fas fa-utensils fa-2x mb-2"></i>
                    <div class="stat-number"><%= recipeCount != null ? recipeCount : 0 %></div>
                    <div class="stat-label">Công thức đã đăng</div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="stat-card likes">
                    <i class="fas fa-heart fa-2x mb-2"></i>
                    <div class="stat-number"><%= favoritesReceived != null ? favoritesReceived : 0 %></div>
                    <div class="stat-label">Lượt yêu thích nhận được</div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="stat-card favorites">
                    <i class="fas fa-bookmark fa-2x mb-2"></i>
                    <div class="stat-number"><%= favoritesSent != null ? favoritesSent : 0 %></div>
                    <div class="stat-label">Công thức đã yêu thích</div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
