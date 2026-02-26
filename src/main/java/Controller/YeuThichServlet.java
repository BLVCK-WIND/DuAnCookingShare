package Controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Model.congthuc;
import Model.user;
import Model.yeuthichbo;

@WebServlet("/YeuThichServlet")
public class YeuThichServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final int RECIPES_PER_PAGE = 12;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            System.out.println("=== YeuThichServlet START ===");
            
            // ✅ SỬA: Đổi "user" thành "user_user"
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_user") == null) {
                response.sendRedirect(request.getContextPath() + "/LoginServlet");
                return;
            }
            
            // ✅ SỬA: Đổi "user" thành "user_user"
            user currentUser = (user) session.getAttribute("user_user");
            int userId = currentUser.getUserId();
            
            System.out.println("Loading favorites for user ID: " + userId);
            
            // Khởi tạo bo
            yeuthichbo ytbo = new yeuthichbo();
            
            // Lấy parameters cho filter và search
            String keyword = request.getParameter("keyword");
            String categoryIdStr = request.getParameter("category");
            String sortBy = request.getParameter("sort");
            String pageStr = request.getParameter("page");
            
            System.out.println("Parameters: keyword=" + keyword + ", category=" + categoryIdStr + ", sort=" + sortBy + ", page=" + pageStr);
            
            // Parse category ID
            Integer categoryId = null;
            if (categoryIdStr != null && !categoryIdStr.isEmpty() && !categoryIdStr.equals("all")) {
                try {
                    categoryId = Integer.parseInt(categoryIdStr);
                } catch (NumberFormatException e) {
                    System.err.println("Invalid category ID: " + categoryIdStr);
                }
            }
            
            // Parse page number
            int currentPage = 1;
            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageStr);
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }
            
            // Lấy danh sách công thức yêu thích của user
            List<congthuc> favoriteRecipes = ytbo.getFavoriteRecipes(userId);
            
            if (favoriteRecipes == null) {
                favoriteRecipes = new ArrayList<>();
            }
            
            System.out.println("Total favorite recipes: " + favoriteRecipes.size());
            
            // Áp dụng filter theo keyword (tìm kiếm)
            if (keyword != null && !keyword.trim().isEmpty()) {
                final String searchKeyword = keyword.trim().toLowerCase();
                favoriteRecipes = favoriteRecipes.stream()
                    .filter(r -> r.getTitle() != null && r.getTitle().toLowerCase().contains(searchKeyword))
                    .collect(Collectors.toList());
                System.out.println("After keyword filter: " + favoriteRecipes.size());
            }
            
            // Áp dụng filter theo danh mục
            if (categoryId != null) {
                final Integer catId = categoryId;
                favoriteRecipes = favoriteRecipes.stream()
                    .filter(r -> r.getCategoryId() == catId)
                    .collect(Collectors.toList());
                System.out.println("After category filter: " + favoriteRecipes.size());
            }
            
            // Sắp xếp
            if (sortBy != null && !sortBy.isEmpty()) {
                favoriteRecipes = sortRecipes(favoriteRecipes, sortBy);
                System.out.println("After sorting by: " + sortBy);
            }
            
            // Phân trang
            int totalRecipes = favoriteRecipes.size();
            int totalPages = (int) Math.ceil((double) totalRecipes / RECIPES_PER_PAGE);
            
            if (currentPage > totalPages && totalPages > 0) {
                currentPage = totalPages;
            }
            
            int startIndex = (currentPage - 1) * RECIPES_PER_PAGE;
            int endIndex = Math.min(startIndex + RECIPES_PER_PAGE, totalRecipes);
            
            List<congthuc> pagedRecipes = new ArrayList<>();
            if (startIndex < totalRecipes) {
                pagedRecipes = favoriteRecipes.subList(startIndex, endIndex);
            }
            
            System.out.println("Pagination: Page " + currentPage + "/" + totalPages + 
                             ", Showing " + pagedRecipes.size() + " recipes");
            
            // Set attributes
            request.setAttribute("favoriteRecipes", pagedRecipes);
            request.setAttribute("totalFavorites", totalRecipes);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("recipesPerPage", RECIPES_PER_PAGE);
            
            // Giữ lại filter values
            request.setAttribute("selectedKeyword", keyword);
            request.setAttribute("selectedCategory", categoryIdStr);
            request.setAttribute("selectedSort", sortBy);
            
            System.out.println("Forwarding to yeuThich.jsp...");
            request.getRequestDispatcher("yeuThich.jsp").forward(request, response);
            
            System.out.println("=== YeuThichServlet SUCCESS ===");
            
        } catch (Exception e) {
            System.err.println("❌ LỖI trong YeuThichServlet:");
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
    
    // Helper: Sắp xếp
    private List<congthuc> sortRecipes(List<congthuc> recipes, String sortBy) {
        switch (sortBy) {
            case "latest": // Mới nhất
                return recipes.stream()
                    .sorted((r1, r2) -> {
                        if (r2.getCreatedAt() == null) return -1;
                        if (r1.getCreatedAt() == null) return 1;
                        return r2.getCreatedAt().compareTo(r1.getCreatedAt());
                    })
                    .collect(Collectors.toList());
                    
            case "view": // Lượt xem nhiều nhất
                return recipes.stream()
                    .sorted((r1, r2) -> Integer.compare(r2.getViewCount(), r1.getViewCount()))
                    .collect(Collectors.toList());
                    
            case "time-asc": // Thời gian tăng dần
                return recipes.stream()
                    .sorted((r1, r2) -> Integer.compare(r1.getCookingTime(), r2.getCookingTime()))
                    .collect(Collectors.toList());
                    
            case "time-desc": // Thời gian giảm dần
                return recipes.stream()
                    .sorted((r1, r2) -> Integer.compare(r2.getCookingTime(), r1.getCookingTime()))
                    .collect(Collectors.toList());
                    
            default:
                return recipes;
        }
    }
}