package Controller;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Model.congthuc;
import Model.congthucbo;
import Model.user;

@WebServlet("/CongThucCuaToiServlet")
public class CongThucCuaToiServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final int RECIPES_PER_PAGE = 12;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            System.out.println("=== CongThucCuaToiServlet START ===");
            
            // ✅ SỬA: Đổi "user" thành "user_user"
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_user") == null) {
                response.sendRedirect(request.getContextPath() + "/LoginServlet");
                return;
            }
            
            // ✅ SỬA: Đổi "user" thành "user_user"
            user currentUser = (user) session.getAttribute("user_user");
            int userId = currentUser.getUserId();
            
            System.out.println("Loading recipes for user ID: " + userId);
            
            // Khởi tạo bo
            congthucbo ctbo = new congthucbo();
            
            // Lấy parameters
            String statusFilter = request.getParameter("status");
            String keyword = request.getParameter("keyword");
            String sortBy = request.getParameter("sort");
            String pageStr = request.getParameter("page");
            
            if (statusFilter == null) statusFilter = "all";
            if (keyword == null) keyword = "";
            if (sortBy == null) sortBy = "latest";
            
            System.out.println("Filters: status=" + statusFilter + ", keyword=" + keyword + ", sort=" + sortBy + ", page=" + pageStr);
            
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
            
            // Lấy tất cả công thức của user
            List<congthuc> myRecipes = ctbo.getCongThucByUserId(userId);
            
            if (myRecipes == null) {
                myRecipes = new java.util.ArrayList<>();
            }
            
            System.out.println("Total recipes found: " + myRecipes.size());
            
            // Đếm theo trạng thái
            int totalAll = myRecipes.size();
            int totalApproved = (int) myRecipes.stream().filter(r -> "approved".equals(r.getStatus())).count();
            int totalPending = (int) myRecipes.stream().filter(r -> "pending".equals(r.getStatus())).count();
            int totalRejected = (int) myRecipes.stream().filter(r -> "rejected".equals(r.getStatus())).count();
            
            // Filter theo status
            if (!"all".equals(statusFilter)) {
                final String filterStatus = statusFilter;
                myRecipes = myRecipes.stream()
                    .filter(r -> filterStatus.equals(r.getStatus()))
                    .collect(Collectors.toList());
                System.out.println("After status filter (" + statusFilter + "): " + myRecipes.size());
            }
            
            // Filter theo keyword
            if (!keyword.trim().isEmpty()) {
                final String searchKeyword = keyword.trim().toLowerCase();
                myRecipes = myRecipes.stream()
                    .filter(r -> r.getTitle() != null && r.getTitle().toLowerCase().contains(searchKeyword))
                    .collect(Collectors.toList());
                System.out.println("After keyword filter: " + myRecipes.size());
            }
            
            // Sắp xếp
            myRecipes = sortRecipes(myRecipes, sortBy);
            
            // Phân trang
            int totalRecipes = myRecipes.size();
            int totalPages = (int) Math.ceil((double) totalRecipes / RECIPES_PER_PAGE);
            
            if (currentPage > totalPages && totalPages > 0) {
                currentPage = totalPages;
            }
            
            int startIndex = (currentPage - 1) * RECIPES_PER_PAGE;
            int endIndex = Math.min(startIndex + RECIPES_PER_PAGE, totalRecipes);
            
            List<congthuc> pagedRecipes = new java.util.ArrayList<>();
            if (startIndex < totalRecipes) {
                pagedRecipes = myRecipes.subList(startIndex, endIndex);
            }
            
            System.out.println("Pagination: Page " + currentPage + "/" + totalPages + 
                             ", Showing " + pagedRecipes.size() + " recipes");
            
            // Set attributes
            request.setAttribute("myRecipes", pagedRecipes);
            request.setAttribute("totalAll", totalAll);
            request.setAttribute("totalApproved", totalApproved);
            request.setAttribute("totalPending", totalPending);
            request.setAttribute("totalRejected", totalRejected);
            request.setAttribute("selectedStatus", statusFilter);
            request.setAttribute("selectedKeyword", keyword);
            request.setAttribute("selectedSort", sortBy);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("recipesPerPage", RECIPES_PER_PAGE);
            
            System.out.println("Forwarding to congThucCuaToi.jsp...");
            request.getRequestDispatcher("congthuccuatoi.jsp").forward(request, response);
            
            System.out.println("=== CongThucCuaToiServlet SUCCESS ===");
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi trong CongThucCuaToiServlet:");
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
                    
            case "oldest": // Cũ nhất
                return recipes.stream()
                    .sorted((r1, r2) -> {
                        if (r1.getCreatedAt() == null) return 1;
                        if (r2.getCreatedAt() == null) return -1;
                        return r1.getCreatedAt().compareTo(r2.getCreatedAt());
                    })
                    .collect(Collectors.toList());
                    
            case "most-viewed": // Nhiều lượt xem nhất
                return recipes.stream()
                    .sorted((r1, r2) -> Integer.compare(r2.getViewCount(), r1.getViewCount()))
                    .collect(Collectors.toList());
                    
            case "most-favorited": // Nhiều yêu thích nhất
                return recipes.stream()
                    .sorted((r1, r2) -> {
                        Integer fav1 = r1.getTotalFavorites() != null ? r1.getTotalFavorites() : 0;
                        Integer fav2 = r2.getTotalFavorites() != null ? r2.getTotalFavorites() : 0;
                        return fav2.compareTo(fav1);
                    })
                    .collect(Collectors.toList());
                    
            default:
                return recipes;
        }
    }
}