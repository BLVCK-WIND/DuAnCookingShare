package Controller;

import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
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

@WebServlet("/ThemCongThucServlet")
public class ThemCongThucServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIRECTORY = "images";
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            System.out.println("=== ThemCongThucServlet GET ===");
            
            // Kiểm tra đăng nhập
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_user") == null) {
                response.sendRedirect(request.getContextPath() + "/LoginServlet");
                return;
            }
            
            // Lấy danh sách danh mục
            danhmucbo dmbo = new danhmucbo();
            request.setAttribute("categories", dmbo.getAllDanhMuc());
            
            // Forward đến trang thêm công thức
            RequestDispatcher rd = request.getRequestDispatcher("themcongthuc.jsp");
            rd.forward(request, response);
            
        } catch (Exception e) {
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
            System.out.println("=== ThemCongThucServlet POST - Processing Upload ===");
            
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
            
            // Tạo đối tượng công thức
            congthuc recipe = new congthuc();
            recipe.setUserId(currentUser.getUserId());
            recipe.setStatus("pending"); // Mặc định chờ duyệt
            
            String imageFileName = null;
            
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
                    // Xử lý file upload
                    String fileName = item.getName();
                    
                    if (fileName != null && !fileName.isEmpty()) {
                        System.out.println("Processing file: " + fileName);
                        
                        // Kiểm tra định dạng file
                        String contentType = item.getContentType();
                        if (!contentType.startsWith("image/")) {
                            response.setContentType("text/html; charset=UTF-8");
                            response.getWriter().println("<script>alert('Chỉ được upload file ảnh!'); history.back();</script>");
                            return;
                        }
                        
                        // Tạo tên file unique
                        imageFileName = System.currentTimeMillis() + "_" + fileName.replaceAll("[^a-zA-Z0-9.]", "_");
                        
                        // ✅ LƯU VÀO THƯ MỤC DEPLOY
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
                        
                        // ✅ LOGIC ĐÚNG: KHÔNG COPY VÀO SOURCE - CHỜ ADMIN DUYỆT
                        System.out.println("⏳ Status: PENDING - Ảnh chưa được copy vào src/main/webapp/");
                        System.out.println("   Ảnh sẽ được copy khi admin duyệt công thức");
                        
                        // Lưu đường dẫn vào database
                        recipe.setImageUrl(UPLOAD_DIRECTORY + "/" + imageFileName);
                        
                        System.out.println("💾 Database URL: " + recipe.getImageUrl());
                    }
                }
            }
            
            // Validate dữ liệu
            if (recipe.getTitle() == null || recipe.getTitle().trim().isEmpty()) {
                response.setContentType("text/html; charset=UTF-8");
                response.getWriter().println("<script>alert('Vui lòng nhập tiêu đề công thức!'); history.back();</script>");
                return;
            }
            
            if (recipe.getCategoryId() == 0) {
                response.setContentType("text/html; charset=UTF-8");
                response.getWriter().println("<script>alert('Vui lòng chọn danh mục!'); history.back();</script>");
                return;
            }
            
            if (imageFileName == null) {
                response.setContentType("text/html; charset=UTF-8");
                response.getWriter().println("<script>alert('Vui lòng tải lên ảnh món ăn!'); history.back();</script>");
                return;
            }
            
            // Lưu vào database
            congthucbo ctbo = new congthucbo();
            int recipeId = ctbo.addCongThuc(recipe);
            
            if (recipeId > 0) {
                System.out.println("✅ Recipe added successfully with ID: " + recipeId);
                
                response.setContentType("text/html; charset=UTF-8");
                response.getWriter().println("<script>alert('Thêm công thức thành công! Công thức đang chờ phê duyệt.'); window.location.href='" + 
                    request.getContextPath() + "/CongThucCuaToiServlet';</script>");
            } else {
                System.err.println("❌ Failed to add recipe");
                response.setContentType("text/html; charset=UTF-8");
                response.getWriter().println("<script>alert('Có lỗi xảy ra khi thêm công thức!'); history.back();</script>");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error in ThemCongThucServlet:");
            e.printStackTrace();
            
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("<script>alert('Có lỗi xảy ra: " + e.getMessage() + "'); history.back();</script>");
        }
    }
}