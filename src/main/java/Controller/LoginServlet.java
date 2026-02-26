package Controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Model.user;
import Model.userbo;
import Model.mahoaMD5;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // MÃ PIN ADMIN - Thay đổi theo ý bạn
    private static final String ADMIN_PIN = "2026";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        if ("checkAdminPin".equals(action)) {
            handleAdminPinCheck(request, response);
        } else {
            handleLogin(request, response);
        }
    }
    
    // ========= Kiểm tra mã PIN admin =========
    private void handleAdminPinCheck(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pin = request.getParameter("pin");
        
        if (ADMIN_PIN.equals(pin)) {
            // Đúng PIN - cho phép vào trang login admin
            HttpSession session = request.getSession();
            session.setAttribute("adminPinVerified", true);
            session.setMaxInactiveInterval(300);
            
            response.sendRedirect("AdminLoginServlet");
        } else {
            // Sai PIN
            request.setAttribute("pinError", "Mã PIN không đúng!");
            request.getRequestDispatcher("adminPinCheck.jsp").forward(request, response);
        }
    }
    
    // ========= ✅ XỬ LÝ ĐĂNG NHẬP - CÓ HASH MD5 =========
    private void handleLogin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String loginType = request.getParameter("loginType"); // "user" hoặc "admin"
        
        // Validate input
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
            
            if ("admin".equals(loginType)) {
                request.getRequestDispatcher("adminLogin.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
            return;
        }
        
        // Kiểm tra nếu đăng nhập admin thì phải verify PIN trước
        if ("admin".equals(loginType)) {
            HttpSession session = request.getSession();
            Boolean pinVerified = (Boolean) session.getAttribute("adminPinVerified");
            
            if (pinVerified == null || !pinVerified) {
                response.sendRedirect("AdminPinCheckServlet");
                return;
            }
        }
        
        // ✅ MÃ HÓA MẬT KHẨU ĐỂ SO SÁNH VỚI DATABASE
        String hashedPassword;
        try {
            hashedPassword = mahoaMD5.encrypt(password.trim());
            System.out.println("🔐 Password hashed for comparison");
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi mã hóa mật khẩu: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "Lỗi hệ thống!");
            if ("admin".equals(loginType)) {
                request.getRequestDispatcher("adminLogin.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
            return;
        }
        try {
	        // Gọi bo để kiểm tra - Truyền HASH PASSWORD
	        userbo bo = new userbo();
	        user u = bo.login(username.trim(), hashedPassword);  // ✅ SO SÁNH HASH
	        
	        if (u != null) {
	            // Kiểm tra quyền
	            if ("admin".equals(loginType)) {
	                if (!u.isAdmin()) {
	                    request.setAttribute("error", "Tài khoản này không có quyền admin!");
	                    request.getRequestDispatcher("adminLogin.jsp").forward(request, response);
	                    return;
	                }
	            } else {
	                if (u.isAdmin()) {
	                    request.setAttribute("error", "Tài khoản admin không thể đăng nhập ở đây!");
	                    request.getRequestDispatcher("login.jsp").forward(request, response);
	                    return;
	                }
	            }
	            
	            // ✅ HOÀN TOÀN TÁCH BIỆT SESSION - KHÔNG DÙNG "user" CHUNG
	            HttpSession session = request.getSession();
	            
	            if (u.isAdmin()) {
	                // ========= SESSION ADMIN (PREFIX: admin_) =========
	                session.setAttribute("admin_user", u);
	                session.setAttribute("admin_userId", u.getUserId());
	                session.setAttribute("admin_username", u.getUsername());
	                session.setAttribute("admin_isAdmin", true);
	                
	                // Xóa adminPinVerified
	                session.removeAttribute("adminPinVerified");
	                
	                System.out.println("✅ Admin đăng nhập: " + u.getUsername());
	                
	            } else {
	                // ========= SESSION USER (PREFIX: user_) =========
	                session.setAttribute("user_user", u);
	                session.setAttribute("user_userId", u.getUserId());
	                session.setAttribute("user_username", u.getUsername());
	                session.setAttribute("user_isAdmin", false);
	                
	                System.out.println("✅ User đăng nhập: " + u.getUsername());
	            }
	            
	            // ❌ KHÔNG BAO GIỜ SET session.setAttribute("user", ...) CHUNG
	            // Vì nó sẽ ghi đè lẫn nhau giữa các tab!
	            
	            session.setMaxInactiveInterval(3600); // 1 giờ
	            
	            // Redirect
	            if (u.isAdmin()) {
	                response.sendRedirect("AdminDashboardServlet");
	            } else {
	                response.sendRedirect("HomeServlet");
	            }
	            
	        } else {
	            // Đăng nhập thất bại
	            request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng!");
	            request.setAttribute("username", username);
	            
	            if ("admin".equals(loginType)) {
	                request.getRequestDispatcher("adminLogin.jsp").forward(request, response);
	            } else {
	                request.getRequestDispatcher("login.jsp").forward(request, response);
	            }
	        }
			
		} catch (Exception e) {
			// TODO: handle exception
		}
    }
}