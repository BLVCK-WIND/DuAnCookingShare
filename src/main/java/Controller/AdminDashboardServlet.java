package Controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Model.user;

@WebServlet("/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // ✅ KIỂM TRA SESSION ADMIN (DÙNG PREFIX admin_)
        HttpSession session = request.getSession(false);
        
        if (session == null) {
            System.out.println("❌ Không có session - chuyển về login");
            response.sendRedirect("LoginServlet");
            return;
        }
        
        // ✅ LẤY ADMIN USER TỪ SESSION
        user currentUser = (user) session.getAttribute("admin_user");
        Boolean isAdmin = (Boolean) session.getAttribute("admin_isAdmin");
        
        if (currentUser == null || isAdmin == null || !isAdmin) {
            System.out.println("❌ Không phải admin hoặc chưa đăng nhập admin");
            response.sendRedirect("AdminPinCheckServlet");
            return;
        }
        
        System.out.println("✅ Admin truy cập dashboard: " + currentUser.getUsername());
        
        // ✅ ĐẶT LẠI ATTRIBUTE "user" CHO JSP (backward compatibility)
        request.setAttribute("user", currentUser);
        
        // Forward tới trang dashboard
        request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}