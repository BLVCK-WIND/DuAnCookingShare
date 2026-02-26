package Controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Model.user;

/**
 * ✅ Base Servlet cho tất cả Admin Servlet
 * Tự động kiểm tra quyền admin trước khi xử lý request
 */
public abstract class BaseAdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    /**
     * ✅ Kiểm tra admin session
     * @return Admin user object hoặc null nếu không phải admin
     */
    protected user checkAdminSession(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null) {
            System.out.println("❌ Không có session");
            response.sendRedirect("AdminPinCheckServlet");
            return null;
        }
        
        // ✅ CHỈ LẤY ADMIN USER (PREFIX: admin_)
        user adminUser = (user) session.getAttribute("admin_user");
        Boolean isAdmin = (Boolean) session.getAttribute("admin_isAdmin");
        
        if (adminUser == null || isAdmin == null || !isAdmin) {
            System.out.println("❌ Không phải admin session");
            response.sendRedirect("AdminPinCheckServlet");
            return null;
        }
        
        System.out.println("✅ Admin verified: " + adminUser.getUsername());
        
        // ✅ CHỈ ĐẶT VÀO REQUEST ATTRIBUTE (KHÔNG ĐỤ NG SESSION!)
        // Request attribute chỉ tồn tại trong 1 request, không ảnh hưởng đến tab khác
        request.setAttribute("currentUser", adminUser);
        request.setAttribute("user", adminUser); // Backward compatibility cho JSP
        
        // ❌ KHÔNG BAO GIỜ GHI ĐÈ session.setAttribute("user", ...)
        // Vì session được share giữa các tab trong cùng browser!
        
        return adminUser;
    }
    
    /**
     * Lấy admin user ID từ session
     */
    protected Integer getAdminUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (Integer) session.getAttribute("admin_userId");
        }
        return null;
    }
    
    /**
     * Override doGet - tất cả servlet con phải implement
     */
    @Override
    protected abstract void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException;
    
    /**
     * Override doPost - mặc định gọi doGet
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}