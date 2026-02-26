package Controller;

import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import Model.danhmuc;
import Model.danhmucbo;
import Model.user;

@WebServlet("/AdminDanhMucServlet")
public class AdminDanhMucServlet extends BaseAdminServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIRECTORY = "imgdanhmuc";
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Kiểm tra quyền admin
        user currentUser = checkAdminSession(request, response);
        if (currentUser == null) {
            return;
        }
        
        String action = request.getParameter("action");
        System.out.println("=== AdminDanhMucServlet doGet ===");
        System.out.println("Action: " + action);
        
        // ✅ SỬA LẠI LOGIC - TÁCH BIỆT TỪNG ACTION
        if (action == null || action.isEmpty()) {
            System.out.println("→ Showing category list (no action)");
            showCategoryList(request, response);
            
        } else if ("edit".equals(action)) {
            System.out.println("→ Showing edit form");
            showEditForm(request, response);
            
        } else if ("delete".equals(action)) {
            // ✅ ĐÚNG: Xóa danh mục khi action = "delete"
            System.out.println("→ Deleting category");
            deleteCategory(request, response);
            
        } else if ("search".equals(action)) {
            // ✅ ĐÚNG: Tìm kiếm khi action = "search"
            System.out.println("→ Searching categories");
            searchCategories(request, response);
            
        } else {
            System.out.println("→ Unknown action, showing category list");
            showCategoryList(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        System.out.println("=== AdminDanhMucServlet doPost ===");
        
        // Kiểm tra quyền admin
        user currentUser = checkAdminSession(request, response);
        if (currentUser == null) {
            return;
        }
        
        // Kiểm tra multipart
        if (!ServletFileUpload.isMultipartContent(request)) {
            response.getWriter().println("Form must have enctype=multipart/form-data");
            return;
        }
        
        try {
            // Cấu hình upload
            DiskFileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setFileSizeMax(MAX_FILE_SIZE);
            
            // Parse request
            List<FileItem> fileItems = upload.parseRequest(request);
            
            String action = null;
            String categoryId = null;
            String categoryName = null;
            String description = null;
            String imageFileName = null;
            
            // Xử lý từng item
            for (FileItem item : fileItems) {
                if (item.isFormField()) {
                    String fieldName = item.getFieldName();
                    String fieldValue = item.getString("UTF-8");
                    
                    System.out.println("Form field: " + fieldName + " = " + fieldValue);
                    
                    switch (fieldName) {
                        case "action":
                            action = fieldValue;
                            break;
                        case "categoryId":
                            categoryId = fieldValue;
                            break;
                        case "categoryName":
                            categoryName = fieldValue;
                            break;
                        case "description":
                            description = fieldValue;
                            break;
                    }
                    
                } else {
                    // Xử lý file upload
                    String fileName = item.getName();
                    
                    if (fileName != null && !fileName.isEmpty()) {
                        System.out.println("Processing category image: " + fileName);
                        
                        // Kiểm tra định dạng file
                        String contentType = item.getContentType();
                        if (!contentType.startsWith("image/")) {
                            request.setAttribute("error", "Chỉ được upload file ảnh!");
                            showCategoryList(request, response);
                            return;
                        }
                        
                        // Tạo tên file unique
                        imageFileName = System.currentTimeMillis() + "_" + fileName.replaceAll("[^a-zA-Z0-9.]", "_");
                        
                        // ✅ LƯU VÀO DEPLOY DIRECTORY
                        String deployPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
                        File deployDir = new File(deployPath);
                        
                        System.out.println("📁 Deploy path: " + deployPath);
                        
                        // Tạo thư mục nếu chưa có
                        if (!deployDir.exists()) {
                            boolean created = deployDir.mkdirs();
                            System.out.println("📁 Created deploy dir: " + created);
                        }
                        
                        // Lưu file
                        String deployFilePath = deployPath + File.separator + imageFileName;
                        File deployFile = new File(deployFilePath);
                        item.write(deployFile);
                        
                        System.out.println("✅ Saved to DEPLOY: " + deployFilePath);
                        System.out.println("   Size: " + deployFile.length() + " bytes");
                    }
                }
            }
            
            System.out.println("Action from form: " + action);
            
            // Xử lý action
            if ("add".equals(action)) {
                System.out.println("→ Adding category");
                addCategory(request, response, categoryName, description, imageFileName);
            } else if ("update".equals(action)) {
                System.out.println("→ Updating category");
                updateCategory(request, response, categoryId, categoryName, description, imageFileName);
            } else {
                System.out.println("→ Unknown action in POST");
                showCategoryList(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error in AdminDanhMucServlet:");
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            showCategoryList(request, response);
        }
    }
    
    // ========= HIỂN THỊ DANH SÁCH =========
    private void showCategoryList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        danhmucbo bo = new danhmucbo();
        try {
            List<danhmuc> categoryList = bo.getAllDanhMuc();
            
            System.out.println("✅ Loaded " + categoryList.size() + " categories");
            
            request.setAttribute("categoryList", categoryList);
            request.setAttribute("searchKeyword", "");
            request.getRequestDispatcher("adminDanhmuc.jsp").forward(request, response);
                
        } catch (Exception e) {
            System.err.println("❌ Lỗi lấy danh sách danh mục: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("adminDanhmuc.jsp").forward(request, response);
        }
    }
    
    // ========= HIỂN THỊ FORM CHỈNH SỬA =========
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String categoryIdStr = request.getParameter("categoryId");
            System.out.println("Edit category ID: " + categoryIdStr);
            
            int categoryId = Integer.parseInt(categoryIdStr);
            
            danhmucbo bo = new danhmucbo();
            danhmuc category = bo.getDanhMucById(categoryId);
            
            if (category == null) {
                System.err.println("❌ Category not found: " + categoryId);
                request.setAttribute("error", "Danh mục không tồn tại!");
                showCategoryList(request, response);
                return;
            }
            
            System.out.println("✅ Found category: " + category.getCategoryName());
            
            request.setAttribute("editCategory", category);
            request.setAttribute("action", "edit");
            
            // ✅ VẪN HIỂN THỊ DANH SÁCH TRONG CÙNG TRANG
            List<danhmuc> categoryList = bo.getAllDanhMuc();
            request.setAttribute("categoryList", categoryList);
            request.setAttribute("searchKeyword", "");
            
            request.getRequestDispatcher("adminDanhmuc.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi hiển thị form sửa: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra!");
            showCategoryList(request, response);
        }
    }
    
    // ========= THÊM DANH MỤC MỚI =========
    private void addCategory(HttpServletRequest request, HttpServletResponse response,
                            String categoryName, String description, String imageFileName) 
            throws ServletException, IOException {
        
        System.out.println("=== Adding Category ===");
        System.out.println("Name: " + categoryName);
        System.out.println("Description: " + description);
        System.out.println("Image: " + imageFileName);
        
        // Validate
        if (categoryName == null || categoryName.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập tên danh mục!");
            showCategoryList(request, response);
            return;
        }
        
        if (imageFileName == null || imageFileName.isEmpty()) {
            request.setAttribute("error", "Vui lòng tải lên ảnh danh mục!");
            showCategoryList(request, response);
            return;
        }
        
        danhmucbo bo = new danhmucbo();
        try {
            // Kiểm tra trùng tên
            if (bo.isCategoryNameExist(categoryName.trim())) {
                System.err.println("❌ Category name already exists: " + categoryName);
                request.setAttribute("error", "Tên danh mục đã tồn tại!");
                showCategoryList(request, response);
                return;
            }
            
            // Tạo object danhmuc
            danhmuc newCategory = new danhmuc();
            newCategory.setCategoryName(categoryName.trim());
            newCategory.setDescription(description != null && !description.trim().isEmpty() ? description.trim() : null);
            newCategory.setImageUrl(UPLOAD_DIRECTORY + "/" + imageFileName);
            
            boolean success = bo.addDanhMuc(newCategory);
            
            if (success) {
                System.out.println("✅ Added category: " + categoryName);
                request.setAttribute("success", "Đã thêm danh mục mới thành công!");
            } else {
                System.err.println("❌ Failed to add category");
                request.setAttribute("error", "Thêm danh mục thất bại!");
            }
            
            showCategoryList(request, response);
                
        } catch (Exception e) {
            System.err.println("❌ Lỗi thêm danh mục: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            showCategoryList(request, response);
        }
    }
    
    // ========= CẬP NHẬT DANH MỤC =========
    private void updateCategory(HttpServletRequest request, HttpServletResponse response,
                               String categoryIdStr, String categoryName, String description, String imageFileName) 
            throws ServletException, IOException {
        
        System.out.println("=== Updating Category ===");
        System.out.println("ID: " + categoryIdStr);
        System.out.println("Name: " + categoryName);
        System.out.println("New image: " + imageFileName);
        
        try {
            int categoryId = Integer.parseInt(categoryIdStr);
            
            // Validate
            if (categoryName == null || categoryName.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập tên danh mục!");
                showCategoryList(request, response);
                return;
            }
            
            danhmucbo bo = new danhmucbo();
            danhmuc oldCategory = bo.getDanhMucById(categoryId);
            
            if (oldCategory == null) {
                System.err.println("❌ Category not found: " + categoryId);
                request.setAttribute("error", "Danh mục không tồn tại!");
                showCategoryList(request, response);
                return;
            }
            
            // Tạo object danhmuc
            danhmuc category = new danhmuc();
            category.setCategoryId(categoryId);
            category.setCategoryName(categoryName.trim());
            category.setDescription(description != null && !description.trim().isEmpty() ? description.trim() : null);
            
            // Nếu có ảnh mới thì dùng ảnh mới, không thì giữ ảnh cũ
            if (imageFileName != null && !imageFileName.isEmpty()) {
                category.setImageUrl(UPLOAD_DIRECTORY + "/" + imageFileName);
                System.out.println("🔸 Using new image: " + imageFileName);
                
                // Xóa ảnh cũ
                if (oldCategory.getImageUrl() != null && !oldCategory.getImageUrl().isEmpty()) {
                    deleteImageFile(oldCategory.getImageUrl());
                }
            } else {
                category.setImageUrl(oldCategory.getImageUrl());
                System.out.println("🔸 Keeping old image: " + oldCategory.getImageUrl());
            }
            
            boolean success = bo.updateDanhMuc(category);
            
            if (success) {
                System.out.println("✅ Updated category: " + categoryName);
                request.setAttribute("success", "Đã cập nhật danh mục thành công!");
            } else {
                System.err.println("❌ Failed to update category");
                request.setAttribute("error", "Cập nhật danh mục thất bại!");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi cập nhật danh mục: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        showCategoryList(request, response);
    }
    
    // ========= XÓA DANH MỤC =========
    private void deleteCategory(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("=== Deleting Category ===");
        
        try {
            String categoryIdStr = request.getParameter("categoryId");
            System.out.println("Category ID parameter: " + categoryIdStr);
            
            if (categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
                System.err.println("❌ Missing categoryId parameter");
                request.setAttribute("error", "Thiếu thông tin ID danh mục!");
                showCategoryList(request, response);
                return;
            }
            
            int categoryId = Integer.parseInt(categoryIdStr);
            System.out.println("🗑️ Attempting to delete category ID: " + categoryId);
            
            danhmucbo bo = new danhmucbo();
            
            // Kiểm tra xem danh mục có tồn tại không
            danhmuc category = bo.getDanhMucById(categoryId);
            if (category == null) {
                System.err.println("❌ Category not found: " + categoryId);
                request.setAttribute("error", "Danh mục không tồn tại!");
                showCategoryList(request, response);
                return;
            }
            
            System.out.println("✅ Found category: " + category.getCategoryName());
            
            // Kiểm tra xem danh mục có món ăn không
            int recipeCount = bo.countRecipesByCategory(categoryId);
            System.out.println("📊 Recipe count in this category: " + recipeCount);
            
            if (recipeCount > 0) {
                System.err.println("❌ Cannot delete - category has " + recipeCount + " recipes");
                request.setAttribute("error", "Không thể xóa danh mục vì còn " + recipeCount + " món ăn thuộc danh mục này!");
                showCategoryList(request, response);
                return;
            }
            
            // Thực hiện xóa
            boolean success = bo.deleteDanhMuc(categoryId);
            
            if (success) {
                System.out.println("✅ Successfully deleted category from database");
                
                // Xóa ảnh từ thư mục
                if (category.getImageUrl() != null && !category.getImageUrl().isEmpty()) {
                    System.out.println("🗑️ Attempting to delete image file");
                    deleteImageFile(category.getImageUrl());
                }
                
                System.out.println("✅ Deleted category ID: " + categoryId);
                request.setAttribute("success", "Đã xóa danh mục thành công!");
            } else {
                System.err.println("❌ Failed to delete category ID: " + categoryId);
                request.setAttribute("error", "Xóa danh mục thất bại! Có thể do lỗi database.");
            }
            
        } catch (NumberFormatException e) {
            System.err.println("❌ Invalid category ID format: " + e.getMessage());
            request.setAttribute("error", "ID danh mục không hợp lệ!");
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi xóa danh mục: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        showCategoryList(request, response);
    }
    
    // ========= XÓA ẢNH KHỎI THƯ MỤC =========
    private void deleteImageFile(String imageUrl) {
        try {
            String fileName = imageUrl;
            if (imageUrl.contains("/")) {
                fileName = imageUrl.substring(imageUrl.lastIndexOf("/") + 1);
            }
            
            System.out.println("🗑️ Deleting category image: " + fileName);
            
            // Xóa từ deploy directory
            String deployPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
            File deployFile = new File(deployPath, fileName);
            
            System.out.println("📁 Image path: " + deployFile.getAbsolutePath());
            
            if (deployFile.exists() && deployFile.isFile()) {
                boolean deleted = deployFile.delete();
                if (deleted) {
                    System.out.println("✅ Deleted image from DEPLOY: " + deployFile.getAbsolutePath());
                } else {
                    System.err.println("⚠️ Failed to delete image from DEPLOY");
                }
            } else {
                System.out.println("ℹ️ Image file not found in DEPLOY: " + deployFile.getAbsolutePath());
            }
            
        } catch (Exception e) {
            System.err.println("⚠️ Error deleting image file:");
            e.printStackTrace();
        }
    }
    
    // ========= TÌM KIẾM DANH MỤC =========
    private void searchCategories(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        System.out.println("=== Searching Categories ===");
        System.out.println("Keyword: " + keyword);
        
        danhmucbo bo = new danhmucbo();
        List<danhmuc> categoryList;
        try {
            if (keyword != null && !keyword.trim().isEmpty()) {
                categoryList = bo.searchCategories(keyword);
                request.setAttribute("searchKeyword", keyword);
                System.out.println("✅ Found " + categoryList.size() + " categories");
            } else {
                categoryList = bo.getAllDanhMuc();
                request.setAttribute("searchKeyword", "");
                System.out.println("✅ Showing all categories");
            }
            
            request.setAttribute("categoryList", categoryList);
            request.getRequestDispatcher("adminDanhmuc.jsp").forward(request, response);
        
        } catch (Exception e) {
            System.err.println("❌ Lỗi tìm kiếm danh mục: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            showCategoryList(request, response);
        }
    }
}