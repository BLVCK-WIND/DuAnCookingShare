package Controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Model.user;
import Model.userbo;

@WebServlet("/AdminUserServlet")
public class AdminUserServlet extends BaseAdminServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // âœ… KIá»‚M TRA QUYá»€N ADMIN
        user currentUser = checkAdminSession(request, response);
        if (currentUser == null) {
            return; // ÄÃ£ redirect trong checkAdminSession
        }
        
        String action = request.getParameter("action");
        
        if (action == null) {
            // Hiá»ƒn thá»‹ danh sÃ¡ch ngÆ°á»i dÃ¹ng
            showUserList(request, response);
        } else if (action.equals("delete")) {
            // XÃ³a ngÆ°á»i dÃ¹ng
            deleteUser(request, response);
        } else if (action.equals("view")) {
            // Xem chi tiáº¿t ngÆ°á»i dÃ¹ng
            viewUserDetail(request, response);
        } else if (action.equals("search")) {
            // âœ… Má»šI: TÃ¬m kiáº¿m ngÆ°á»i dÃ¹ng
            searchUsers(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    // Hiá»ƒn thá»‹ danh sÃ¡ch ngÆ°á»i dÃ¹ng
    private void showUserList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
	        userbo bo = new userbo();
	        List<user> userList = bo.getAllUsers();
	        
	        request.setAttribute("userList", userList);
	        request.setAttribute("searchKeyword", ""); // Empty search
	        request.getRequestDispatcher("adminUsers.jsp").forward(request, response);
		
		} catch (Exception e) {
			// TODO: handle exception
		}
    }
    
    // âœ… Má»šI: TÃ¬m kiáº¿m ngÆ°á»i dÃ¹ng
    private void searchUsers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        
        userbo bo = new userbo();
        List<user> userList;
        try {
	        if (keyword != null && !keyword.trim().isEmpty()) {
	            userList = bo.searchUsers(keyword);
	            request.setAttribute("searchKeyword", keyword);
	        } else {
	            userList = bo.getAllUsers();
	            request.setAttribute("searchKeyword", "");
	        }
	        
	        request.setAttribute("userList", userList);
	        request.getRequestDispatcher("adminUsers.jsp").forward(request, response);
		
		} catch (Exception e) {
			// TODO: handle exception
		}
    }
    
    // XÃ³a ngÆ°á»i dÃ¹ng
    private void deleteUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            
            userbo bo = new userbo();
            user userToDelete = bo.getUserById(userId);
            
            if (userToDelete == null) {
                request.setAttribute("error", "Người dùng không tồn tại");
                showUserList(request, response);
                return;
            }
            
            // KhÃ´ng cho phÃ©p xÃ³a admin
            if (userToDelete.isAdmin()) {
                request.setAttribute("error", "KhÃ´ng thá»ƒ xÃ³a tÃ i khoáº£n Admin!");
                showUserList(request, response);
                return;
            }
            
            boolean success = bo.deleteUser(userId);
            
            if (success) {
                request.setAttribute("success", "ÄÃ£ xÃ³a ngÆ°á»i dÃ¹ng thÃ nh cÃ´ng!");
            } else {
                request.setAttribute("error", "XÃ³a ngÆ°á»i dÃ¹ng tháº¥t báº¡i!");
            }
            
        } catch (Exception e) {
            System.err.println("âŒ Lá»—i xÃ³a ngÆ°á»i dÃ¹ng: " + e.getMessage());
            request.setAttribute("error", "CÃ³ lá»—i xáº£y ra: " + e.getMessage());
        }
        
        showUserList(request, response);
    }
    
    // Xem chi tiáº¿t ngÆ°á»i dÃ¹ng
    private void viewUserDetail(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            
            userbo bo = new userbo();
            user userDetail = bo.getUserById(userId);
            
            if (userDetail == null) {
                request.setAttribute("error", "Người dùng không tồn tại!");
                showUserList(request, response);
                return;
            }
            
            // Láº¥y thÃ´ng tin thá»'ng kÃª
            int recipeCount = bo.countUserRecipes(userId);
            int favoritesReceived = bo.countUserFavoritesReceived(userId);
            int favoritesSent = bo.countUserFavoritesSent(userId);
            
            request.setAttribute("userDetail", userDetail);
            request.setAttribute("recipeCount", recipeCount);
            request.setAttribute("favoritesReceived", favoritesReceived);
            request.setAttribute("favoritesSent", favoritesSent);
            
            request.getRequestDispatcher("adminUserDetail.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("âŒ Lá»—i xem chi tiáº¿t user: " + e.getMessage());
            request.setAttribute("error", "CÃ³ lá»—i xáº£y ra!");
            showUserList(request, response);
        }
    }
}