<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - CookingShare</title>
    <link href="https://fonts.googleapis.com" rel="preconnect">
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;700;900&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script>
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        primary: "#ee862b",
                        "background-light": "#fcfaf8",
                        "background-dark": "#221810",
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
<body class="bg-background-light dark:bg-background-dark font-display text-text-main antialiased min-h-screen flex flex-col">
    <!-- Top Navigation -->
    <header class="flex items-center justify-between whitespace-nowrap border-b border-solid border-border-color px-4 py-3 md:px-10 bg-background-light dark:bg-background-dark">
        <a href="<%= request.getContextPath() %>/HomeServlet">
        <div class="flex items-center gap-4 text-text-main">
            <div class="size-8 flex items-center justify-center text-primary">
                <span class="material-symbols-outlined text-3xl">restaurant_menu</span>
            </div>
            <h2 class="text-text-main text-xl font-bold leading-tight tracking-[-0.015em]">
                CookingShare
            </h2>
        </div>
        </a>
        <div class="flex gap-2">
            <a class="flex min-w-[84px] cursor-pointer items-center justify-center overflow-hidden rounded-lg h-10 px-4 bg-primary/10 hover:bg-primary/20 text-primary text-sm font-bold leading-normal tracking-[0.015em] transition-colors"
               href="<%= request.getContextPath() %>/RegisterServlet">
                <span class="truncate">Đăng ký</span>
            </a>
        </div>
    </header>

    <!-- Main Content Area -->
    <main class="flex-1 flex items-center justify-center p-4 md:p-8">
        <div class="w-full max-w-[1000px] bg-white dark:bg-[#2a1e16] rounded-2xl shadow-xl overflow-hidden flex flex-col md:flex-row min-h-[600px]">
            <!-- Left Side: Image -->
            <div class="hidden md:flex w-1/2 bg-cover bg-center relative"
                 style="background-image: url('https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=800&q=80');">
                <div class="absolute inset-0 bg-black/20"></div>
                <div class="absolute bottom-0 left-0 p-8 text-white z-10">
                    <h3 class="text-3xl font-bold mb-2">Nấu ăn là nghệ thuật</h3>
                    <p class="text-lg opacity-90">
                        Chia sẻ niềm đam mê ẩm thực của bạn với cộng đồng.
                    </p>
                </div>
            </div>

            <!-- Right Side: Login Form -->
            <div class="w-full md:w-1/2 p-8 md:p-12 flex flex-col justify-center">
                <!-- Header Section -->
                <div class="mb-8">
                    <h1 class="text-text-main text-3xl md:text-4xl font-bold leading-tight mb-2">
                        Đăng Nhập
                    </h1>
                    <p class="text-text-secondary text-sm font-normal">
                        Chào mừng bạn trở lại với CookingShare! Vui lòng nhập thông tin của bạn.
                    </p>
                </div>

                <!-- Error Message -->
                <% if (request.getAttribute("error") != null) { %>
                    <div class="mb-6 p-4 rounded-lg bg-red-50 border border-red-200 flex items-start gap-3">
                        <span class="material-symbols-outlined text-red-600 text-[20px]">error</span>
                        <p class="text-red-800 text-sm flex-1">
                            <%= request.getAttribute("error") %>
                        </p>
                    </div>
                <% } %>

                <!-- Success Message -->
                <% if (request.getAttribute("success") != null) { %>
                    <div class="mb-6 p-4 rounded-lg bg-green-50 border border-green-200 flex items-start gap-3">
                        <span class="material-symbols-outlined text-green-600 text-[20px]">check_circle</span>
                        <p class="text-green-800 text-sm flex-1">
                            <%= request.getAttribute("success") %>
                        </p>
                    </div>
                <% } %>

                <!-- Form -->
                <form action="<%= request.getContextPath() %>/LoginServlet" method="post" class="flex flex-col gap-5">
                    <input type="hidden" name="loginType" value="user">

                    <!-- Username Field -->
                    <label class="flex flex-col gap-1.5">
                        <span class="text-text-main text-sm font-medium">Tên đăng nhập</span>
                        <div class="relative group">
                            <input class="form-input flex w-full rounded-lg text-text-main border border-border-color bg-background-light focus:border-primary focus:ring-1 focus:ring-primary h-12 px-4 text-base placeholder:text-text-secondary/70 transition-all outline-none"
                                   placeholder="Nhập tên đăng nhập"
                                   type="text"
                                   name="username"
                                   value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>"
                                   required>
                            <span class="material-symbols-outlined absolute right-4 top-1/2 -translate-y-1/2 text-text-secondary pointer-events-none text-[20px]">
                                person
                            </span>
                        </div>
                    </label>

                    <!-- Password Field -->
                    <label class="flex flex-col gap-1.5">
                        <span class="text-text-main text-sm font-medium">Mật khẩu</span>
                        <div class="relative group">
                            <input class="form-input flex w-full rounded-lg text-text-main border border-border-color bg-background-light focus:border-primary focus:ring-1 focus:ring-primary h-12 px-4 pr-12 text-base placeholder:text-text-secondary/70 transition-all outline-none"
                                   placeholder="••••••••"
                                   type="password"
                                   name="password"
                                   id="password"
                                   required>
                            <button class="absolute right-0 top-0 h-full px-4 text-text-secondary hover:text-primary transition-colors flex items-center justify-center"
                                    type="button"
                                    onclick="togglePassword()">
                                <span class="material-symbols-outlined text-[20px]" id="passwordIcon">
                                    visibility_off
                                </span>
                            </button>
                        </div>
                    </label>

                    <!-- Login Button -->
                    <button type="submit"
                            class="flex w-full cursor-pointer items-center justify-center rounded-lg h-12 px-6 bg-primary hover:bg-[#d5701a] text-white text-base font-bold shadow-md hover:shadow-lg transition-all transform active:scale-[0.98]">
                        Đăng Nhập
                    </button>

                    <!-- Register Link -->
                    <div class="mt-4 text-center">
                        <p class="text-sm text-text-secondary">
                            Chưa có tài khoản?
                            <a class="text-primary font-bold hover:underline" 
                               href="<%= request.getContextPath() %>/RegisterServlet">
                                Đăng ký ngay
                            </a>
                        </p>
                    </div>
                </form>

                <!-- Admin Login Link -->
                <div class="mt-6 pt-6 border-t border-border-color text-center">
                    <a href="<%= request.getContextPath() %>/AdminPinCheckServlet"
                       class="text-sm text-text-secondary hover:text-primary transition-colors inline-flex items-center gap-1">
                        <span class="material-symbols-outlined text-[18px]">admin_panel_settings</span>
                        Đăng nhập với quyền Admin
                    </a>
                </div>
            </div>
        </div>
    </main>

    <script>
        function togglePassword() {
            const passwordInput = document.getElementById('password');
            const passwordIcon = document.getElementById('passwordIcon');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                passwordIcon.textContent = 'visibility';
            } else {
                passwordInput.type = 'password';
                passwordIcon.textContent = 'visibility_off';
            }
        }
    </script>
</body>
</html>