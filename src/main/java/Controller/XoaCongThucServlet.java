package Controller;

import java.io.File;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Model.congthuc;
import Model.congthucbo;
import Model.user;

/**
 * ✅ XoaCongThucServlet
 * - Xóa công thức khỏi database
 * - Xóa ảnh khỏi deploy directory
 * - Xóa ảnh khỏi src/main/webapp/ CHỈ NẾU đã approved
 */
@WebServlet("/XoaCongThucServlet")
public class XoaCongThucServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIRECTORY = "images";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            System.out.println("=== XoaCongThucServlet START ===");
            
            // Kiểm tra đăng nhập
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_user") == null) {
                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().write("{\"success\": false, \"message\": \"Vui lòng đăng nhập!\"}");
                return;
            }
            
            user currentUser = (user) session.getAttribute("user_user");
            
            // Lấy recipe ID
            String recipeIdStr = request.getParameter("id");
            if (recipeIdStr == null || recipeIdStr.trim().isEmpty()) {
                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().write("{\"success\": false, \"message\": \"Thiếu ID công thức!\"}");
                return;
            }
            
            int recipeId = Integer.parseInt(recipeIdStr);
            System.out.println("Deleting recipe ID: " + recipeId);
            
            // Khởi tạo bo
            congthucbo ctbo = new congthucbo();
            
            // ✅ BƯỚC 1: LẤY THÔNG TIN CÔNG THỨC (để lấy imageUrl và status)
            congthuc recipe = ctbo.getCongThucById(recipeId);
            
            if (recipe == null) {
                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().write("{\"success\": false, \"message\": \"Không tìm thấy công thức!\"}");
                return;
            }
            
            // ✅ BƯỚC 2: KIỂM TRA QUYỀN SỞ HỮU
            if (recipe.getUserId() != currentUser.getUserId()) {
                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().write("{\"success\": false, \"message\": \"Bạn không có quyền xóa công thức này!\"}");
                return;
            }
            
            String imageUrl = recipe.getImageUrl();
            String status = recipe.getStatus();
            
            System.out.println("Image URL: " + imageUrl);
            System.out.println("Status: " + status);
            
            // ✅ BƯỚC 3: XÓA CÔNG THỨC KHỎI DATABASE
            boolean deleted = ctbo.deleteCongThuc(recipeId);
            
            if (!deleted) {
                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().write("{\"success\": false, \"message\": \"Không thể xóa công thức!\"}");
                return;
            }
            
            System.out.println("✅ Recipe deleted from database");
            
            // ✅ BƯỚC 4: XÓA ẢNH (NẾU CÓ) - KIỂM TRA STATUS
            if (imageUrl != null && !imageUrl.isEmpty()) {
                deleteImageFiles(imageUrl, status);
            }
            
            // ✅ BƯỚC 5: TRẢ VỀ KẾT QUẢ
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write("{\"success\": true, \"message\": \"Xóa công thức thành công!\"}");
            
            System.out.println("=== XoaCongThucServlet SUCCESS ===");
            
        } catch (NumberFormatException e) {
            System.err.println("❌ Invalid recipe ID format");
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write("{\"success\": false, \"message\": \"ID công thức không hợp lệ!\"}");
            
        } catch (Exception e) {
            System.err.println("❌ Error in XoaCongThucServlet:");
            e.printStackTrace();
            
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write("{\"success\": false, \"message\": \"Có lỗi xảy ra: " + e.getMessage() + "\"}");
        }
    }
    
    /**
     * ✅ XÓA ẢNH - KIỂM TRA STATUS TRƯỚC KHI XÓA TỪ SOURCE
     * 
     * @param imageUrl - Đường dẫn ảnh từ database (VD: "images/1234567890_photo.jpg")
     * @param status - Trạng thái công thức (pending, approved, rejected)
     */
    private void deleteImageFiles(String imageUrl, String status) {
        try {
            // Lấy tên file từ imageUrl
            String fileName = imageUrl;
            if (imageUrl.contains("/")) {
                fileName = imageUrl.substring(imageUrl.lastIndexOf("/") + 1);
            }
            
            System.out.println("🗑️ Deleting image: " + fileName + " (status: " + status + ")");
            
            // ✅ LUÔN XÓA TỪ DEPLOY (vì đang hiển thị ở đây)
            String deployPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
            File deployFile = new File(deployPath, fileName);
            
            if (deployFile.exists() && deployFile.isFile()) {
                boolean deleted = deployFile.delete();
                if (deleted) {
                    System.out.println("✅ Deleted from DEPLOY: " + deployFile.getAbsolutePath());
                } else {
                    System.err.println("⚠️ Failed to delete from DEPLOY: " + deployFile.getAbsolutePath());
                }
            } else {
                System.out.println("ℹ️ File not found in DEPLOY: " + deployFile.getAbsolutePath());
            }
            
            // ✅ CHỈ XÓA TỪ SOURCE NẾU ĐÃ APPROVED
            if ("approved".equals(status)) {
                System.out.println("📋 Recipe was APPROVED - deleting from SOURCE too");
                
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
                }
                
                sourcePath = sourcePath + File.separator + UPLOAD_DIRECTORY;
                File sourceFile = new File(sourcePath, fileName);
                
                if (sourceFile.exists() && sourceFile.isFile()) {
                    boolean deleted = sourceFile.delete();
                    if (deleted) {
                        System.out.println("✅ Deleted from SOURCE: " + sourceFile.getAbsolutePath());
                    } else {
                        System.err.println("⚠️ Failed to delete from SOURCE: " + sourceFile.getAbsolutePath());
                    }
                } else {
                    System.out.println("ℹ️ File not found in SOURCE: " + sourceFile.getAbsolutePath());
                }
                
            } else {
                System.out.println("ℹ️ Recipe status is '" + status + "' (not approved)");
                System.out.println("   → Not deleting from SOURCE (image was never copied there)");
            }
            
        } catch (Exception e) {
            System.err.println("⚠️ Error deleting image files:");
            e.printStackTrace();
            // Không throw exception - vì đã xóa được database rồi
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method is not supported. Use POST.");
    }
}