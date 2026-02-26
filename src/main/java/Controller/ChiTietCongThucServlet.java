package Controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Model.congthuc;
import Model.congthucbo;
import Model.user;
import Model.yeuthichbo;

@WebServlet("/ChiTietCongThucServlet")
public class ChiTietCongThucServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            System.out.println("=== ChiTietCongThucServlet START ===");
            
            // Lấy recipe ID từ parameter
            String recipeIdStr = request.getParameter("id");
            
            if (recipeIdStr == null || recipeIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/CongThucServlet");
                return;
            }
            
            int recipeId = Integer.parseInt(recipeIdStr);
            System.out.println("Loading recipe ID: " + recipeId);
            
            // Khởi tạo bo
            congthucbo ctbo = new congthucbo();
            yeuthichbo ytbo = new yeuthichbo();
            
            // Lấy thông tin công thức (getCongThucById sẽ tự động tăng view_count)
            congthuc recipe = ctbo.getCongThucById(recipeId);
            
            if (recipe == null) {
                System.err.println("❌ Không tìm thấy công thức ID: " + recipeId);
                response.sendRedirect(request.getContextPath() + "/CongThucServlet");
                return;
            }
            
            System.out.println("✅ Found recipe: " + recipe.getTitle());
            
            // Kiểm tra xem user đã đăng nhập chưa và công thức có được yêu thích chưa
            HttpSession session = request.getSession(false);
            boolean isFavorited = false;
            
            if (session != null) {
                // ✅ SỬA: Đổi "user" thành "user_user"
                user currentUser = (user) session.getAttribute("user_user");
                if (currentUser != null) {
                    isFavorited = ytbo.isFavorite(currentUser.getUserId(), recipeId);
                    System.out.println("User " + currentUser.getUserId() + " favorited: " + isFavorited);
                }
            }
            
            
            // Lấy các công thức liên quan (cùng danh mục)
            List<congthuc> relatedRecipes = ctbo.getCongThucByCategory(recipe.getCategoryId());
            
            // Loại bỏ công thức hiện tại khỏi danh sách liên quan
            relatedRecipes.removeIf(r -> r.getRecipeId() == recipeId);
            
            // Chỉ lấy tối đa 4 công thức liên quan
            if (relatedRecipes.size() > 4) {
                relatedRecipes = relatedRecipes.subList(0, 4);
            }
            
            System.out.println("Related recipes: " + relatedRecipes.size());
            
            // Set attributes
            request.setAttribute("recipe", recipe);
            request.setAttribute("isFavorited", isFavorited);
            request.setAttribute("relatedRecipes", relatedRecipes);
            
            // Forward đến JSP
            System.out.println("Forwarding to chitietcongthuc.jsp...");
            request.getRequestDispatcher("chitietcongthuc.jsp").forward(request, response);
            
            System.out.println("=== ChiTietCongThucServlet SUCCESS ===");
            
        } catch (NumberFormatException e) {
            System.err.println("❌ Invalid recipe ID format");
            response.sendRedirect(request.getContextPath() + "/CongThucServlet");
            
        } catch (Exception e) {
            System.err.println("❌ LỖI trong ChiTietCongThucServlet:");
            e.printStackTrace();
            
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("<!DOCTYPE html>");
            response.getWriter().println("<html><head><meta charset='UTF-8'></head><body>");
            response.getWriter().println("<h1 style='color:red'>❌ Lỗi xảy ra!</h1>");
            response.getWriter().println("<h3>Message: " + e.getMessage() + "</h3>");
            response.getWriter().println("<pre>");
            e.printStackTrace(response.getWriter());
            response.getWriter().println("</pre>");
            response.getWriter().println("</body></html>");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}