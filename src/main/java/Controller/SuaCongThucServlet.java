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

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import Model.congthuc;
import Model.congthucbo;
import Model.danhmucbo;
import Model.user;

@WebServlet("/SuaCongThucServlet")
public class SuaCongThucServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIRECTORY = "images";
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            System.out.println("=== SuaCongThucServlet GET ===");
            
            // Kiểm tra đăng nhập
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_user") == null) {
                response.sendRedirect(request.getContextPath() + "/LoginServlet");
                return;
            }
            
            user currentUser = (user) session.getAttribute("user_user");
            
            // Lấy recipe ID
            String recipeIdStr = request.getParameter("id");
            if (recipeIdStr == null || recipeIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/CongThucCuaToiServlet");
                return;
            }
            
            int recipeId = Integer.parseInt(recipeIdStr);
            
            // Lấy công thức
            congthucbo ctbo = new congthucbo();
            congthuc recipe = ctbo.getCongThucById(recipeId);
            
            if (recipe == null) {
                response.setContentType("text/html; charset=UTF-8");
                response.getWriter().println("<script>alert('Không tìm thấy công thức!'); window.location.href='" + 
                    request.getContextPath() + "/CongThucCuaToiServlet';</script>");
                return;
            }
            
            // Kiểm tra quyền - chỉ chủ sở hữu mới được xem/sửa
            if (recipe.getUserId() != currentUser.getUserId()) {
                response.setContentType("text/html; charset=UTF-8");
                response.getWriter().println("<script>alert('Bạn không có quyền truy cập công thức này!'); window.location.href='" + 
                    request.getContextPath() + "/CongThucCuaToiServlet';</script>");
                return;
            }
            
            // Lấy mode (view hoặc edit)
            String mode = request.getParameter("mode");
            if (mode == null) mode = "view"; // Mặc định là xem
            
            // Lấy danh sách danh mục (cho edit mode)
            danhmucbo dmbo = new danhmucbo();
            request.setAttribute("categories", dmbo.getAllDanhMuc());
            
            // Set attributes
            request.setAttribute("recipe", recipe);
            request.setAttribute("mode", mode);
            request.setAttribute("isOwner", true);
            
            System.out.println("Forwarding to suaCongThuc.jsp (mode: " + mode + ")...");
            request.getRequestDispatcher("suacongthuc.jsp").forward(request, response);
            
            System.out.println("=== SuaCongThucServlet GET SUCCESS ===");
            
        } catch (NumberFormatException e) {
            System.err.println("❌ Invalid recipe ID format");
            response.sendRedirect(request.getContextPath() + "/CongThucCuaToiServlet");
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi trong SuaCongThucServlet GET:");
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Kiểm tra content length
        if (request.getContentLength() <= 0) {
            doGet(request, response);
            return;
        }
        
        try {
            System.out.println("=== SuaCongThucServlet POST - Processing Update ===");
            
            // Kiểm tra đăng nhập
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_user") == null) {
                response.sendRedirect(request.getContextPath() + "/LoginServlet");
                return;
            }
            
            user currentUser = (user) session.getAttribute("user_user");
            
            // Kiểm tra multipart
            if (!ServletFileUpload.isMultipartContent(request)) {
                response.getWriter().println("Form must have enctype=multipart/form-data");
                return;
            }
            
            // Cấu hình upload
            DiskFileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setFileSizeMax(MAX_FILE_SIZE);
            
            // Tạo đối tượng công thức để cập nhật
            congthuc recipe = new congthuc();
            int recipeId = 0;
            String imageFileName = null;
            String oldImageUrl = null;
            
            // Parse request
            List<FileItem> fileItems = upload.parseRequest(request);
            
            // Xử lý từng item
            for (FileItem item : fileItems) {
                if (item.isFormField()) {
                    // Xử lý các field thông thường
                    String fieldName = item.getFieldName();
                    String fieldValue = item.getString("UTF-8");
                    
                    System.out.println("Field: " + fieldName + " = " + fieldValue);
                    
                    switch (fieldName) {
                        case "recipeId":
                            if (!fieldValue.isEmpty()) {
                                recipeId = Integer.parseInt(fieldValue);
                                recipe.setRecipeId(recipeId);
                            }
                            break;
                        case "oldImageUrl":
                            oldImageUrl = fieldValue;
                            break;
                        case "title":
                            recipe.setTitle(fieldValue);
                            break;
                        case "description":
                            recipe.setDescription(fieldValue);
                            break;
                        case "cookingTime":
                            if (!fieldValue.isEmpty()) {
                                recipe.setCookingTime(Integer.parseInt(fieldValue));
                            }
                            break;
                        case "difficulty":
                            recipe.setDifficultyLevel(fieldValue);
                            break;
                        case "servings":
                            if (!fieldValue.isEmpty()) {
                                recipe.setServings(Integer.parseInt(fieldValue));
                            }
                            break;
                        case "categoryId":
                            if (!fieldValue.isEmpty()) {
                                recipe.setCategoryId(Integer.parseInt(fieldValue));
                            }
                            break;
                        case "ingredients":
                            recipe.setIngredients(fieldValue);
                            break;
                        case "instructions":
                            recipe.setInstructions(fieldValue);
                            break;
                        case "notes":
                            recipe.setNotes(fieldValue);
                            break;
                    }
                    
                } else {
                    // Xử lý file upload (nếu có)
                    String fileName = item.getName();
                    
                    if (fileName != null && !fileName.isEmpty()) {
                        System.out.println("Processing new image: " + fileName);
                        
                        // Kiểm tra định dạng file
                        String contentType = item.getContentType();
                        if (!contentType.startsWith("image/")) {
                            response.setContentType("text/html; charset=UTF-8");
                            response.getWriter().println("<script>alert('Chỉ được upload file ảnh!'); history.back();</script>");
                            return;
                        }
                        
                        // Tạo tên file unique
                        imageFileName = System.currentTimeMillis() + "_" + fileName.replaceAll("[^a-zA-Z0-9.]", "_");
                        
                        // ✅ LẤY ĐƯỜNG DẪN DEPLOY VÀ SOURCE
                        String deployPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
                        
                        String realPath = getServletContext().getRealPath("");
                        String sourcePath = realPath;
                        
                        if (realPath.contains("target")) {
                            sourcePath = realPath.replaceFirst("target[\\\\/].*", "src" + File.separator + "main" + File.separator + "webapp");
                        }
                        sourcePath = sourcePath + File.separator + UPLOAD_DIRECTORY;
                        
                        File deployDir = new File(deployPath);
                        File sourceDir = new File(sourcePath);
                        
                        // Tạo thư mục nếu chưa có
                        if (!deployDir.exists()) deployDir.mkdirs();
                        if (!sourceDir.exists()) sourceDir.mkdirs();
                        
                        // ✅ LƯU VÀO DEPLOY
                        String deployFilePath = deployPath + File.separator + imageFileName;
                        File deployFile = new File(deployFilePath);
                        item.write(deployFile);
                        
                        System.out.println("✅ Saved to DEPLOY: " + deployFilePath);
                        
                        // ✅ COPY SANG SOURCE
                        String sourceFilePath = sourcePath + File.separator + imageFileName;
                        File sourceFile = new File(sourceFilePath);
                        
                        try {
                            Files.copy(deployFile.toPath(), sourceFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                            System.out.println("✅ Copied to SOURCE: " + sourceFilePath);
                        } catch (Exception e) {
                            System.err.println("⚠️ Warning: Could not copy to source directory");
                            e.printStackTrace();
                        }
                        
                        // ✅ XÓA ẢNH CŨ (cả 2 nơi)
                        if (oldImageUrl != null && !oldImageUrl.isEmpty()) {
                            String oldFileName = oldImageUrl;
                            if (oldImageUrl.contains("/")) {
                                oldFileName = oldImageUrl.substring(oldImageUrl.lastIndexOf("/") + 1);
                            }
                            
                            // Xóa trong deploy
                            File oldDeployFile = new File(deployPath, oldFileName);
                            if (oldDeployFile.exists()) {
                                oldDeployFile.delete();
                                System.out.println("🗑️ Deleted old deploy image: " + oldFileName);
                            }
                            
                            // Xóa trong source
                            File oldSourceFile = new File(sourcePath, oldFileName);
                            if (oldSourceFile.exists()) {
                                oldSourceFile.delete();
                                System.out.println("🗑️ Deleted old source image: " + oldFileName);
                            }
                        }
                        
                        // ✅ LƯU ĐƯỜNG DẪN VÀO DATABASE
                        recipe.setImageUrl(UPLOAD_DIRECTORY + "/" + imageFileName);
                    }
                }
            }
            
            // Validate
            if (recipeId == 0) {
                response.setContentType("text/html; charset=UTF-8");
                response.getWriter().println("<script>alert('Thiếu ID công thức!'); history.back();</script>");
                return;
            }
            
            // Kiểm tra quyền sở hữu
            congthucbo ctbo = new congthucbo();
            congthuc existingRecipe = ctbo.getCongThucById(recipeId);
            
            if (existingRecipe == null || existingRecipe.getUserId() != currentUser.getUserId()) {
                response.setContentType("text/html; charset=UTF-8");
                response.getWriter().println("<script>alert('Bạn không có quyền sửa công thức này!'); history.back();</script>");
                return;
            }
            
            // Nếu không upload ảnh mới, giữ ảnh cũ
            if (imageFileName == null) {
                recipe.setImageUrl(oldImageUrl);
            }
            
            // Cập nhật database
            boolean success = ctbo.updateCongThuc(recipe);

            if (success) {
                System.out.println("✅ Recipe updated successfully: " + recipeId);
                
                response.setContentType("text/html; charset=UTF-8");
                response.getWriter().println("<script>alert('Cập nhật công thức thành công!'); window.location.href='" + 
                    request.getContextPath() + "/SuaCongThucServlet?id=" + recipeId + "&mode=view';</script>");
            } else {
                System.err.println("❌ Failed to update recipe");
                response.setContentType("text/html; charset=UTF-8");
                response.getWriter().println("<script>alert('Có lỗi xảy ra khi cập nhật công thức!'); history.back();</script>");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error in SuaCongThucServlet POST:");
            e.printStackTrace();
            
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("<script>alert('Có lỗi xảy ra: " + e.getMessage() + "'); history.back();</script>");
        }
    }
}