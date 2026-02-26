<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.*" %>
<%@ page import="java.util.*" %>
<%
    // Kiểm tra đăng nhập và quyền admin
    // ✅ ƯU TIÊN LẤY TỪ REQUEST ATTRIBUTE (được set bởi AdminDashboardServlet)
    user currentUser = (user) session.getAttribute("admin_user");
	Boolean isAdmin = (Boolean) session.getAttribute("admin_isAdmin");
	if (currentUser == null || isAdmin == null || !isAdmin) {
        response.sendRedirect("LoginServlet");
        return;
    }
    
    // Lấy dữ liệu thống kê
    thongkedao statsDAO = new thongkedao();
    int totalRecipes = statsDAO.countTotalRecipes();
    int totalUsers = statsDAO.countTotalUsers();
    int recipesLast7Days = statsDAO.countRecipesLast7Days();
    
    List<congthuc> topViewed = statsDAO.getTop5MostViewed();
    List<congthuc> topFavorite = statsDAO.getTop5MostFavorite();
%>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - CookingShare</title>
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
                        <h1 class="text-xl font-bold text-text-main">Admin Dashboard</h1>
                        <p class="text-xs text-text-secondary">Trang quản trị CookingShare</p>
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
                   class="px-6 py-3 text-sm font-semibold border-b-2 border-primary text-primary">
                    <span class="flex items-center gap-2">
                        <span class="material-symbols-outlined text-lg">dashboard</span>
                        Tổng Quan
                    </span>
                </a>
                <a href="AdminUserServlet" 
                   class="px-6 py-3 text-sm font-medium text-text-secondary hover:text-primary transition-colors">
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
        <!-- Stats Cards -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
            <!-- Total Recipes -->
            <a  href="AdminCongThucServlet">
	            <div class="bg-gradient-to-br from-blue-500 to-blue-600 rounded-2xl p-6 text-white shadow-lg">
	                <div class="flex items-center justify-between mb-4">
	                    <div class="bg-white/20 p-3 rounded-xl">
	                        <span class="material-symbols-outlined text-4xl">restaurant_menu</span>
	                    </div>
	                    <div class="text-right">
	                        <p class="text-sm opacity-90 mb-1">Tổng Món Ăn</p>
	                        <p class="text-4xl font-bold"><%= totalRecipes %></p>
	                    </div>
	                </div>
	            
	                <div class="flex items-center gap-2 text-sm opacity-90">
	                    <span class="material-symbols-outlined text-base">trending_up</span>
	                    <span><%= recipesLast7Days %> món trong 7 ngày qua</span>
	                </div>
	            </div>
			</a>
            <!-- Total Users -->
            <a  href="AdminUserServlet">
            <div class="bg-gradient-to-br from-green-500 to-green-600 rounded-2xl p-6 text-white shadow-lg">
                <div class="flex items-center justify-between mb-4">
                    <div class="bg-white/20 p-3 rounded-xl">
                        <span class="material-symbols-outlined text-4xl">group</span>
                    </div>
                    <div class="text-right">
                        <p class="text-sm opacity-90 mb-1">Người Dùng</p>
                        <p class="text-4xl font-bold"><%= totalUsers %></p>
                    </div>
                </div>
                <div class="flex items-center gap-2 text-sm opacity-90">
                    <span class="material-symbols-outlined text-base">person_add</span>
                    <span>Đang hoạt động</span>
                </div>
            </div>
            </a>

            <!-- Pending Approval -->
            <%
                congthucdao recipeDAO = new congthucdao();
                // Tạm thời đếm bằng cách lấy tất cả và filter
                int pendingCount = recipeDAO.countRecipesByStatus("pending");
                // TODO: Thêm method countPendingRecipes() vào congthucdao
            %>
            <a href="AdminCongThucServlet?status=pending">
            <div class="bg-gradient-to-br from-orange-500 to-orange-600 rounded-2xl p-6 text-white shadow-lg">
                <div class="flex items-center justify-between mb-4">
                    <div class="bg-white/20 p-3 rounded-xl">
                        <span class="material-symbols-outlined text-4xl">pending</span>
                    </div>
                    <div class="text-right">
                        <p class="text-sm opacity-90 mb-1">Chờ Duyệt</p>
                        <p class="text-4xl font-bold"><%= pendingCount %></p>
                    </div>
                </div>
                <div class="flex items-center gap-2 text-sm opacity-90">
                    <span class="material-symbols-outlined text-base">schedule</span>
                    <span>Cần xem xét</span>
                </div>
            </div>
            </a>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
            <!-- Top Viewed Recipes -->
            <div class="bg-white rounded-2xl shadow-md overflow-hidden">
                <div class="px-6 py-4 border-b border-border-color bg-gradient-to-r from-primary/5 to-transparent">
                    <h2 class="text-lg font-bold text-text-main flex items-center gap-2">
                        <span class="material-symbols-outlined text-primary">visibility</span>
                        Top 5 Món Được Xem Nhiều Nhất
                    </h2>
                </div>
                <div class="p-6">
                    <div class="space-y-4">
                        <% for (int i = 0; i < topViewed.size(); i++) {
                            congthuc recipe = topViewed.get(i);
                        %>
                        <div class="flex items-center gap-4 p-3 rounded-xl hover:bg-primary/5 transition-colors">
                            <div class="flex-shrink-0 w-12 h-12 bg-primary/10 rounded-full flex items-center justify-center">
                                <span class="text-primary font-bold text-lg">#<%= i + 1 %></span>
                            </div>
                            <img src="<%= recipe.getImageUrl() %>" 
                                 alt="<%= recipe.getTitle() %>"
                                 class="w-16 h-16 object-cover rounded-lg">
                            <div class="flex-1 min-w-0">
                                <h3 class="font-semibold text-text-main truncate"><%= recipe.getTitle() %></h3>
                                <p class="text-sm text-text-secondary">
                                    <span class="material-symbols-outlined text-xs align-middle">visibility</span>
                                    <%= recipe.getViewCount() %> lượt xem
                                </p>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Top Favorite Recipes -->
            <div class="bg-white rounded-2xl shadow-md overflow-hidden">
                <div class="px-6 py-4 border-b border-border-color bg-gradient-to-r from-red-500/5 to-transparent">
                    <h2 class="text-lg font-bold text-text-main flex items-center gap-2">
                        <span class="material-symbols-outlined text-red-500">favorite</span>
                        Top 5 Món Được Yêu Thích Nhất
                    </h2>
                </div>
                <div class="p-6">
                    <div class="space-y-4">
                        <% for (int i = 0; i < topFavorite.size(); i++) {
                            congthuc recipe = topFavorite.get(i);
                        %>
                        <div class="flex items-center gap-4 p-3 rounded-xl hover:bg-red-500/5 transition-colors">
                            <div class="flex-shrink-0 w-12 h-12 bg-red-500/10 rounded-full flex items-center justify-center">
                                <span class="text-red-500 font-bold text-lg">#<%= i + 1 %></span>
                            </div>
                            <img src="<%= recipe.getImageUrl() %>" 
                                 alt="<%= recipe.getTitle() %>"
                                 class="w-16 h-16 object-cover rounded-lg">
                            <div class="flex-1 min-w-0">
                                <h3 class="font-semibold text-text-main truncate"><%= recipe.getTitle() %></h3>
                                <p class="text-sm text-text-secondary">
                                    <span class="material-symbols-outlined text-xs align-middle">favorite</span>
                                    <%= recipe.getTotalFavorites() %> lượt thích
                                </p>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="mt-8 bg-white rounded-2xl shadow-md p-6">
            <h2 class="text-lg font-bold text-text-main mb-4 flex items-center gap-2">
                <span class="material-symbols-outlined text-primary">bolt</span>
                Thao Tác Nhanh
            </h2>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                <a href="AdminCongThucServlet?status=pending" 
                   class="p-4 border-2 border-border-color rounded-xl hover:border-primary hover:bg-primary/5 transition-all text-center group">
                    <span class="material-symbols-outlined text-4xl text-text-secondary group-hover:text-primary transition-colors mb-2 block">pending_actions</span>
                    <p class="font-semibold text-text-main text-sm">Duyệt Món Ăn</p>
                </a>
                <a href="AdminUserServlet" 
                   class="p-4 border-2 border-border-color rounded-xl hover:border-primary hover:bg-primary/5 transition-all text-center group">
                    <span class="material-symbols-outlined text-4xl text-text-secondary group-hover:text-primary transition-colors mb-2 block">manage_accounts</span>
                    <p class="font-semibold text-text-main text-sm">Quản Lý User</p>
                </a>
                <a href="AdminDanhMucServlet" 
                   class="p-4 border-2 border-border-color rounded-xl hover:border-primary hover:bg-primary/5 transition-all text-center group">
                    <span class="material-symbols-outlined text-4xl text-text-secondary group-hover:text-primary transition-colors mb-2 block">add_box</span>
                    <p class="font-semibold text-text-main text-sm">Thêm Danh Mục</p>
                </a>
                <a href="HomeServlet" 
                   class="p-4 border-2 border-border-color rounded-xl hover:border-primary hover:bg-primary/5 transition-all text-center group">
                    <span class="material-symbols-outlined text-4xl text-text-secondary group-hover:text-primary transition-colors mb-2 block">home</span>
                    <p class="font-semibold text-text-main text-sm">Về Trang Chủ</p>
                </a>
            </div>
        </div>
    </main>
</body>
</html>