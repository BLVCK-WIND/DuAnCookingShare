package Model;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class danhmucdao {
    // ========= Helper: Convert ResultSet -> danhmuc object =========
    private danhmuc extractDanhMuc(ResultSet rs) throws Exception {
        danhmuc dm = new danhmuc();
        dm.setCategoryId(rs.getInt("category_id"));
        dm.setCategoryName(rs.getString("category_name"));
        dm.setDescription(rs.getString("description"));
        dm.setImageUrl(rs.getString("image_url"));  // ✅ THÊM MỚI: Lấy image_url
        return dm;
    }
    
    // ========= CREATE - Thêm danh mục mới =========
    /**
     * Thêm danh mục mới (chỉ admin mới được gọi)
     * @param dm Object danhmuc cần thêm
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean addDanhMuc(danhmuc dm) {
        // ✅ CẬP NHẬT: Thêm image_url vào câu SQL
        String sql = "INSERT INTO Categories (category_name, description, image_url) VALUES (?, ?, ?)";
        
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            
            ps.setString(1, dm.getCategoryName());
            ps.setString(2, dm.getDescription());
            ps.setString(3, dm.getImageUrl());  // ✅ THÊM MỚI
            
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi thêm danh mục: " + e.getMessage());
            return false;
            
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
    }
    
    // ========= READ - Lấy tất cả danh mục =========
    /**
     * Lấy tất cả danh mục (dùng để hiển thị dropdown, menu...)
     * @return List các danh mục, sắp xếp theo tên
     */
    public List<danhmuc> getAllDanhMuc() {
        List<danhmuc> list = new ArrayList<>();
        // ✅ CẬP NHẬT: Thêm image_url vào SELECT
        String sql = "SELECT category_id, category_name, description, image_url FROM Categories ORDER BY category_name";
        
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(extractDanhMuc(rs));
            }
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi lấy danh sách danh mục: " + e.getMessage());
            
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
        
        return list;
    }
    
    // ========= READ - Lấy danh mục theo ID =========
    /**
     * Lấy chi tiết một danh mục theo ID
     * @param categoryId ID danh mục
     * @return Object danhmuc hoặc null nếu không tìm thấy
     */
    public danhmuc getDanhMucById(int categoryId) {
        // ✅ CẬP NHẬT: Thêm image_url vào SELECT
        String sql = "SELECT category_id, category_name, description, image_url FROM Categories WHERE category_id = ?";
        
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setInt(1, categoryId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return extractDanhMuc(rs);
            }
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi lấy danh mục theo ID: " + e.getMessage());
            
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
        
        return null;
    }
    
    // ========= UPDATE - Cập nhật danh mục =========
    /**
     * Cập nhật thông tin danh mục (chỉ admin)
     * @param dm Object danhmuc đã được cập nhật
     * @return true nếu thành công
     */
    public boolean updateDanhMuc(danhmuc dm) {
        // ✅ CẬP NHẬT: Thêm image_url vào UPDATE
        String sql = "UPDATE Categories SET category_name = ?, description = ?, image_url = ? WHERE category_id = ?";
        
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            
            ps.setString(1, dm.getCategoryName());
            ps.setString(2, dm.getDescription());
            ps.setString(3, dm.getImageUrl());  // ✅ THÊM MỚI
            ps.setInt(4, dm.getCategoryId());
            
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi cập nhật danh mục: " + e.getMessage());
            
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
        
        return false;
    }
    
    // ========= DELETE - Xóa danh mục =========
    /**
     * Xóa danh mục (chỉ admin)
     * LƯU Ý: Không thể xóa nếu còn công thức thuộc danh mục này
     * @param categoryId ID danh mục cần xóa
     * @return true nếu thành công
     */
    public boolean deleteDanhMuc(int categoryId) {
        String sql = "DELETE FROM Categories WHERE category_id = ?";
        
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setInt(1, categoryId);
            
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi xóa danh mục: " + e.getMessage());
            System.err.println("💡 Có thể còn công thức thuộc danh mục này!");
            
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
        
        return false;
    }
    
    // ========= Kiểm tra tên danh mục đã tồn tại =========
    /**
     * Kiểm tra xem tên danh mục đã tồn tại chưa (tránh trùng lặp)
     * @param categoryName Tên danh mục cần check
     * @return true nếu đã tồn tại
     */
    public boolean isCategoryNameExist(String categoryName) {
        String sql = "SELECT 1 FROM Categories WHERE category_name = ?";
        
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setString(1, categoryName);
            rs = ps.executeQuery();
            
            return rs.next();
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi kiểm tra tên danh mục: " + e.getMessage());
            
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
        
        return false;
    }
    
    // ========= Đếm số công thức trong danh mục =========
    /**
     * Đếm số công thức thuộc một danh mục
     * Dùng để hiển thị "Món Chay (15 công thức)"
     * @param categoryId ID danh mục
     * @return Số công thức
     */
    public int countRecipesByCategory(int categoryId) {
        String sql = "SELECT COUNT(*) FROM Recipes WHERE category_id = ? AND status = 'approved'";
        
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setInt(1, categoryId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi đếm công thức: " + e.getMessage());
            
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
        
        return 0;
    }
    
    // ========= ✅ THÊM MỚI: Cập nhật image_url cho danh mục =========
    /**
     * Cập nhật chỉ image_url cho một danh mục
     * @param categoryId ID danh mục
     * @param imageUrl URL ảnh mới
     * @return true nếu thành công
     */
    public boolean updateCategoryImage(int categoryId, String imageUrl) {
        String sql = "UPDATE Categories SET image_url = ? WHERE category_id = ?";
        
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            
            ps.setString(1, imageUrl);
            ps.setInt(2, categoryId);
            
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi cập nhật ảnh danh mục: " + e.getMessage());
            return false;
            
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
    }
    
    // ========= ✅ THÊM MỚI: Lấy danh mục có ảnh =========
    /**
     * Lấy các danh mục có ảnh (để hiển thị trên trang chủ)
     * @return List danh mục có image_url không null
     */
    public List<danhmuc> getCategoriesWithImages() {
        List<danhmuc> list = new ArrayList<>();
        String sql = "SELECT category_id, category_name, description, image_url " +
                     "FROM Categories " +
                     "WHERE image_url IS NOT NULL " +
                     "ORDER BY category_name";
        
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(extractDanhMuc(rs));
            }
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi lấy danh mục có ảnh: " + e.getMessage());
            
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
        
        return list;
    }
    
    // ========= ✅ SEARCH CATEGORIES - Tìm kiếm danh mục theo mã hoặc tên =========
    /**
     * Tìm kiếm danh mục theo category_id hoặc category_name
     * @param keyword Từ khóa tìm kiếm (có thể là mã số hoặc tên)
     * @return Danh sách danh mục khớp với từ khóa
     */
    public List<danhmuc> searchCategories(String keyword) {
        List<danhmuc> list = new ArrayList<>();
        
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllDanhMuc();
        }
        
        String sql = "SELECT category_id, category_name, description, image_url " +
                     "FROM Categories " +
                     "WHERE CAST(category_id AS CHAR) LIKE ? " +
                     "   OR category_name LIKE ? " +
                     "ORDER BY category_name";
        
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            
            String searchPattern = "%" + keyword.trim() + "%";
            ps.setString(1, searchPattern);  // Search by category_id
            ps.setString(2, searchPattern);  // Search by category_name
            
            rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(extractDanhMuc(rs));
            }
            
            System.out.println("ℹ️ Tìm thấy " + list.size() + " danh mục với keyword: " + keyword);
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi tìm kiếm danh mục: " + e.getMessage());
            e.printStackTrace();
            
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
        
        return list;
    }
}