<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.*" %>
<%@ page import="java.util.*" %>
<%
    user currentUser = (user) session.getAttribute("admin_user");
    Boolean isAdmin = (Boolean) session.getAttribute("admin_isAdmin");
    if (currentUser == null || isAdmin == null || !isAdmin) {
        response.sendRedirect("LoginServlet");
        return;
    }
    
    @SuppressWarnings("unchecked")
    List<danhmuc> categoryList = (List<danhmuc>) request.getAttribute("categoryList");
    if (categoryList == null) categoryList = new ArrayList<>();
    
    String successMsg = (String) request.getAttribute("success");
    String errorMsg = (String) request.getAttribute("error");
    String searchKeyword = (String) request.getAttribute("searchKeyword");
    if (searchKeyword == null) searchKeyword = "";
    
    String action = request.getParameter("action");
    danhmuc editCategory = (danhmuc) request.getAttribute("editCategory");
%>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Danh Mục - Admin</title>
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
                        <h1 class="text-xl font-bold text-text-main">Quản Lý Danh Mục</h1>
                        <p class="text-xs text-text-secondary">Thêm, sửa, xóa danh mục món ăn</p>
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
                   class="px-6 py-3 text-sm font-medium text-text-secondary hover:text-primary transition-colors">
                    <span class="flex items-center gap-2">
                        <span class="material-symbols-outlined text-lg">restaurant_menu</span>
                        Món Ăn
                    </span>
                </a>
                <a href="AdminDanhMucServlet" 
                   class="px-6 py-3 text-sm font-semibold border-b-2 border-primary text-primary">
                    <span class="flex items-center gap-2">
                        <span class="material-symbols-outlined text-lg">category</span>
                        Danh Mục
                    </span>
                </a>
            </div>
        </div>
    </nav>
	
    <!-- Main Content -->
    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
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
        
                    <div class="lg:col-span-2 mb-6">
                <form action="AdminDanhMucServlet" method="get" class="flex gap-3">
                    <input type="hidden" name="action" value="search">
                    <div class="flex-1 relative">
                        <input type="text" 
                               name="keyword" 
                               value="<%= searchKeyword %>"
                               placeholder="Tìm kiếm theo mã hoặc tên danh mục..."
                               class="w-full px-4 py-3 pl-12 border border-border-color rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-all">
                        <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-text-secondary">search</span>
                    </div>
                    <button type="submit" 
                            class="px-6 py-3 bg-primary hover:bg-primary/90 text-white rounded-lg font-medium transition-colors flex items-center gap-2">
                        <span class="material-symbols-outlined">search</span>
                        Tìm kiếm
                    </button>
                    <% if (!searchKeyword.isEmpty()) { %>
                    <a href="AdminDanhMucServlet" 
                       class="px-6 py-3 bg-gray-200 hover:bg-gray-300 text-text-main rounded-lg font-medium transition-colors flex items-center gap-2">
                        <span class="material-symbols-outlined">close</span>
                        Xóa lọc
                    </a>
                    <% } %>
                </form>
            </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            <!-- Add/Edit Form -->
            <div class="lg:col-span-1">
                <div class="bg-white rounded-2xl shadow-md overflow-hidden sticky top-24">
                    <div class="px-6 py-4 border-b border-border-color bg-gradient-to-r from-primary/5 to-transparent">
                        <h2 class="text-lg font-bold text-text-main flex items-center gap-2">
                            <span class="material-symbols-outlined text-primary">
                                <%= editCategory != null ? "edit" : "add_circle" %>
                            </span>
                            <%= editCategory != null ? "Chỉnh Sửa Danh Mục" : "Thêm Danh Mục Mới" %>
                        </h2>
                    </div>
                    
                    <form action="AdminDanhMucServlet" method="post" enctype="multipart/form-data" class="p-6 space-y-4">
                        <% if (editCategory != null) { %>
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="categoryId" value="<%= editCategory.getCategoryId() %>">
                        <% } else { %>
                        <input type="hidden" name="action" value="add">
                        <% } %>
                        
                        <div>
                            <label class="block text-sm font-medium text-text-main mb-2">
                                Tên Danh Mục <span class="text-red-500">*</span>
                            </label>
                            <input type="text" 
                                   name="categoryName" 
                                   value="<%= editCategory != null ? editCategory.getCategoryName() : "" %>"
                                   class="w-full px-4 py-2 border border-border-color rounded-lg focus:border-primary focus:ring-1 focus:ring-primary outline-none"
                                   placeholder="Ví dụ: Món Chay" 
                                   required>
                        </div>
                        
                        <div>
                            <label class="block text-sm font-medium text-text-main mb-2">
                                Mô Tả
                            </label>
                            <textarea name="description" 
                                      rows="3"
                                      class="w-full px-4 py-2 border border-border-color rounded-lg focus:border-primary focus:ring-1 focus:ring-primary outline-none"
                                      placeholder="Mô tả ngắn về danh mục"><%= editCategory != null && editCategory.getDescription() != null ? editCategory.getDescription() : "" %></textarea>
                        </div>
                        
                        <!-- Upload Ảnh -->
                        <div>
                            <label class="block text-sm font-medium text-text-main mb-2">
                                Ảnh Danh Mục <span class="text-red-500">*</span>
                            </label>

                            <% if (editCategory != null && editCategory.getImageUrl() != null) { %>
                            <!-- Hiển thị ảnh hiện tại -->
                            <div class="mb-3">
                                <img src="<%= request.getContextPath() %>/<%= editCategory.getImageUrl() %>"
                                     alt="<%= editCategory.getCategoryName() %>"
                                     class="w-full h-32 object-cover rounded-lg border border-border-color"/>
                                <p class="text-xs text-text-secondary mt-1">Ảnh hiện tại</p>
                            </div>
                            <% } %>
                            
                            <input type="file" 
                                   name="categoryImage"
                                   accept="image/*" 
                                   <%= editCategory == null ? "required" : "" %>
                                   class="w-full px-4 py-2 border border-border-color rounded-lg focus:border-primary focus:ring-1 focus:ring-primary outline-none file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:bg-primary/10 file:text-primary hover:file:bg-primary/20 file:font-medium cursor-pointer"
                                   onchange="previewImage(event)">
                            
                            <% if (editCategory != null) { %>
                            <p class="text-xs text-text-secondary mt-1">Để trống nếu không muốn đổi ảnh</p>
                            <% } %>

                            <!-- Preview -->
                            <div id="imagePreview" class="mt-3 hidden">
                                <img id="preview"
                                     src=""
                                     alt="Preview"
                                     class="w-full h-32 object-cover rounded-lg border border-border-color"/>
                                <p class="text-xs text-text-secondary mt-1">Xem trước ảnh mới</p>
                            </div>
                        </div>

                        <!-- Buttons -->
                        <div class="flex gap-2 pt-2">
                            <button type="submit"
                                    class="flex-1 px-4 py-3 bg-primary hover:bg-[#d5701a] text-white rounded-lg font-semibold transition-colors flex items-center justify-center gap-2">
                                <span class="material-symbols-outlined">
                                    <%= editCategory != null ? "save" : "add" %>
                                </span>
                                <%= editCategory != null ? "Cập Nhật" : "Thêm Mới" %>
                            </button>

                            <% if (editCategory != null) { %>
                            <a href="AdminDanhMucServlet"
                               class="px-4 py-3 bg-gray-200 hover:bg-gray-300 text-text-main rounded-lg font-semibold transition-colors flex items-center justify-center">
                                <span class="material-symbols-outlined">close</span>
                            </a>
                            <% } %>
                        </div>
                    </form>
                </div>
            </div>

            <!-- ✅ MỚI: Search Form -->


            <!-- Category List -->
            <div class="lg:col-span-2">
                <div class="bg-white rounded-2xl shadow-md overflow-hidden">
                    <div class="px-6 py-4 border-b border-border-color bg-gradient-to-r from-primary/5 to-transparent">
                        <h2 class="text-lg font-bold text-text-main flex items-center gap-2">
                            <span class="material-symbols-outlined text-primary">list</span>
                            Danh Sách Danh Mục (<%= categoryList.size() %>)
                            <% if (!searchKeyword.isEmpty()) { %>
                            <span class="text-sm font-normal text-text-secondary">- Kết quả tìm kiếm cho: "<%= searchKeyword %>"</span>
                            <% } %>
                        </h2>
                    </div>

                    <div class="p-6">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <% for (danhmuc category : categoryList) { 
                                danhmucdao dmDao = new danhmucdao();
                                int recipeCount = dmDao.countRecipesByCategory(category.getCategoryId());
                            %>
                            <div class="border-2 border-border-color rounded-xl p-4 hover:border-primary hover:shadow-md transition-all">
                                <!-- Category Image - ✅ SỬA LỖI TẠI ĐÂY -->
                                <% if (category.getImageUrl() != null && !category.getImageUrl().isEmpty()) { %>
                                <img src="<%= request.getContextPath() %>/<%= category.getImageUrl() %>" 
                                     alt="<%= category.getCategoryName() %>"
                                     class="w-full h-32 object-cover rounded-lg mb-3">
                                <% } else { %>
                                <div class="w-full h-32 bg-primary/10 rounded-lg mb-3 flex items-center justify-center">
                                    <span class="material-symbols-outlined text-6xl text-primary opacity-30">restaurant</span>
                                </div>
                                <% } %>
                                
                                <h3 class="text-lg font-bold text-text-main mb-1"><%= category.getCategoryName() %></h3>
                                
                                <% if (category.getDescription() != null && !category.getDescription().isEmpty()) { %>
                                <p class="text-sm text-text-secondary mb-3 line-clamp-2"><%= category.getDescription() %></p>
                                <% } %>
                                
                                <div class="flex items-center justify-between">
                                    <span class="text-sm text-text-secondary flex items-center gap-1">
                                        <span class="material-symbols-outlined text-base">restaurant_menu</span>
                                        <%= recipeCount %> món
                                    </span>
                                    
                                    <div class="flex gap-2">
                                        <a href="AdminDanhMucServlet?action=edit&categoryId=<%= category.getCategoryId() %>" 
                                           class="p-2 bg-blue-500 hover:bg-blue-600 text-white rounded-lg transition-colors"
                                           title="Chỉnh sửa">
                                            <span class="material-symbols-outlined text-base">edit</span>
                                        </a>
                                        
                                        <% if (recipeCount == 0) { %>
                                        <button onclick="confirmDelete(<%= category.getCategoryId() %>, '<%= category.getCategoryName() %>')" 
                                                class="p-2 bg-red-500 hover:bg-red-600 text-white rounded-lg transition-colors"
                                                title="Xóa danh mục">
                                            <span class="material-symbols-outlined text-base">delete</span>
                                        </button>
                                        <% } else { %>
                                        <button disabled 
                                                class="p-2 bg-gray-300 text-gray-500 rounded-lg cursor-not-allowed opacity-50"
                                                title="Không thể xóa - còn món ăn">
                                            <span class="material-symbols-outlined text-base">block</span>
                                        </button>
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                            <% } %>
                            
                            <% if (categoryList.isEmpty()) { %>
                            <div class="col-span-full text-center py-12">
                                <span class="material-symbols-outlined text-8xl text-text-secondary opacity-20 block mb-4">category</span>
                                <p class="text-lg text-text-secondary">Chưa có danh mục nào</p>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script>
        function confirmDelete(categoryId, categoryName) {
            if (confirm('Bạn có chắc chắn muốn xóa danh mục "' + categoryName + '"?')) {
                window.location.href = 'AdminDanhMucServlet?action=delete&categoryId=' + categoryId;
            }
        }
        
        function previewImage(event) {
            const file = event.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('preview').src = e.target.result;
                    document.getElementById('imagePreview').classList.remove('hidden');
                }
                reader.readAsDataURL(file);
            }
        }
    </script>
</body>
</html>