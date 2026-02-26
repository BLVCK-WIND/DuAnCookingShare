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
    List<congthuc> recipeList = (List<congthuc>) request.getAttribute("recipeList");
    if (recipeList == null) recipeList = new ArrayList<>();
    
    String currentFilter = (String) request.getAttribute("currentFilter");
    if (currentFilter == null) currentFilter = "all";
    
    // Lấy số đếm
    Integer totalCount = (Integer) request.getAttribute("totalCount");
    Integer pendingCount = (Integer) request.getAttribute("pendingCount");
    Integer approvedCount = (Integer) request.getAttribute("approvedCount");
    Integer rejectedCount = (Integer) request.getAttribute("rejectedCount");
    
    if (totalCount == null) totalCount = 0;
    if (pendingCount == null) pendingCount = 0;
    if (approvedCount == null) approvedCount = 0;
    if (rejectedCount == null) rejectedCount = 0;
    
    String successMsg = (String) request.getAttribute("success");
    String errorMsg = (String) request.getAttribute("error");
    
    // ✅ MỚI: Biến cho search và category filter
    @SuppressWarnings("unchecked")
    List<danhmuc> categories = (List<danhmuc>) request.getAttribute("categories");
    if (categories == null) categories = new ArrayList<>();
    
    String searchKeyword = (String) request.getAttribute("searchKeyword");
    if (searchKeyword == null) searchKeyword = "";
    
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    if (selectedCategory == null) selectedCategory = "";
%>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Món Ăn - Admin</title>
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
                        <h1 class="text-xl font-bold text-text-main">Quản Lý Món Ăn</h1>
                        <p class="text-xs text-text-secondary">Duyệt và quản lý các công thức</p>
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
                   class="px-6 py-3 text-sm font-medium text-text-secondary hover:text-primary transition-colors">
                    <span class="flex items-center gap-2">
                        <span class="material-symbols-outlined text-lg">group</span>
                        Người Dùng
                    </span>
                </a>
                <a href="AdminCongThucServlet" 
                   class="px-6 py-3 text-sm font-semibold border-b-2 border-primary text-primary">
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

        <!-- ✅ MỚI: Search and Filter Form -->
        <div class="bg-white rounded-2xl shadow-md overflow-hidden mb-6 p-6">
            <form action="AdminCongThucServlet" method="get" class="space-y-4">
                <input type="hidden" name="action" value="search">
                <input type="hidden" name="status" value="<%= currentFilter %>">
                
                <div class="flex flex-col lg:flex-row gap-4">
                    <!-- Search Input -->
                    <div class="flex-1 relative">
                        <label class="block text-sm font-medium text-text-main mb-2">Tìm kiếm</label>
                        <input type="text" 
                               name="keyword" 
                               value="<%= searchKeyword %>"
                               placeholder="Tìm theo mã, tên công thức, mã hoặc tên danh mục..."
                               class="w-full px-4 py-3 pl-12 border border-border-color rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-all">
                        <span class="material-symbols-outlined absolute left-4 bottom-3.5 text-text-secondary">search</span>
                    </div>
                    
                    <!-- Category Filter -->
                    <div class="w-full lg:w-64">
                        <label class="block text-sm font-medium text-text-main mb-2">Danh mục</label>
                        <select name="category" 
                                class="w-full px-4 py-3 border border-border-color rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-all">
                            <option value="all" <%= "".equals(selectedCategory) || "all".equals(selectedCategory) ? "selected" : "" %>>Tất cả danh mục</option>
                            <% for (danhmuc cat : categories) { %>
                            <option value="<%= cat.getCategoryId() %>" <%= String.valueOf(cat.getCategoryId()).equals(selectedCategory) ? "selected" : "" %>>
                                <%= cat.getCategoryName() %>
                            </option>
                            <% } %>
                        </select>
                    </div>
                    
                    <!-- Action Buttons -->
                    <div class="flex gap-2 items-end">
                        <button type="submit" 
                                class="px-6 py-3 bg-primary hover:bg-primary/90 text-white rounded-lg font-medium transition-colors flex items-center gap-2 whitespace-nowrap">
                            <span class="material-symbols-outlined">search</span>
                            Tìm kiếm
                        </button>
                        <% if (!searchKeyword.isEmpty() || !selectedCategory.isEmpty() && !"all".equals(selectedCategory)) { %>
                        <a href="AdminCongThucServlet?status=<%= currentFilter %>" 
                           class="px-6 py-3 bg-gray-200 hover:bg-gray-300 text-text-main rounded-lg font-medium transition-colors flex items-center gap-2 whitespace-nowrap">
                            <span class="material-symbols-outlined">close</span>
                            Xóa lọc
                        </a>
                        <% } %>
                    </div>
                </div>
            </form>
        </div>

        <!-- Filter Tabs với số đếm -->
        <div class="bg-white rounded-2xl shadow-md overflow-hidden mb-6">
            <div class="flex border-b border-border-color">
                <!-- Tab Tất Cả -->
                <a href="AdminCongThucServlet?status=all" 
                   class="flex-1 px-6 py-4 text-center text-sm font-medium <%= currentFilter.equals("all") ? "bg-primary/10 text-primary border-b-2 border-primary" : "text-text-secondary hover:bg-primary/5" %> transition-colors">
                    <span class="flex items-center justify-center gap-2">
                        <span class="material-symbols-outlined text-lg">list</span>
                        <span>Tất Cả</span>
                        <span class="inline-flex items-center justify-center w-6 h-6 text-xs font-bold rounded-full <%= currentFilter.equals("all") ? "bg-primary text-white" : "bg-gray-200 text-gray-600" %>">
                            <%= totalCount %>
                        </span>
                    </span>
                </a>
                
                <!-- Tab Chờ Duyệt -->
                <a href="AdminCongThucServlet?status=pending" 
                   class="flex-1 px-6 py-4 text-center text-sm font-medium <%= currentFilter.equals("pending") ? "bg-orange-100 text-orange-600 border-b-2 border-orange-600" : "text-text-secondary hover:bg-orange-50" %> transition-colors">
                    <span class="flex items-center justify-center gap-2">
                        <span class="material-symbols-outlined text-lg">pending</span>
                        <span>Chờ Duyệt</span>
                        <% if (pendingCount > 0) { %>
                        <span class="inline-flex items-center justify-center w-6 h-6 text-xs font-bold rounded-full <%= currentFilter.equals("pending") ? "bg-orange-600 text-white" : "bg-orange-200 text-orange-700" %> animate-pulse">
                            <%= pendingCount %>
                        </span>
                        <% } %>
                    </span>
                </a>
                
                <!-- Tab Đã Duyệt -->
                <a href="AdminCongThucServlet?status=approved" 
                   class="flex-1 px-6 py-4 text-center text-sm font-medium <%= currentFilter.equals("approved") ? "bg-green-100 text-green-600 border-b-2 border-green-600" : "text-text-secondary hover:bg-green-50" %> transition-colors">
                    <span class="flex items-center justify-center gap-2">
                        <span class="material-symbols-outlined text-lg">check_circle</span>
                        <span>Đã Duyệt</span>
                        <span class="inline-flex items-center justify-center w-6 h-6 text-xs font-bold rounded-full <%= currentFilter.equals("approved") ? "bg-green-600 text-white" : "bg-gray-200 text-gray-600" %>">
                            <%= approvedCount %>
                        </span>
                    </span>
                </a>
                
                <!-- Tab Đã Từ Chối -->
                <a href="AdminCongThucServlet?status=rejected" 
                   class="flex-1 px-6 py-4 text-center text-sm font-medium <%= currentFilter.equals("rejected") ? "bg-red-100 text-red-600 border-b-2 border-red-600" : "text-text-secondary hover:bg-red-50" %> transition-colors">
                    <span class="flex items-center justify-center gap-2">
                        <span class="material-symbols-outlined text-lg">cancel</span>
                        <span>Đã Từ Chối</span>
                        <span class="inline-flex items-center justify-center w-6 h-6 text-xs font-bold rounded-full <%= currentFilter.equals("rejected") ? "bg-red-600 text-white" : "bg-gray-200 text-gray-600" %>">
                            <%= rejectedCount %>
                        </span>
                    </span>
                </a>
            </div>
        </div>

        <!-- ✅ MỚI: Hiển thị kết quả tìm kiếm -->
        <% if (!searchKeyword.isEmpty() || (!selectedCategory.isEmpty() && !"all".equals(selectedCategory))) { %>
        <div class="mb-4 p-4 bg-blue-50 border border-blue-200 rounded-lg">
            <p class="text-sm text-blue-800">
                <span class="font-semibold">Kết quả tìm kiếm:</span>
                <% if (!searchKeyword.isEmpty()) { %>
                    Từ khóa "<strong><%= searchKeyword %></strong>"
                <% } %>
                <% if (!selectedCategory.isEmpty() && !"all".equals(selectedCategory)) { %>
                    <% 
                        String categoryName = "";
                        for (danhmuc cat : categories) {
                            if (String.valueOf(cat.getCategoryId()).equals(selectedCategory)) {
                                categoryName = cat.getCategoryName();
                                break;
                            }
                        }
                    %>
                    <% if (!searchKeyword.isEmpty()) { %>và<% } %>
                    Danh mục "<strong><%= categoryName %></strong>"
                <% } %>
                - Tìm thấy <strong><%= recipeList.size() %></strong> công thức
            </p>
        </div>
        <% } %>

        <!-- Recipe Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <% 
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            for (congthuc recipe : recipeList) { 
            %>
            <div class="bg-white rounded-2xl shadow-md overflow-hidden hover:shadow-xl transition-shadow">
                <!-- Recipe Image -->
                <div class="relative h-48 overflow-hidden">
                    <img src="<%= recipe.getImageUrl() %>" 
                         alt="<%= recipe.getTitle() %>"
                         class="w-full h-full object-cover">
                    
                    <!-- Status Badge -->
                    <div class="absolute top-3 right-3">
                        <% if ("pending".equals(recipe.getStatus())) { %>
                        <span class="px-3 py-1 bg-orange-500 text-white text-xs font-semibold rounded-full flex items-center gap-1">
                            <span class="material-symbols-outlined text-sm">schedule</span>
                            Chờ duyệt
                        </span>
                        <% } else if ("approved".equals(recipe.getStatus())) { %>
                        <span class="px-3 py-1 bg-green-500 text-white text-xs font-semibold rounded-full flex items-center gap-1">
                            <span class="material-symbols-outlined text-sm">check_circle</span>
                            Đã duyệt
                        </span>
                        <% } else if ("rejected".equals(recipe.getStatus())) { %>
                        <span class="px-3 py-1 bg-red-500 text-white text-xs font-semibold rounded-full flex items-center gap-1">
                            <span class="material-symbols-outlined text-sm">cancel</span>
                            Từ chối
                        </span>
                        <% } %>
                    </div>
                </div>

                <!-- Recipe Info -->
                <div class="p-5">
                    <h3 class="text-lg font-bold text-text-main mb-2 truncate"><%= recipe.getTitle() %></h3>
                    
                    <p class="text-sm text-text-secondary mb-3 line-clamp-2">
                        <%= recipe.getDescription() != null ? recipe.getDescription() : "Không có mô tả" %>
                    </p>
                    
                    <div class="flex items-center gap-4 text-sm text-text-secondary mb-3">
                        <span class="flex items-center gap-1">
                            <span class="material-symbols-outlined text-base">person</span>
                            <%= recipe.getAuthorName() %>
                        </span>
                        <span class="flex items-center gap-1">
                            <span class="material-symbols-outlined text-base">calendar_today</span>
                            <%= recipe.getCreatedAt() != null ? sdf.format(recipe.getCreatedAt()) : "N/A" %>
                        </span>
                    </div>

                    <div class="flex items-center gap-4 text-xs text-text-secondary mb-4">
                        <span class="flex items-center gap-1">
                            <span class="material-symbols-outlined text-sm">visibility</span>
                            <%= recipe.getViewCount() %>
                        </span>
                        <span class="flex items-center gap-1">
                            <span class="material-symbols-outlined text-sm">favorite</span>
                            <%= recipe.getTotalFavorites() %>
                        </span>
                    </div>

                    
                    <!-- Actions -->
                    <div class="flex flex-col gap-2">
                        <!-- Hàng 1: Xem và Xóa -->
                        <div class="flex gap-2">
                            <a href="AdminCongThucServlet?action=view&recipeId=<%= recipe.getRecipeId() %>" 
                               class="flex-1 px-4 py-2.5 bg-blue-500 hover:bg-blue-600 text-white rounded-lg text-sm font-medium text-center transition-colors">
                                <span class="flex items-center justify-center gap-1.5">
                                    <span class="material-symbols-outlined text-base">visibility</span>
                                    Xem chi tiết
                                </span>
                            </a>
                            
                            <button onclick="confirmDelete(<%= recipe.getRecipeId() %>, '<%= recipe.getTitle().replace("'", "\\'") %>', '<%= currentFilter %>')" 
                                    class="px-4 py-2.5 bg-red-500 hover:bg-red-600 text-white rounded-lg text-sm font-medium transition-colors">
                                <span class="flex items-center gap-1">
                                    <span class="material-symbols-outlined text-base">delete</span>
                                </span>
                            </button>
                        </div>
                        
                        <!-- Hàng 2: Duyệt và Từ chối (chỉ hiện khi pending) -->
                        <% if ("pending".equals(recipe.getStatus())) { %>
                        <div class="flex gap-2">
                            <a href="AdminCongThucServlet?action=approve&recipeId=<%= recipe.getRecipeId() %>" 
                               onclick="return confirm('Duyệt món ăn này?')"
                               class="flex-1 px-4 py-2.5 bg-green-500 hover:bg-green-600 text-white rounded-lg text-sm font-medium text-center transition-colors">
                                <span class="flex items-center justify-center gap-1.5">
                                    <span class="material-symbols-outlined text-base">check_circle</span>
                                    Duyệt
                                </span>
                            </a>
                            
                            <button onclick="openRejectModal(<%= recipe.getRecipeId() %>, '<%= recipe.getTitle().replace("'", "\\'") %>')" 
                                    class="flex-1 px-4 py-2.5 bg-orange-500 hover:bg-orange-600 text-white rounded-lg text-sm font-medium transition-colors">
                                <span class="flex items-center justify-center gap-1.5">
                                    <span class="material-symbols-outlined text-base">cancel</span>
                                    Từ chối
                                </span>
                            </button>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
            <% } %>
            
            <% if (recipeList.isEmpty()) { %>
            <div class="col-span-full">
                <div class="bg-white rounded-2xl shadow-md p-12 text-center">
                    <span class="material-symbols-outlined text-8xl text-text-secondary opacity-20 block mb-4">restaurant_menu</span>
                    <p class="text-lg text-text-secondary">
                        <% if (currentFilter.equals("pending")) { %>
                            🎉 Không có món ăn nào chờ duyệt!
                        <% } else if (currentFilter.equals("approved")) { %>
                            Chưa có món ăn nào được duyệt
                        <% } else if (currentFilter.equals("rejected")) { %>
                            Chưa có món ăn nào bị từ chối
                        <% } else { %>
                            Chưa có món ăn nào
                        <% } %>
                    </p>
                </div>
            </div>
            <% } %>
        </div>
    </main>

    <!-- Modal từ chối -->
    <div id="rejectModal" class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-50">
        <div class="bg-white rounded-2xl shadow-2xl max-w-md w-full mx-4">
            <div class="p-6 border-b border-gray-200">
                <div class="flex items-center justify-between">
                    <h3 class="text-xl font-bold text-text-main flex items-center gap-2">
                        <span class="material-symbols-outlined text-orange-500">warning</span>
                        Từ chối món ăn
                    </h3>
                    <button onclick="closeRejectModal()" class="text-gray-400 hover:text-gray-600">
                        <span class="material-symbols-outlined">close</span>
                    </button>
                </div>
            </div>
            
            <form id="rejectForm" action="AdminCongThucServlet" method="post">
                <input type="hidden" name="action" value="reject">
                <input type="hidden" name="recipeId" id="rejectRecipeId">
                
                <div class="p-6">
                    <p class="text-sm text-text-secondary mb-2">Món ăn: <strong id="rejectRecipeTitle"></strong></p>
                    
                    <label class="block text-sm font-medium text-text-main mb-2">
                        Lý do từ chối <span class="text-red-500">*</span>
                    </label>
                    <textarea name="reason" 
                              id="rejectReason"
                              rows="4" 
                              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-transparent resize-none"
                              placeholder="Vui lòng nhập lý do từ chối để người dùng có thể chỉnh sửa..."
                              required></textarea>
                    
                    <div class="mt-4 p-4 bg-orange-50 rounded-lg">
                        <p class="text-sm text-orange-800 flex items-start gap-2">
                            <span class="material-symbols-outlined text-sm mt-0.5">info</span>
                            <span>Lý do này sẽ được gửi đến người dùng để họ có thể chỉnh sửa và gửi lại món ăn.</span>
                        </p>
                    </div>
                </div>
                
                <div class="p-6 border-t border-gray-200 flex gap-3">
                    <button type="button" 
                            onclick="closeRejectModal()" 
                            class="flex-1 px-4 py-3 bg-gray-100 hover:bg-gray-200 text-gray-700 rounded-lg font-medium transition-colors">
                        Hủy
                    </button>
                    <button type="submit" 
                            class="flex-1 px-4 py-3 bg-orange-500 hover:bg-orange-600 text-white rounded-lg font-medium transition-colors">
                        Xác nhận từ chối
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function confirmDelete(recipeId, title, currentStatus) {
            if (confirm('Bạn có chắc chắn muốn xóa món ăn "' + title + '"?\nMọi dữ liệu liên quan sẽ bị xóa.')) {
                window.location.href = 'AdminCongThucServlet?action=delete&recipeId=' + recipeId + '&currentStatus=' + currentStatus;
            }
        }
        
        function openRejectModal(recipeId, title) {
            document.getElementById('rejectRecipeId').value = recipeId;
            document.getElementById('rejectRecipeTitle').textContent = title;
            document.getElementById('rejectReason').value = '';
            document.getElementById('rejectModal').classList.remove('hidden');
            document.getElementById('rejectModal').classList.add('flex');
        }
        
        function closeRejectModal() {
            document.getElementById('rejectModal').classList.add('hidden');
            document.getElementById('rejectModal').classList.remove('flex');
        }
        
        // Close modal when clicking outside
        document.getElementById('rejectModal')?.addEventListener('click', function(e) {
            if (e.target === this) {
                closeRejectModal();
            }
        });
    </script>
</body>
</html>
