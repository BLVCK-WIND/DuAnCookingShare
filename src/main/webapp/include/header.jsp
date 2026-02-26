<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.user" %>
<%
    // ✅ LẤY CUSTOMER USER (PREFIX: user_user) - KHÔNG DÙNG "user" CHUNG
    user currentUser = (user) session.getAttribute("user_user");
    
    // Debug log
    if (currentUser != null) {
        System.out.println("✅ header.jsp: Customer: " + currentUser.getUsername());
    } else {
        System.out.println("ℹ️ header.jsp: Khách vãng lai");
    }
    
    // Lấy tên trang hiện tại để highlight menu active
    String currentPage = request.getRequestURI();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "CookingShare" %></title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Noto+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/common.css">
    <style>
        /* User dropdown styles */
        .user-menu {
            position: relative;
        }
        
        .user-menu-button {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            background: white;
            border: 1px solid var(--border-color);
            border-radius: 9999px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .user-menu-button:hover {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
        }
        
        .user-avatar {
            width: 2rem;
            height: 2rem;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), #f59e0b);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 700;
            font-size: 0.875rem;
        }
        
        .user-dropdown {
            position: absolute;
            top: calc(100% + 0.5rem);
            right: 0;
            background: white;
            border: 1px solid var(--border-color);
            border-radius: 0.75rem;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            min-width: 200px;
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: all 0.3s;
            z-index: 1000;
        }
        
        .user-menu:hover .user-dropdown {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }
        
        .dropdown-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem 1rem;
            color: var(--text-main);
            font-size: 0.875rem;
            transition: all 0.3s;
            border-bottom: 1px solid var(--border-color);
        }
        
        .dropdown-item:last-child {
            border-bottom: none;
        }
        
        .dropdown-item:hover {
            background: var(--primary);
            color: white;
        }
        
        .dropdown-item:last-child:hover{
            background: var(--primary);
            color: white;
            border-bottom-right-radius: 0.75rem !important;
            border-bottom-left-radius: 0.75rem !important;
        }
        .dropdown-item:first-child:hover{
            background: var(--primary);
            color: white;
            border-top-right-radius: 0.75rem !important;
            border-top-left-radius: 0.75rem !important;
        }
        .dropdown-item .material-symbols-outlined {
            font-size: 1.25rem;
        }
        .login:hover{
            color: #ee6c2b!important;
        }
        
    </style>
</head>
<body>
    <!-- HEADER -->
    <header class="header">
        <div class="header-container">
            <div class="header-inner">
                <!-- Logo -->
                <a href="<%= request.getContextPath() %>/HomeServlet" class="logo">
                    <div class="logo-icon">
                        <span class="material-symbols-outlined">skillet</span>
                    </div>
                    <span class="logo-text">CookingShare</span>
                </a>

                <!-- Right Side -->
                <div class="header-right">
                    <!-- Navigation -->
                    <nav class="nav">
                        <a href="<%= request.getContextPath() %>/HomeServlet" 
                           class="<%= currentPage.contains("home.jsp") ? "active" : "" %>">
                            Trang chủ
                        </a>
                        <a href="<%= request.getContextPath() %>/CongThucServlet" 
                           class="<%= currentPage.contains("congThuc.jsp") ? "active" : "" %>">
                            Công thức
                        </a>
                        <a href="<%= request.getContextPath() %>/GioiThieuServlet"
                            class="<%= currentPage.contains("gioithieu.jsp") ? "active" : "" %>">
                            Giới thiệu
                        </a>
                    </nav>

                    <!-- Actions -->
                    <div class="header-actions">
                        <% if (currentUser != null) { %>
                            <!-- User Menu -->
                            <div class="user-menu">
                                <button class="user-menu-button">
                                    <img src="<%= request.getContextPath() %>/avatars/<%= currentUser.getAvatar() != null ? currentUser.getAvatar() : "avatar1" %>.jpg" 
                                         alt="<%= currentUser.getFullName() %>"
                                         class="user-avatar"
                                         onerror="this.src='<%= request.getContextPath() %>/avatars/avatar1.jpg'">
                                    <span style="font-weight: 600;">
                                        <%= currentUser.getFullName() != null && !currentUser.getFullName().isEmpty() 
                                            ? currentUser.getFullName() 
                                            : currentUser.getUsername() %>
                                    </span>
                                    <span class="material-symbols-outlined" style="font-size: 1.25rem;">
                                        expand_more
                                    </span>
                                </button>
                                
                                <div class="user-dropdown">
                                    <a href="<%= request.getContextPath() %>/TrangCaNhanServlet" class="dropdown-item">
                                        <span class="material-symbols-outlined">person</span>
                                        Trang cá nhân
                                    </a>
                                    <a href="<%= request.getContextPath() %>/CongThucCuaToiServlet" class="dropdown-item">
                                        <span class="material-symbols-outlined">restaurant</span>
                                        Công thức của tôi
                                    </a>
                                    <a href="<%= request.getContextPath() %>/YeuThichServlet" class="dropdown-item">
                                        <span class="material-symbols-outlined">favorite</span>
                                        Yêu thích
                                    </a>
                                    <!-- ✅ THÊM type=user vào logout -->
                                    <a href="<%= request.getContextPath() %>/LogoutServlet?type=user" class="dropdown-item">
                                        <span class="material-symbols-outlined">logout</span>
                                        Đăng xuất
                                    </a>
                                </div>
                            </div>
                        <% } else { %>
                            <a href="<%= request.getContextPath() %>/LoginServlet" class="login">Đăng nhập</a>
                            <a href="<%= request.getContextPath() %>/RegisterServlet" class="btn-register">
                                Đăng ký
                            </a>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </header>