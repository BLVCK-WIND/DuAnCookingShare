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

@WebServlet("/TrangCaNhanServlet")
public class TrangCaNhanServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            HttpSession session = request.getSession(false);
            // ✅ SỬA: Đổi "user" thành "user_user"
            if (session == null || session.getAttribute("user_user") == null) {
                response.sendRedirect(request.getContextPath() + "/LoginServlet");
                return;
            }
            
            // ✅ SỬA: Đổi "user" thành "user_user"
            user currentUser = (user) session.getAttribute("user_user");
            int userId = currentUser.getUserId();
            
            userbo userbo = new userbo();
            user userInfo = userbo.getUserById(userId);
            
            if (userInfo == null) {
                response.sendRedirect(request.getContextPath() + "/LoginServlet");
                return;
            }
            
            int totalRecipes = userbo.countUserRecipes(userId);
            int totalLikesReceived = userbo.countUserFavoritesReceived(userId);
            int totalFavoritesSent = userbo.countUserFavoritesSent(userId);
            
            request.setAttribute("userInfo", userInfo);
            request.setAttribute("totalRecipes", totalRecipes);
            request.setAttribute("totalLikesReceived", totalLikesReceived);
            request.setAttribute("totalFavoritesSent", totalFavoritesSent);
            
            String[] avatars = {"avatar1", "avatar2", "avatar3", "avatar4", "avatar5", "avatar6", "avatar7"};
            request.setAttribute("availableAvatars", avatars);
            
            request.getRequestDispatcher("trangcanhan.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");
            
            HttpSession session = request.getSession(false);
            // ✅ SỬA: Đổi "user" thành "user_user"
            if (session == null || session.getAttribute("user_user") == null) {
                response.sendRedirect(request.getContextPath() + "/LoginServlet");
                return;
            }
            
            // ✅ SỬA: Đổi "user" thành "user_user"
            user currentUser = (user) session.getAttribute("user_user");
            String action = request.getParameter("action");
            
            if ("updateProfile".equals(action)) {
                String fullName = request.getParameter("fullName");
                String avatar = request.getParameter("avatar");
                
                currentUser.setFullName(fullName);
                currentUser.setAvatar(avatar);
                
                userbo userbo = new userbo();
                boolean success = userbo.updateUserProfile(currentUser);
                
                if (success) {
                    user updatedUser = userbo.getUserById(currentUser.getUserId());
                    // ✅ SỬA: Đổi "user" thành "user_user"
                    session.setAttribute("user_user", updatedUser);
                    
                    response.setContentType("text/html; charset=UTF-8");
                    response.getWriter().println("<script>alert('Cập nhật thành công!'); window.location.href='" + 
                        request.getContextPath() + "/TrangCaNhanServlet';</script>");
                } else {
                    response.setContentType("text/html; charset=UTF-8");
                    response.getWriter().println("<script>alert('Có lỗi xảy ra!'); history.back();</script>");
                }
                
            } else if ("changePassword".equals(action)) {
                String currentPassword = request.getParameter("currentPassword");
                String newPassword = request.getParameter("newPassword");
                String confirmPassword = request.getParameter("confirmPassword");
                
                // ✅ HASH PASSWORD HIỆN TẠI ĐỂ SO SÁNH
                String hashedCurrentPassword;
                try {
                    hashedCurrentPassword = mahoaMD5.encrypt(currentPassword);
                } catch (Exception e) {
                    System.err.println("❌ Lỗi hash password: " + e.getMessage());
                    response.setContentType("text/html; charset=UTF-8");
                    response.getWriter().println("<script>alert('Lỗi hệ thống!'); history.back();</script>");
                    return;
                }
                
                // So sánh hash
                if (!hashedCurrentPassword.equals(currentUser.getPassword())) {
                    response.setContentType("text/html; charset=UTF-8");
                    response.getWriter().println("<script>alert('Mật khẩu hiện tại không đúng!'); history.back();</script>");
                    return;
                }
                
                if (!newPassword.equals(confirmPassword)) {
                    response.setContentType("text/html; charset=UTF-8");
                    response.getWriter().println("<script>alert('Mật khẩu mới không khớp!'); history.back();</script>");
                    return;
                }
                
                // ✅ HASH PASSWORD MỚI TRƯỚC KHI LƯU
                String hashedNewPassword;
                try {
                    hashedNewPassword = mahoaMD5.encrypt(newPassword);
                    System.out.println("🔐 New password hashed");
                } catch (Exception e) {
                    System.err.println("❌ Lỗi hash new password: " + e.getMessage());
                    response.setContentType("text/html; charset=UTF-8");
                    response.getWriter().println("<script>alert('Lỗi hệ thống!'); history.back();</script>");
                    return;
                }
                
                userbo userbo = new userbo();
                boolean success = userbo.changePassword(currentUser.getUserId(), hashedNewPassword);
                
                if (success) {
                    currentUser.setPassword(hashedNewPassword);  // Update hash trong session
                    // ✅ SỬA: Đổi "user" thành "user_user"
                    session.setAttribute("user_user", currentUser);
                    
                    System.out.println("✅ Password changed for user: " + currentUser.getUsername());
                    
                    response.setContentType("text/html; charset=UTF-8");
                    response.getWriter().println("<script>alert('Đổi mật khẩu thành công!'); window.location.href='" + 
                        request.getContextPath() + "/TrangCaNhanServlet';</script>");
                } else {
                    response.setContentType("text/html; charset=UTF-8");
                    response.getWriter().println("<script>alert('Có lỗi xảy ra!'); history.back();</script>");
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("<script>alert('Lỗi: " + e.getMessage() + "'); history.back();</script>");
        }
    }
}