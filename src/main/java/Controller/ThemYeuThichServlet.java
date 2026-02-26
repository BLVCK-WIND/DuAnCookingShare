package Controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.JsonObject;

import Model.user;
import Model.yeuthichbo;

@WebServlet("/ThemYeuThichServlet")
public class ThemYeuThichServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        JsonObject jsonResponse = new JsonObject();
        
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_user") == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Vui lòng đăng nhập để thêm vào yêu thích!");
                response.getWriter().write(jsonResponse.toString());
                return;
            }
            
            user currentUser = (user) session.getAttribute("user_user");
            
            // Lấy recipeId
            String recipeIdStr = request.getParameter("recipeId");
            if (recipeIdStr == null || recipeIdStr.trim().isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Thiếu thông tin công thức!");
                response.getWriter().write(jsonResponse.toString());
                return;
            }
            
            int recipeId = Integer.parseInt(recipeIdStr);
            int userId = currentUser.getUserId();
            
            System.out.println("Toggle favorite - User: " + userId + ", Recipe: " + recipeId);
            
            yeuthichbo ytbo = new yeuthichbo();
            
            // Kiểm tra đã yêu thích chưa
            boolean isFavorited = ytbo.isFavorite(userId, recipeId);
            
            boolean success;
            if (isFavorited) {
                // Đã yêu thích -> Bỏ yêu thích
                success = ytbo.removeFavorite(userId, recipeId);
                if (success) {
                    jsonResponse.addProperty("success", true);
                    jsonResponse.addProperty("isFavorited", false);
                    jsonResponse.addProperty("message", "Đã bỏ yêu thích!");
                    System.out.println("✅ Removed from favorites");
                } else {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Không thể bỏ yêu thích. Vui lòng thử lại!");
                }
            } else {
                // Chưa yêu thích -> Thêm yêu thích
                success = ytbo.addFavorite(userId, recipeId);
                if (success) {
                    jsonResponse.addProperty("success", true);
                    jsonResponse.addProperty("isFavorited", true);
                    jsonResponse.addProperty("message", "Đã thêm vào yêu thích!");
                    System.out.println("✅ Added to favorites");
                } else {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Không thể thêm vào yêu thích. Vui lòng thử lại!");
                }
            }
            
        } catch (NumberFormatException e) {
            System.err.println("❌ Invalid recipe ID format");
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "ID công thức không hợp lệ!");
            
        } catch (Exception e) {
            System.err.println("❌ Error in ThemYeuThichServlet: " + e.getMessage());
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Có lỗi xảy ra. Vui lòng thử lại!");
        }
        
        response.getWriter().write(jsonResponse.toString());
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method is not supported.");
    }
}