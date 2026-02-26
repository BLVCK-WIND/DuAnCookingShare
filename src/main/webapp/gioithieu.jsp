<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html class="light scroll-smooth" lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link
        href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&family=Noto+Sans:wght@400;500;600;700&display=swap"
        rel="stylesheet">

    <!-- Material Icons -->
    <link
        href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
        rel="stylesheet">

    <!-- Tailwind -->
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>

    <script>
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        primary: "#ee862b",
                        "primary-hover": "#d9701a",
                        "background-light": "#FFFBF7",
                        "background-dark": "#1a120b",
                        "surface-light": "#ffffff",
                        "surface-dark": "#2a2018",
                        "text-main-light": "#2d241e",
                        "text-main-dark": "#f3ede7",
                        "text-secondary-light": "#6b5c52",
                        "text-secondary-dark": "#a89688",
                    },
                    fontFamily: {
                        display: ["Be Vietnam Pro", "sans-serif"],
                        body: ["Noto Sans", "sans-serif"],
                    },
                    backgroundImage: {
                        "hero-pattern":
                            "radial-gradient(circle at 50% 0%, rgba(238, 134, 43, 0.15) 0%, rgba(255, 255, 255, 0) 50%)",
                        "dark-hero-pattern":
                            "radial-gradient(circle at 50% 0%, rgba(238, 134, 43, 0.1) 0%, rgba(26, 18, 11, 0) 50%)",
                    },
                },
            },
        };
    </script>

    <style>
        body { font-family: "Noto Sans", sans-serif; }
        h1,h2,h3,h4,h5,h6,.font-display {
            font-family: "Be Vietnam Pro", sans-serif;
        }
        .material-symbols-outlined {
            font-variation-settings: "FILL" 1, "wght" 400, "GRAD" 0, "opsz" 24;
        }
    </style>
</head>

<body class="bg-background-light dark:bg-background-dark
             text-text-main-light dark:text-text-main-dark
             transition-colors duration-200 antialiased">

<div class="relative flex min-h-screen w-full flex-col">

    <!-- HEADER -->
    <jsp:include page="include/header.jsp" />

    <!-- MAIN -->
    <main class="flex-grow">

        <!-- HERO -->
        <section class="relative bg-hero-pattern dark:bg-dark-hero-pattern">
            <div class="max-w-7xl mx-auto px-6 py-24 text-center">
                <span class="inline-block mb-6 px-4 py-1 rounded-full bg-white/80 text-primary font-bold text-sm">
                    Về chúng tôi
                </span>

                <h1 class="font-display text-5xl md:text-7xl font-black mb-6">
                    Kết nối đam mê,<br>
                    <span class="text-primary">chia sẻ hương vị</span>
                </h1>

                <p class="max-w-2xl mx-auto text-lg text-text-secondary-light">
                    CookingShare là nền tảng chia sẻ công thức nấu ăn,
                    nơi mọi người cùng nhau lan tỏa niềm đam mê ẩm thực
                    và học hỏi những giá trị tinh hoa từ cộng đồng.
                </p>
            </div>
        </section>

        <!-- CORE VALUES -->
        <section class="max-w-7xl mx-auto px-6 py-20">
            <div class="grid md:grid-cols-3 gap-8">

                <div class="bg-white dark:bg-surface-dark rounded-2xl p-8 shadow">
                    <span class="material-symbols-outlined text-primary text-4xl mb-4">
                        edit_note
                    </span>
                    <h3 class="font-display text-xl font-bold mb-3">
                        Chia sẻ dễ dàng
                    </h3>
                    <p class="text-text-secondary-light">
                        Đăng tải và quản lý công thức nấu ăn
                        nhanh chóng, trực quan và thuận tiện.
                    </p>
                </div>

                <div class="bg-white dark:bg-surface-dark rounded-2xl p-8 shadow">
                    <span class="material-symbols-outlined text-primary text-4xl mb-4">
                        soup_kitchen
                    </span>
                    <h3 class="font-display text-xl font-bold mb-3">
                        Nguồn cảm hứng
                    </h3>
                    <p class="text-text-secondary-light">
                        Khám phá hàng ngàn món ăn đa dạng,
                        từ truyền thống đến hiện đại.
                    </p>
                </div>

                <div class="bg-white dark:bg-surface-dark rounded-2xl p-8 shadow">
                    <span class="material-symbols-outlined text-primary text-4xl mb-4">
                        diversity_3
                    </span>
                    <h3 class="font-display text-xl font-bold mb-3">
                        Cộng đồng
                    </h3>
                    <p class="text-text-secondary-light">
                        Kết nối những người yêu nấu ăn,
                        chia sẻ kinh nghiệm và cảm hứng tích cực.
                    </p>
                </div>

            </div>
        </section>
        <!-- CTA SECTION -->
		<section
		  class="w-full bg-orange-50 dark:bg-surface-dark py-16 md:py-24
		         border-t border-[#f3ede7] dark:border-[#3a2e26]"
		>
		  <div
		    class="max-w-5xl mx-auto flex flex-col items-center
		           text-center px-4"
		  >
		    <h2
		      class="text-3xl md:text-4xl font-black
		             text-text-main-light dark:text-text-main-dark
		             mb-4 tracking-tight"
		    >
		      Sẵn sàng bắt đầu hành trình?
		    </h2>
		
		    <p
		      class="text-text-secondary-light dark:text-text-secondary-dark
		             mb-8 text-lg max-w-lg"
		    >
		      Gia nhập CookingShare ngay hôm nay.
		      Hoàn toàn miễn phí và đầy cảm hứng.
		    </p>
		
		    <div class="flex flex-col sm:flex-row gap-4">
		      <!-- Button Tham gia -->
		      <a
		        href="RegisterServlet"
		        class="flex items-center justify-center
		               rounded-full h-12 px-8
		               bg-primary text-white
		               text-base font-bold
		               shadow-lg shadow-orange-500/20
		               hover:bg-primary-hover
		               hover:shadow-orange-500/30
		               hover:-translate-y-0.5
		               active:translate-y-0
		               transition-all duration-200"
		      >
		        Tham gia ngay
		      </a>
		
		      <!-- Button Khám phá -->
		      <a
		        href="CongThucServlet"
		        class="flex items-center justify-center
		               rounded-full h-12 px-8
		               bg-transparent
		               border border-gray-300 dark:border-gray-600
		               text-text-main-light dark:text-text-main-dark
		               text-base font-bold
		               hover:border-primary
		               hover:text-primary
		               hover:-translate-y-0.5
		               active:translate-y-0
		               transition-all duration-200"
		      >
		        Khám phá ngay
		      </a>
		    </div>
		  </div>
		</section>
		        

    </main>

    <!-- FOOTER -->
    <jsp:include page="include/footer.jsp" />

</div>
</body>
</html>
