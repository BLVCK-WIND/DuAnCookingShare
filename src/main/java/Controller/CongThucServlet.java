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

import Model.congthuc;
import Model.congthucbo;
import Model.danhmuc;
import Model.danhmucbo;

@WebServlet("/CongThucServlet")
public class CongThucServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final int RECIPES_PER_PAGE = 12;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            System.out.println("=== CongthucServlet START ===");
            congthucbo ctbo = new congthucbo();
            danhmucbo dmbo = new danhmucbo();
            
            List<danhmuc> categories = dmbo.getAllDanhMuc();
            
            String keyword = request.getParameter("keyword");
            String categoryIdStr = request.getParameter("category");
            String difficulty = request.getParameter("difficulty");
            String timeRange = request.getParameter("time");
            String sortBy = request.getParameter("sort");
            String pageStr = request.getParameter("page");
            
            System.out.println("Parameters: keyword=" + keyword + ", category=" + categoryIdStr + 
                             ", difficulty=" + difficulty + ", time=" + timeRange + 
                             ", sort=" + sortBy + ", page=" + pageStr);
            
            // Parse parameters
            Integer categoryId = null;
            if (categoryIdStr != null && !categoryIdStr.isEmpty() && !categoryIdStr.equals("all")) {
                try {
                    categoryId = Integer.parseInt(categoryIdStr);
                } catch (NumberFormatException e) {
                    System.err.println("Invalid category ID: " + categoryIdStr);
                }
            }
            
            int currentPage = 1;
            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageStr);
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }
            
            List<congthuc> recipes = new ArrayList<>();
            
            if ("view".equals(sortBy)) {
                if (keyword != null && !keyword.trim().isEmpty()) {
                    recipes = ctbo.searchCongThucAdvanced(keyword.trim());
                    System.out.println("Search results with keyword: " + recipes.size());
                } else if (categoryId != null) {
                    recipes = ctbo.getCongThucByCategory(categoryId);
                    System.out.println("Category filter results: " + recipes.size());
                } else {
                    recipes = ctbo.getAllApprovedCongThuc();
                    System.out.println("All recipes: " + recipes.size());
                }
                
                recipes = recipes.stream()
                    .sorted((r1, r2) -> {
                        Integer fav1 = r1.getTotalFavorites() != null ? r1.getTotalFavorites() : 0;
                        Integer fav2 = r2.getTotalFavorites() != null ? r2.getTotalFavorites() : 0;
                        return fav2.compareTo(fav1);
                    })
                    .collect(Collectors.toList());
                System.out.println("After sorting by total_favorites (most favorite first)");
            }
            else if (keyword != null && !keyword.trim().isEmpty()) {
                recipes = ctbo.searchCongThucAdvanced(keyword.trim());
                System.out.println("Search results: " + recipes.size());
            } 
            else if (categoryId != null) {
                recipes = ctbo.getCongThucByCategory(categoryId);
                System.out.println("Category filter results: " + recipes.size());
            } 
            else {
                recipes = ctbo.getAllApprovedCongThuc();
                System.out.println("All recipes: " + recipes.size());
            }
            
            if (difficulty != null && !difficulty.isEmpty() && !difficulty.equals("all")) {
                final String difficultyFilter = difficulty;
                recipes = recipes.stream()
                    .filter(r -> difficultyFilter.equals(r.getDifficultyLevel()))
                    .collect(Collectors.toList());
                System.out.println("After difficulty filter: " + recipes.size());
            }
            
            if (timeRange != null && !timeRange.isEmpty() && !timeRange.equals("all")) {
                recipes = filterByTime(recipes, timeRange);
                System.out.println("After time filter: " + recipes.size());
            }
            
            if (sortBy != null && !sortBy.isEmpty() && !"view".equals(sortBy)) {
                recipes = sortRecipes(recipes, sortBy);
                System.out.println("After sorting by: " + sortBy);
            }
            
            // PhÃ¢n trang
            int totalRecipes = recipes.size();
            int totalPages = (int) Math.ceil((double) totalRecipes / RECIPES_PER_PAGE);
            
            if (currentPage > totalPages && totalPages > 0) {
                currentPage = totalPages;
            }
            
            int startIndex = (currentPage - 1) * RECIPES_PER_PAGE;
            int endIndex = Math.min(startIndex + RECIPES_PER_PAGE, totalRecipes);
            
            List<congthuc> pagedRecipes = new ArrayList<>();
            if (startIndex < totalRecipes) {
                pagedRecipes = recipes.subList(startIndex, endIndex);
            }
            
            System.out.println("Pagination: Page " + currentPage + "/" + totalPages + 
                             ", Showing " + pagedRecipes.size() + " recipes");
            
            request.setAttribute("recipes", pagedRecipes);
            request.setAttribute("categories", categories);
            request.setAttribute("totalRecipes", totalRecipes);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("recipesPerPage", RECIPES_PER_PAGE);
            
            request.setAttribute("selectedKeyword", keyword);
            request.setAttribute("selectedCategory", categoryIdStr);
            request.setAttribute("selectedDifficulty", difficulty);
            request.setAttribute("selectedTime", timeRange);
            request.setAttribute("selectedSort", sortBy);
            
            System.out.println("Forwarding to congThuc.jsp...");
            request.getRequestDispatcher("congThuc.jsp").forward(request, response);
            
            System.out.println("=== CongthucServlet SUCCESS ===");
            
        } catch (Exception e) {
            System.err.println("âŒ Lá»–I trong CongthucServlet:");
            e.printStackTrace();
            
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("<!DOCTYPE html>");
            response.getWriter().println("<html><head><meta charset='UTF-8'></head><body>");
            response.getWriter().println("<h1 style='color:red'>âŒ Lá»—i xáº£y ra!</h1>");
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
    
    private List<congthuc> filterByTime(List<congthuc> recipes, String timeRange) {
        switch (timeRange) {
            case "fast":
                return recipes.stream()
                    .filter(r -> r.getCookingTime() < 15)
                    .collect(Collectors.toList());
                    
            case "quick":
                return recipes.stream()
                    .filter(r -> r.getCookingTime() >= 15 && r.getCookingTime() <= 30)
                    .collect(Collectors.toList());
                    
            case "medium":
                return recipes.stream()
                    .filter(r -> r.getCookingTime() > 30 && r.getCookingTime() <= 60)
                    .collect(Collectors.toList());
                    
            case "long":
                return recipes.stream()
                    .filter(r -> r.getCookingTime() > 60)
                    .collect(Collectors.toList());
                    
            default:
                return recipes;
        }
    }
    
    private List<congthuc> sortRecipes(List<congthuc> recipes, String sortBy) {
        switch (sortBy) {
            case "latest":
                return recipes.stream()
                    .sorted((r1, r2) -> r2.getCreatedAt().compareTo(r1.getCreatedAt()))
                    .collect(Collectors.toList());
                    
            case "view":
                return recipes;
                    
            case "time-asc":
                return recipes.stream()
                    .sorted((r1, r2) -> Integer.compare(r1.getCookingTime(), r2.getCookingTime()))
                    .collect(Collectors.toList());
                    
            case "time-desc":
                return recipes.stream()
                    .sorted((r1, r2) -> Integer.compare(r2.getCookingTime(), r1.getCookingTime()))
                    .collect(Collectors.toList());
                    
            default:
                return recipes;
        }
    }
}