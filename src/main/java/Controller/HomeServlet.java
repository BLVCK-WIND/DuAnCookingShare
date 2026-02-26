package Controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Model.congthuc;
import Model.congthucbo;
import Model.thongkebo;
import Model.danhmucbo;
import Model.danhmuc;

@WebServlet("/HomeServlet")
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("=== HomeServlet START ===");
        
        try {
            // Khởi tạo bo
            congthucbo ctbo = new congthucbo();
            thongkebo tkbo = new thongkebo();
            danhmucbo dmbo = new danhmucbo();
            
            // Lấy dữ liệu
            System.out.println("Đang lấy dữ liệu...");
            List<congthuc> latestRecipes = ctbo.getLatestRecipes(8);
            List<congthuc> topViewed = tkbo.getTop5MostViewed();
            List<congthuc> topFavorite = tkbo.getTop5MostFavorite();
            List<congthuc> topRated = tkbo.getTop5HighestRated();
            List<danhmuc> categories = dmbo.getAllDanhMuc();
            
            int totalRecipes = tkbo.countTotalRecipes();
            int totalUsers = tkbo.countTotalUsers();
            int recipesLast7Days = tkbo.countRecipesLast7Days();
            
            System.out.println("✓ Latest: " + (latestRecipes != null ? latestRecipes.size() : 0));
            System.out.println("✓ TopViewed: " + (topViewed != null ? topViewed.size() : 0));
            System.out.println("✓ Categories: " + (categories != null ? categories.size() : 0));
            
            // Set attributes
            request.setAttribute("latestRecipes", latestRecipes);
            request.setAttribute("topViewed", topViewed);
            request.setAttribute("topFavorite", topFavorite);
            request.setAttribute("topRated", topRated);
            request.setAttribute("totalRecipes", totalRecipes);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("recipesLast7Days", recipesLast7Days);
            request.setAttribute("categories", categories);
            
            // ✅ Forward tới home.jsp (trong Maven là /home.jsp)
            System.out.println("Forwarding to /home.jsp...");
            request.getRequestDispatcher("home.jsp").forward(request, response);
            
            System.out.println("=== HomeServlet SUCCESS ===");
            
        } catch (Exception e) {
            System.err.println("❌ LỖI trong HomeServlet:");
            e.printStackTrace();
            
            // Hiển thị lỗi chi tiết
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