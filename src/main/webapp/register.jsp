<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký - CookingShare</title>
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
               href="<%= request.getContextPath() %>/LoginServlet">
                <span class="truncate">Đăng nhập</span>
            </a>
        </div>
    </header>

    <!-- Main Content Area -->
    <main class="flex-1 flex items-center justify-center p-4 md:p-8">
        <div class="w-full max-w-[1000px] bg-white dark:bg-[#2a1e16] rounded-2xl shadow-xl overflow-hidden flex flex-col md:flex-row min-h-[600px]">
            <!-- Left Side: Image -->
            <div class="hidden md:flex w-1/2 bg-cover bg-center relative"
                 style="background-image: url('https://images.unsplash.com/photo-1466637574441-749b8f19452f?w=800&q=80');">
                <div class="absolute inset-0 bg-black/20"></div>
                <div class="absolute bottom-0 left-0 p-8 text-white z-10">
                    <h3 class="text-3xl font-bold mb-2">Bắt đầu hành trình</h3>
                    <p class="text-lg opacity-90">
                        Tham gia cộng đồng ẩm thực lớn nhất Việt Nam ngay hôm nay.
                    </p>
                </div>
            </div>

            <!-- Right Side: Register Form -->
            <div class="w-full md:w-1/2 p-8 md:p-12 flex flex-col justify-center">
                <!-- Header Section -->
                <div class="mb-6">
                    <h1 class="text-text-main text-3xl md:text-4xl font-bold leading-tight mb-2">
                        Đăng Ký
                    </h1>
                    <p class="text-text-secondary text-sm font-normal">
                        Tạo tài khoản để bắt đầu chia sẻ công thức của bạn.
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

                <!-- Form -->
                <form action="<%= request.getContextPath() %>/RegisterServlet" method="post" id="registerForm" class="flex flex-col gap-4">
                    <!-- Full Name Field -->
                    <label class="flex flex-col gap-1.5">
                        <span class="text-text-main text-sm font-medium">Họ và tên <span class="text-red-500">*</span></span>
                        <div class="relative group">
                            <input class="form-input flex w-full rounded-lg text-text-main border border-border-color bg-background-light focus:border-primary focus:ring-1 focus:ring-primary h-12 px-4 text-base placeholder:text-text-secondary/70 transition-all outline-none"
                                   placeholder="Nguyễn Văn A"
                                   type="text"
                                   name="fullName"
                                   value="<%= request.getAttribute("fullName") != null ? request.getAttribute("fullName") : "" %>"
                                   required>
                            <span class="material-symbols-outlined absolute right-4 top-1/2 -translate-y-1/2 text-text-secondary pointer-events-none text-[20px]">
                                badge
                            </span>
                        </div>
                    </label>

                    <!-- Email Field -->
                    <label class="flex flex-col gap-1.5">
                        <span class="text-text-main text-sm font-medium">Email <span class="text-red-500">*</span></span>
                        <div class="relative group">
                            <input class="form-input flex w-full rounded-lg text-text-main border border-border-color bg-background-light focus:border-primary focus:ring-1 focus:ring-primary h-12 px-4 text-base placeholder:text-text-secondary/70 transition-all outline-none"
                                   placeholder="example@gmail.com"
                                   type="email"
                                   name="email"
                                   value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>"
                                   required>
                            <span class="material-symbols-outlined absolute right-4 top-1/2 -translate-y-1/2 text-text-secondary pointer-events-none text-[20px]">
                                mail
                            </span>
                        </div>
                    </label>

                    <!-- Username Field -->
                    <label class="flex flex-col gap-1.5">
                        <span class="text-text-main text-sm font-medium">Tên đăng nhập <span class="text-red-500">*</span></span>
                        <div class="relative group">
                            <input class="form-input flex w-full rounded-lg text-text-main border border-border-color bg-background-light focus:border-primary focus:ring-1 focus:ring-primary h-12 px-4 text-base placeholder:text-text-secondary/70 transition-all outline-none"
                                   placeholder="username"
                                   type="text"
                                   name="username"
                                   pattern="[a-zA-Z0-9_]{4,20}"
                                   title="4-20 ký tự, chỉ chữ, số và dấu gạch dưới"
                                   value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>"
                                   required>
                            <span class="material-symbols-outlined absolute right-4 top-1/2 -translate-y-1/2 text-text-secondary pointer-events-none text-[20px]">
                                person
                            </span>
                        </div>
                        <p class="text-xs text-text-secondary">4-20 ký tự, chỉ chữ, số và dấu gạch dưới</p>
                    </label>

                    <!-- Password Field -->
                    <label class="flex flex-col gap-1.5">
                        <span class="text-text-main text-sm font-medium">Mật khẩu <span class="text-red-500">*</span></span>
                        <div class="relative group">
                            <input class="form-input flex w-full rounded-lg text-text-main border border-border-color bg-background-light focus:border-primary focus:ring-1 focus:ring-primary h-12 px-4 pr-12 text-base placeholder:text-text-secondary/70 transition-all outline-none"
                                   placeholder="••••••••"
                                   type="password"
                                   name="password"
                                   id="password"
                                   minlength="6"
                                   required>
                            <button class="absolute right-0 top-0 h-full px-4 text-text-secondary hover:text-primary transition-colors flex items-center justify-center"
                                    type="button"
                                    onclick="togglePassword('password', 'passwordIcon1')">
                                <span class="material-symbols-outlined text-[20px]" id="passwordIcon1">
                                    visibility_off
                                </span>
                            </button>
                        </div>
                        <!-- Password Strength Bar -->
                        <div class="h-1.5 bg-gray-200 rounded-full overflow-hidden">
                            <div id="strengthBar" class="h-full transition-all duration-300" style="width: 0%;"></div>
                        </div>
                        <p id="strengthText" class="text-xs text-text-secondary">Tối thiểu 6 ký tự</p>
                    </label>

                    <!-- Confirm Password Field -->
                    <label class="flex flex-col gap-1.5">
                        <span class="text-text-main text-sm font-medium">Xác nhận mật khẩu <span class="text-red-500">*</span></span>
                        <div class="relative group">
                            <input class="form-input flex w-full rounded-lg text-text-main border border-border-color bg-background-light focus:border-primary focus:ring-1 focus:ring-primary h-12 px-4 pr-12 text-base placeholder:text-text-secondary/70 transition-all outline-none"
                                   placeholder="••••••••"
                                   type="password"
                                   name="confirmPassword"
                                   id="confirmPassword"
                                   minlength="6"
                                   required>
                            <button class="absolute right-0 top-0 h-full px-4 text-text-secondary hover:text-primary transition-colors flex items-center justify-center"
                                    type="button"
                                    onclick="togglePassword('confirmPassword', 'passwordIcon2')">
                                <span class="material-symbols-outlined text-[20px]" id="passwordIcon2">
                                    visibility_off
                                </span>
                            </button>
                        </div>
                        <p id="matchText" class="text-xs"></p>
                    </label>

                    <!-- Register Button -->
                    <button type="submit"
                            class="flex w-full cursor-pointer items-center justify-center rounded-lg h-12 px-6 bg-primary hover:bg-[#d5701a] text-white text-base font-bold shadow-md hover:shadow-lg transition-all transform active:scale-[0.98] mt-2">
                        Đăng Ký
                    </button>

                    <!-- Login Link -->
                    <div class="mt-4 text-center">
                        <p class="text-sm text-text-secondary">
                            Đã có tài khoản?
                            <a class="text-primary font-bold hover:underline" 
                               href="<%= request.getContextPath() %>/LoginServlet">
                                Đăng nhập ngay
                            </a>
                        </p>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <script>
        function togglePassword(inputId, iconId) {
            const input = document.getElementById(inputId);
            const icon = document.getElementById(iconId);
            
            if (input.type === 'password') {
                input.type = 'text';
                icon.textContent = 'visibility';
            } else {
                input.type = 'password';
                icon.textContent = 'visibility_off';
            }
        }

        const password = document.getElementById('password');
        const confirmPassword = document.getElementById('confirmPassword');
        const strengthBar = document.getElementById('strengthBar');
        const strengthText = document.getElementById('strengthText');
        const matchText = document.getElementById('matchText');

        // Check password strength
        password.addEventListener('input', () => {
            const val = password.value;
            const len = val.length;

            if (len === 0) {
                strengthBar.style.width = '0%';
                strengthBar.className = 'h-full transition-all duration-300';
                strengthText.textContent = 'Tối thiểu 6 ký tự';
                strengthText.className = 'text-xs text-text-secondary';
            } else if (len < 6) {
                strengthBar.style.width = '33%';
                strengthBar.className = 'h-full transition-all duration-300 bg-red-500';
                strengthText.textContent = 'Yếu - Cần ít nhất 6 ký tự';
                strengthText.className = 'text-xs text-red-600';
            } else if (len < 10) {
                strengthBar.style.width = '66%';
                strengthBar.className = 'h-full transition-all duration-300 bg-yellow-500';
                strengthText.textContent = 'Trung bình';
                strengthText.className = 'text-xs text-yellow-600';
            } else {
                strengthBar.style.width = '100%';
                strengthBar.className = 'h-full transition-all duration-300 bg-green-500';
                strengthText.textContent = 'Mạnh';
                strengthText.className = 'text-xs text-green-600';
            }

            checkPasswordMatch();
        });

        // Check password match
        confirmPassword.addEventListener('input', checkPasswordMatch);

        function checkPasswordMatch() {
            if (confirmPassword.value === '') {
                matchText.textContent = '';
                return;
            }

            if (password.value === confirmPassword.value) {
                matchText.textContent = '✓ Mật khẩu khớp';
                matchText.className = 'text-xs text-green-600';
            } else {
                matchText.textContent = '✗ Mật khẩu không khớp';
                matchText.className = 'text-xs text-red-600';
            }
        }

        // Validate form before submit
        document.getElementById('registerForm').addEventListener('submit', (e) => {
            if (password.value !== confirmPassword.value) {
                e.preventDefault();
                alert('Mật khẩu xác nhận không khớp!');
                confirmPassword.focus();
            }
        });
    </script>
</body>
</html>