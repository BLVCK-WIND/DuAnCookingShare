<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
	user currentUser = (user) session.getAttribute("admin_user");
	Boolean isAdmin = (Boolean) session.getAttribute("admin_isAdmin");
	if (currentUser == null || isAdmin == null || !isAdmin) {
        response.sendRedirect("LoginServlet");
        return;
    }
    
    @SuppressWarnings("unchecked")
    List<user> userList = (List<user>) request.getAttribute("userList");
    if (userList == null) userList = new ArrayList<>();
    
    String successMsg = (String) request.getAttribute("success");
    String errorMsg = (String) request.getAttribute("error");
    String searchKeyword = (String) request.getAttribute("searchKeyword");
    if (searchKeyword == null) searchKeyword = "";
%>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Người Dùng - Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;700;900&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: "#ee862b",
                        "bg-light": "#fcfaf8",
                        "text-main": "#1b140d",
                        "text-secondary": "#9a704c",
                        "border-color": "#e7dacf",
                    },
                    fontFamily: {
                        display: ["Be Vietnam Pro", "sans-serif"],
                    },
                },
            },
        };
    </script>
</head>
<body class="bg-bg-light font-display text-text-main">
    <!-- Admin Header -->
    <header class="bg-white border-b border-border-color sticky top-0 z-50 shadow-sm">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-16">
                <div class="flex items-center gap-3">
                    <span class="material-symbols-outlined text-primary text-3xl">admin_panel_settings</span>
                    <div>
                        <h1 class="text-xl font-bold text-text-main">Quản Lý Người Dùng</h1>
                        <p class="text-xs text-text-secondary">Xem và quản lý tài khoản người dùng</p>
                    </div>
                </div>
                
                <div class="flex items-center gap-4">
                    <span class="text-sm text-text-secondary">Xin chào, <strong><%= currentUser.getFullName() %></strong></span>
                    <a href="LogoutServlet" class="flex items-center gap-2 px-4 py-2 bg-red-500 hover:bg-red-600 text-white rounded-lg transition-colors text-sm font-medium">
                        <span class="material-symbols-outlined text-lg">logout</span>
                        Đăng xuất
                    </a>
                </div>
            </div>
        </div>
    </header>

    <!-- Navigation Tabs -->
    <nav class="bg-white border-b border-border-color sticky top-16 z-40">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex gap-1">
                <a href="AdminDashboardServlet" 
                   class="px-6 py-3 text-sm font-medium text-text-secondary hover:text-primary transition-colors">
                    <span class="flex items-center gap-2">
                        <span class="material-symbols-outlined text-lg">dashboard</span>
                        Tổng Quan
                    </span>
                </a>
                <a href="AdminUserServlet" 
                   class="px-6 py-3 text-sm font-semibold border-b-2 border-primary text-primary">
                    <span class="flex items-center gap-2">
                        <span class="material-symbols-outlined text-lg">group</span>
                        Người Dùng
                    </span>
                </a>
                <a href="AdminCongThucServlet" 
                   class="px-6 py-3 text-sm font-medium text-text-secondary hover:text-primary transition-colors">
                    <span class="flex items-center gap-2">
                        <span class="material-symbols-outlined text-lg">restaurant_menu</span>
                        Món Ăn
                    </span>
                </a>
                <a href="AdminDanhMucServlet" 
                   class="px-6 py-3 text-sm font-medium text-text-secondary hover:text-primary transition-colors">
                    <span class="flex items-center gap-2">
                        <span class="material-symbols-outlined text-lg">category</span>
                        Danh Mục
                    </span>
                </a>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pt-8">
        <!-- Success/Error Messages -->
        <% if (successMsg != null) { %>
        <div class="mb-6 p-4 bg-green-50 border border-green-200 rounded-lg flex items-center gap-3">
            <span class="material-symbols-outlined text-green-600">check_circle</span>
            <p class="text-green-800"><%= successMsg %></p>
        </div>
        <% } %>
        
        <% if (errorMsg != null) { %>
        <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg flex items-center gap-3">
            <span class="material-symbols-outlined text-red-600">error</span>
            <p class="text-red-800"><%= errorMsg %></p>
        </div>
        <% } %>

        <!-- âœ… Má»šI: Search Form -->
        <div class="mb-6">
            <form action="AdminUserServlet" method="get" class="flex gap-3">
                <input type="hidden" name="action" value="search">
                <div class="flex-1 relative">
                    <input type="text" 
                           name="keyword" 
                           value="<%= searchKeyword %>"
                           placeholder="Tìm kiếm theo mã, tên đăng nhập hoặc họ tên..."
                           class="w-full px-4 py-3 pl-12 border border-border-color rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-all">
                    <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-text-secondary">search</span>
                </div>
                <button type="submit" 
                        class="px-6 py-3 bg-primary hover:bg-primary/90 text-white rounded-lg font-medium transition-colors flex items-center gap-2">
                    <span class="material-symbols-outlined">search</span>
                    Tìm kiếm
                </button>
                <% if (!searchKeyword.isEmpty()) { %>
                <a href="AdminUserServlet" 
                   class="px-6 py-3 bg-gray-200 hover:bg-gray-300 text-text-main rounded-lg font-medium transition-colors flex items-center gap-2">
                    <span class="material-symbols-outlined">close</span>
                    Xóa lọc
                </a>
                <% } %>
            </form>
        </div>

        <!-- User Table -->
        <div class="bg-white rounded-2xl shadow-md overflow-hidden">
            <div class="px-6 py-4 border-b border-border-color bg-gradient-to-r from-primary/5 to-transparent">
                <div class="flex justify-between items-center">
                    <h2 class="text-lg font-bold text-text-main flex items-center gap-2">
                        <span class="material-symbols-outlined text-primary">group</span>
                        Danh Sách Người Dùng (<%= userList.size() %>)
                        <% if (!searchKeyword.isEmpty()) { %>
                        <span class="text-sm font-normal text-text-secondary">- Kết quả tìm kiếm cho: "<%= searchKeyword %>"</span>
                        <% } %>
                    </h2>
                </div>
            </div>

            <div class="overflow-x-auto">
                <table class="w-full">
                    <thead class="bg-gray-50 border-b border-border-color">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-text-secondary uppercase tracking-wider">ID</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-text-secondary uppercase tracking-wider">Tên Đăng Nhập</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-text-secondary uppercase tracking-wider">Họ Tên</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-text-secondary uppercase tracking-wider">Email</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-text-secondary uppercase tracking-wider">Quyền</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-text-secondary uppercase tracking-wider">Ngày Tạo</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-text-secondary uppercase tracking-wider">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-border-color">
                        <% 
                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                        for (user u : userList) { 
                        %>
                        <tr class="hover:bg-primary/5 transition-colors">
                            <td class="px-6 py-4 text-sm font-medium text-text-main"><%= u.getUserId() %></td>
                            <td class="px-6 py-4 text-sm text-text-main">
                                <div class="flex items-center gap-2">
                                    <span class="material-symbols-outlined text-primary">person</span>
                                    <%= u.getUsername() %>
                                </div>
                            </td>
                            <td class="px-6 py-4 text-sm text-text-main"><%= u.getFullName() %></td>
                            <td class="px-6 py-4 text-sm text-text-secondary"><%= u.getEmail() %></td>
                            <td class="px-6 py-4">
                                <% if (u.isAdmin()) { %>
                                <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold bg-red-100 text-red-800">
                                    <span class="material-symbols-outlined text-xs mr-1">admin_panel_settings</span>
                                    Admin
                                </span>
                                <% } else { %>
                                <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold bg-blue-100 text-blue-800">
                                    <span class="material-symbols-outlined text-xs mr-1">person</span>
                                    User
                                </span>
                                <% } %>
                            </td>
                            <td class="px-6 py-4 text-sm text-text-secondary">
                                <%= u.getCreatedAt() != null ? sdf.format(u.getCreatedAt()) : "N/A" %>
                            </td>
                            <td class="px-6 py-4 text-sm">
                                <div class="flex items-center gap-2">
                                    <a href="AdminUserServlet?action=view&userId=<%= u.getUserId() %>" 
                                       class="p-2 bg-blue-500 hover:bg-blue-600 text-white rounded-lg transition-colors"
                                       title="Xem chi tiết">
                                        <span class="material-symbols-outlined text-base">visibility</span>
                                    </a>
                                    
                                    <% if (!u.isAdmin() && u.getUserId() != currentUser.getUserId()) { %>
                                    <button onclick="confirmDelete(<%= u.getUserId() %>, '<%= u.getUsername() %>')" 
                                            class="p-2 bg-red-500 hover:bg-red-600 text-white rounded-lg transition-colors"
                                            title="Xóa người dùng">
                                        <span class="material-symbols-outlined text-base">delete</span>
                                    </button>
                                    <% } else { %>
                                    <button disabled 
                                            class="p-2 bg-gray-300 text-gray-500 rounded-lg cursor-not-allowed opacity-50"
                                            title="Không thể xóa">
                                        <span class="material-symbols-outlined text-base">block</span>
                                    </button>
                                    <% } %>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                        
                        <% if (userList.isEmpty()) { %>
                        <tr>
                            <td colspan="7" class="px-6 py-8 text-center text-text-secondary">
                                <span class="material-symbols-outlined text-6xl text-text-secondary opacity-30 block mb-2">person_off</span>
                                <% if (!searchKeyword.isEmpty()) { %>
                                Không tìm thấy người dùng nào với từ khóa "<%= searchKeyword %>"
                                <% } else { %>
                                Không có người dùng nào
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <script>
        function confirmDelete(userId, username) {
            if (confirm('Bạn có chắc chắn muốn xóa người dùng "' + username + '"?\nMọi dữ liệu liên quan (món ăn, yêu thích) sẽ bị xóa theo.')) {
                window.location.href = 'AdminUserServlet?action=delete&userId=' + userId;
            }
        }
    </script>
</body>
</html>
