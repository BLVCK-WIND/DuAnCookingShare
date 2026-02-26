package Controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Model.congthuc;
import Model.congthucbo;
import Model.congthucbo;
import Model.danhmuc;
import Model.danhmucbo;
import Model.user;

/**
 * ✅ Servlet quản lý công thức cho Admin
 * Hỗ trợ filter theo status: all, pending, approved, rejected
 */
@WebServlet("/AdminCongThucServlet")
public class AdminCongThucServlet extends BaseAdminServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIRECTORY = "images";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // ✅ KIỂM TRA QUYỀN ADMIN
        user currentUser = checkAdminSession(request, response);
        if (currentUser == null) {
            return; // Đã redirect trong checkAdminSession
        }
        
        String action = request.getParameter("action");
        
        if (action == null) {
            // Hiển thị danh sách món ăn
            showRecipeList(request, response);
        } else if (action.equals("view")) {
            // Xem chi tiết món ăn
            viewRecipeDetail(request, response);
        } else if (action.equals("approve")) {
            // Duyệt món ăn
            approveRecipe(request, response, currentUser);
        } else if (action.equals("reject")) {
            // Từ chối món ăn
            rejectRecipe(request, response, currentUser);
        } else if (action.equals("delete")) {
            // Xóa món ăn
            deleteRecipe(request, response);
        } else if (action.equals("search")) {
            // ✅ MỚI: Tìm kiếm món ăn
            searchRecipes(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    // ========= ✅ HIỂN THỊ DANH SÁCH - ĐÃ SỬA =========
    /**
     * Hiển thị danh sách công thức theo filter
     * - all: Tất cả (sắp xếp: pending -> approved -> rejected)
     * - pending: Chỉ chờ duyệt
     * - approved: Chỉ đã duyệt
     * - rejected: Chỉ đã từ chối
     */
    private void showRecipeList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String statusFilter = request.getParameter("status");
        if (statusFilter == null) statusFilter = "all";
        
        congthucbo ctbo = new congthucbo();
        List<congthuc> recipeList;
        try {
        // ✅ Sửa: Lựa chọn method phù hợp
        if (statusFilter.equals("all")) {
            // Lấy tất cả - sắp xếp theo thứ tự ưu tiên
            recipeList = ctbo.getAllRecipesForAdmin();
            System.out.println("✅ Lấy tất cả công thức: " + recipeList.size());
            
        } else {
            // Lấy theo status cụ thể
            recipeList = ctbo.getRecipesByStatus(statusFilter);
            System.out.println("✅ Lấy công thức status '" + statusFilter + "': " + recipeList.size());
        }
        
        // Đếm số lượng cho từng tab
        int totalCount = ctbo.countTotalRecipes();
        int pendingCount = ctbo.countRecipesByStatus("pending");
        int approvedCount = ctbo.countRecipesByStatus("approved");
        int rejectedCount = ctbo.countRecipesByStatus("rejected");
        
        // ✅ MỚI: Lấy danh sách categories cho filter dropdown
        danhmucbo dmbo = new danhmucbo();
        List<danhmuc> categories = dmbo.getAllDanhMuc();
        
        // Gửi dữ liệu sang JSP
        request.setAttribute("recipeList", recipeList);
        request.setAttribute("currentFilter", statusFilter);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("approvedCount", approvedCount);
        request.setAttribute("rejectedCount", rejectedCount);
        request.setAttribute("categories", categories);  // ✅ MỚI
        request.setAttribute("searchKeyword", "");  // ✅ MỚI
        request.setAttribute("selectedCategory", "");  // ✅ MỚI
        
        request.getRequestDispatcher("adminCongthuc.jsp").forward(request, response);
        } catch (Exception e) {
			// TODO: handle exception
		}
    }
    
    // ========= XEM CHI TIẾT MÓN ĂN =========
    private void viewRecipeDetail(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int recipeId = Integer.parseInt(request.getParameter("recipeId"));
            
            congthucbo bo = new congthucbo();
            congthuc recipe = bo.getCongThucById(recipeId);
            
            if (recipe == null) {
                request.setAttribute("error", "Món ăn không tồn tại!");
                showRecipeList(request, response);
                return;
            }
            
            request.setAttribute("recipe", recipe);
            request.getRequestDispatcher("adminRecipeDetail.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi xem chi tiết món ăn: " + e.getMessage());
            request.setAttribute("error", "Có lỗi xảy ra!");
            showRecipeList(request, response);
        }
    }
    
    // ========= ✅ DUYỆT MÓN ĂN - ĐÃ SỬA (COPY ẢNH) =========
    private void approveRecipe(HttpServletRequest request, HttpServletResponse response, user admin) 
            throws ServletException, IOException {
        
        try {
            int recipeId = Integer.parseInt(request.getParameter("recipeId"));
            
            congthucbo bo = new congthucbo();
            boolean success = bo.approveRecipe(recipeId, admin.getUserId());
            
            if (success) {
                // ✅ THÊM: Copy ảnh vào src/main/webapp/ khi duyệt
                copyImageToSource(recipeId);
                
                System.out.println("✅ Admin " + admin.getUsername() + " đã duyệt recipe #" + recipeId);
                request.setAttribute("success", "Đã duyệt món ăn thành công!");
            } else {
                request.setAttribute("error", "Duyệt món ăn thất bại!");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi duyệt món ăn: " + e.getMessage());
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        // Redirect về trang chờ duyệt
        response.sendRedirect("AdminCongThucServlet?status=pending");
    }
    
    // ========= TỪ CHỐI MÓN ĂN =========
    private void rejectRecipe(HttpServletRequest request, HttpServletResponse response, user admin) 
            throws ServletException, IOException {
        
        try {
            int recipeId = Integer.parseInt(request.getParameter("recipeId"));
            String reason = request.getParameter("reason");
            
            if (reason == null || reason.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập lý do từ chối!");
                viewRecipeDetail(request, response);
                return;
            }
            
            congthucbo bo = new congthucbo();
            boolean success = bo.rejectRecipe(recipeId, reason, admin.getUserId());
            
            if (success) {
                System.out.println("✅ Admin " + admin.getUsername() + " đã từ chối recipe #" + recipeId);
                request.setAttribute("success", "Đã từ chối món ăn!");
            } else {
                request.setAttribute("error", "Từ chối món ăn thất bại!");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi từ chối món ăn: " + e.getMessage());
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        response.sendRedirect("AdminCongThucServlet?status=pending");
    }
    
    // ========= XÓA MÓN ĂN =========
    private void deleteRecipe(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int recipeId = Integer.parseInt(request.getParameter("recipeId"));
            
            congthucbo bo = new congthucbo();
            boolean success = bo.deleteCongThuc(recipeId);
            
            if (success) {
                System.out.println("✅ Đã xóa recipe #" + recipeId);
                request.setAttribute("success", "Đã xóa món ăn thành công!");
            } else {
                request.setAttribute("error", "Xóa món ăn thất bại!");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi xóa món ăn: " + e.getMessage());
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        // Lấy status hiện tại để quay lại đúng tab
        String currentStatus = request.getParameter("currentStatus");
        if (currentStatus == null) currentStatus = "all";
        
        response.sendRedirect("AdminCongThucServlet?status=" + currentStatus);
    }
    
    // ========= ✅ METHOD MỚI: COPY ẢNH KHI DUYỆT =========
    /**
     * Copy ảnh từ deploy → src/main/webapp/ khi admin duyệt
     */
    private void copyImageToSource(int recipeId) {
        try {
            System.out.println("📋 Copying image to source for recipe #" + recipeId);
            
            congthucbo bo = new congthucbo();
            congthuc recipe = bo.getCongThucById(recipeId);
            
            if (recipe == null || recipe.getImageUrl() == null || recipe.getImageUrl().isEmpty()) {
                System.out.println("ℹ️ No image to copy");
                return;
            }
            
            String imageUrl = recipe.getImageUrl(); // "images/1234567890_photo.jpg"
            String fileName = imageUrl;
            if (imageUrl.contains("/")) {
                fileName = imageUrl.substring(imageUrl.lastIndexOf("/") + 1);
            }
            
            System.out.println("📁 Image file: " + fileName);
            
            // ✅ BƯỚC 1: Lấy file từ deploy directory
            String deployPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
            File deployFile = new File(deployPath, fileName);
            
            if (!deployFile.exists() || !deployFile.isFile()) {
                System.err.println("⚠️ Deploy file not found: " + deployFile.getAbsolutePath());
                return;
            }
            
            System.out.println("✅ Deploy file exists: " + deployFile.getAbsolutePath());
            System.out.println("   Size: " + deployFile.length() + " bytes");
            
            // ✅ BƯỚC 2: Tính toán đường dẫn source
            String realPath = getServletContext().getRealPath("");
            String sourcePath = realPath;
            
            // Xử lý Eclipse WTP hoặc Maven
            if (realPath.contains("target")) {
                // Maven deployment
                sourcePath = realPath.replaceFirst("target[\\\\/].*", "src" + File.separator + "main" + File.separator + "webapp");
                
            } else if (realPath.contains(".metadata") || realPath.contains("wtpwebapps")) {
                // Eclipse WTP
                String workspacePath;
                if (realPath.contains(".metadata")) {
                    workspacePath = realPath.substring(0, realPath.indexOf(".metadata"));
                } else {
                    File tmpDeployDir = new File(realPath);
                    workspacePath = tmpDeployDir.getParentFile().getParentFile().getParentFile()
                                              .getParentFile().getParentFile().getParent() + File.separator;
                }
                
                String projectName = "CookingShare";
                sourcePath = workspacePath + projectName + File.separator + "src" + File.separator + 
                             "main" + File.separator + "webapp";
                
                System.out.println("🔧 Eclipse WTP detected");
                System.out.println("   Workspace: " + workspacePath);
            }
            
            sourcePath = sourcePath + File.separator + UPLOAD_DIRECTORY;
            File sourceDir = new File(sourcePath);
            
            System.out.println("📁 Source path: " + sourcePath);
            
            // ✅ BƯỚC 3: Tạo thư mục nếu chưa có
            if (!sourceDir.exists()) {
                boolean created = sourceDir.mkdirs();
                System.out.println("📁 Created source dir: " + created);
            }
            
            // ✅ BƯỚC 4: Copy ảnh
            File sourceFile = new File(sourcePath, fileName);
            Files.copy(deployFile.toPath(), sourceFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
            
            System.out.println("✅ Copied to SOURCE: " + sourceFile.getAbsolutePath());
            System.out.println("   Size: " + sourceFile.length() + " bytes");
            System.out.println("🎉 Image approved and saved permanently!");
            
        } catch (Exception e) {
            System.err.println("⚠️ Error copying image to source:");
            e.printStackTrace();
            // Không throw exception - công thức đã được duyệt rồi
        }
    }
    
    // ========= ✅ MỚI: TÌM KIẾM CÔNG THỨC =========
    /**
     * Tìm kiếm công thức theo keyword và filter
     */
    private void searchRecipes(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        String statusFilter = request.getParameter("status");
        String categoryIdStr = request.getParameter("category");
        
        if (statusFilter == null) statusFilter = "all";
        
        // Parse category ID
        Integer categoryId = null;
        if (categoryIdStr != null && !categoryIdStr.isEmpty() && !categoryIdStr.equals("all")) {
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (NumberFormatException e) {
                System.err.println("Invalid category ID: " + categoryIdStr);
            }
        }
        
        congthucbo bo = new congthucbo();
        List<congthuc> recipeList;
        try {
        // Tìm kiếm với các filter
        if ((keyword != null && !keyword.trim().isEmpty()) || categoryId != null) {
            recipeList = bo.searchRecipesForAdmin(keyword, statusFilter, categoryId);
        } else {
            // Không có từ khóa -> hiển thị theo status
            if (statusFilter.equals("all")) {
                recipeList = bo.getAllRecipesForAdmin();
            } else {
                recipeList = bo.getRecipesByStatus(statusFilter);
            }
        }
        
        // Đếm số lượng cho từng tab
        int totalCount = bo.countTotalRecipes();
        int pendingCount = bo.countRecipesByStatus("pending");
        int approvedCount = bo.countRecipesByStatus("approved");
        int rejectedCount = bo.countRecipesByStatus("rejected");
        
        // Lấy danh sách categories cho filter dropdown
        danhmucbo dmbo = new danhmucbo();
        List<danhmuc> categories = dmbo.getAllDanhMuc();
        
        // Gửi dữ liệu sang JSP
        request.setAttribute("recipeList", recipeList);
        request.setAttribute("currentFilter", statusFilter);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("approvedCount", approvedCount);
        request.setAttribute("rejectedCount", rejectedCount);
        request.setAttribute("categories", categories);
        request.setAttribute("searchKeyword", keyword != null ? keyword : "");
        request.setAttribute("selectedCategory", categoryIdStr != null ? categoryIdStr : "");
        
        request.getRequestDispatcher("adminCongthuc.jsp").forward(request, response);
        } catch (Exception e) {
			// TODO: handle exception
		}
    }
}