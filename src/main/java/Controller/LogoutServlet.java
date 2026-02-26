package Controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // ✅ XÁC ĐỊNH LOẠI ĐĂNG XUẤT
            String logoutType = request.getParameter("type");
            
            if ("admin".equals(logoutType)) {
                // ========= ĐĂNG XUẤT ADMIN (CHỈ XÓA SESSION ADMIN) =========
                System.out.println("🚪 Đăng xuất Admin");
                
                session.removeAttribute("admin_user");
                session.removeAttribute("admin_userId");
                session.removeAttribute("admin_username");
                session.removeAttribute("admin_isAdmin");
                session.removeAttribute("adminPinVerified");
                
                System.out.println("✅ Đã xóa admin session");
                
                response.sendRedirect("AdminPinCheckServlet");
                
            } else {
                // ========= ĐĂNG XUẤT USER (CHỈ XÓA SESSION USER) =========
                System.out.println("🚪 Đăng xuất Customer");
                
                session.removeAttribute("user_user");
                session.removeAttribute("user_userId");
                session.removeAttribute("user_username");
                session.removeAttribute("user_isAdmin");
                
                System.out.println("✅ Đã xóa customer session");
                
                response.sendRedirect("LoginServlet");
            }
            
            // ✅ NẾU CẢ 2 ĐỀU KHÔNG CÒN, INVALIDATE SESSION
            if (session.getAttribute("admin_user") == null && 
                session.getAttribute("user_user") == null) {
                System.out.println("🗑️ Xóa toàn bộ session");
                session.invalidate();
            }
            
        } else {
            response.sendRedirect("LoginServlet");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}