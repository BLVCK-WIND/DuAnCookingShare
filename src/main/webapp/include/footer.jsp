<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <!-- FOOTER -->
    <footer class="footer">
        <div class="footer-container">
            <div class="footer-inner">
                <div class="footer-grid">
                    <div class="footer-column">
                        <div class="footer-brand">
                            <span class="material-symbols-outlined">skillet</span>
                            <h3>CookingShare</h3>
                        </div>
                        <p class="footer-description">
                            Nơi chia sẻ niềm đam mê nấu nướng, kết nối những tâm hồn yêu ẩm thực và lan tỏa hương vị yêu thương đến mọi gia đình.
                        </p>
                    </div>
                    <div class="footer-column">
                        <h4 class="footer-title">Khám Phá</h4>
                        <ul class="footer-links">
                            <li><a href="<%= request.getContextPath() %>/CongThucServlet?keyword=&sort=latest&category=all&difficulty=all&time=all">Công thức mới</a></li>
                            <li><a href="<%= request.getContextPath() %>/CongThucServlet">Danh mục</a></li>
                        </ul>
                    </div>
                    <div class="footer-column">
                        <h4 class="footer-title">Cộng Đồng</h4>
                        <ul class="footer-links">
                            <li><a href="<%= request.getContextPath() %>/ThemCongThucServlet">Chia sẻ công thức</a></li>
                            <li><a href="<%= request.getContextPath() %>/GioiThieuServlet">Giới thiệu</a></li>
                        </ul>
                    </div>
                    <div class="footer-column">
                        <h4 class="footer-title">Liên Hệ</h4>
                        <ul class="footer-links">
                            <li class="footer-link-item">
                                <span class="material-symbols-outlined">location_on</span>
                                <span>Huế, Việt Nam</span>
                            </li>
                            <li class="footer-link-item">
                                <span class="material-symbols-outlined">mail</span>
                                <span>contact@cooking.com</span>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="footer-bottom">
                    <p>© 2026 CookingShare. All rights reserved.</p>
                </div>
            </div>
        </div>
    </footer>
</body>
</html>
