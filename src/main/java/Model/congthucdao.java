package Model;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class congthucdao {
    
    private congthuc extractCongThuc(ResultSet rs) throws Exception {
        congthuc ct = new congthuc();
        ct.setRecipeId(rs.getInt("recipe_id"));
        ct.setUserId(rs.getInt("user_id"));
        ct.setCategoryId(rs.getInt("category_id"));
        ct.setTitle(rs.getString("title"));
        ct.setDescription(rs.getString("description"));
        ct.setImageUrl(rs.getString("image_url"));
        ct.setCookingTime(rs.getInt("cooking_time"));
        ct.setDifficultyLevel(rs.getString("difficulty_level"));
        ct.setServings(rs.getInt("servings"));
        ct.setIngredients(rs.getString("ingredients"));
        ct.setInstructions(rs.getString("instructions"));
        ct.setNotes(rs.getString("notes"));
        ct.setStatus(rs.getString("status"));
        ct.setRejectionReason(rs.getString("rejection_reason"));
        ct.setViewCount(rs.getInt("view_count"));
        ct.setCreatedAt(rs.getTimestamp("created_at"));
        ct.setUpdatedAt(rs.getTimestamp("updated_at"));
        ct.setApprovedAt(rs.getTimestamp("approved_at"));
        
        try { ct.setCategoryName(rs.getString("category_name")); } catch (Exception ignored) {}
        try { ct.setAuthorName(rs.getString("author_name")); } catch (Exception ignored) {}
        try { ct.setAuthorAvatar(rs.getString("author_avatar")); } catch (Exception ignored) {}
        try { ct.setTotalFavorites(rs.getInt("total_favorites")); } catch (Exception ignored) {}
        
        return ct;
    }
    
    // ========= ✅ MỚI: Lấy TẤT CẢ công thức (Admin) - Sắp xếp theo thứ tự ưu tiên =========
    /**
     * Lấy tất cả công thức cho Admin
     * Thứ tự ưu tiên: pending -> approved -> rejected
     * Trong mỗi nhóm status, sắp xếp theo created_at DESC (mới nhất trước)
     */
    public List<congthuc> getAllRecipesForAdmin() {
        List<congthuc> list = new ArrayList<>();
        String sql = "SELECT r.*, c.category_name, u.full_name as author_name, u.avatar as author_avatar, " +
                     "ISNULL(COUNT(DISTINCT f.favorite_id), 0) as total_favorites " +
                     "FROM Recipes r " +
                     "JOIN Categories c ON r.category_id = c.category_id " +
                     "JOIN Users u ON r.user_id = u.user_id " +
                     "LEFT JOIN Favorites f ON r.recipe_id = f.recipe_id " +
                     "GROUP BY r.recipe_id, r.user_id, r.category_id, r.title, r.description, " +
                     "r.image_url, r.cooking_time, r.difficulty_level, r.servings, " +
                     "r.ingredients, r.instructions, r.notes, r.status, r.rejection_reason, " +
                     "r.view_count, r.created_at, r.updated_at, r.approved_at, r.approved_by, " +
                     "c.category_name, u.full_name, u.avatar " +
                     "ORDER BY " +
                     "  CASE r.status " +
                     "    WHEN 'pending' THEN 1 " +      // Chờ duyệt ưu tiên cao nhất
                     "    WHEN 'approved' THEN 2 " +     // Đã duyệt thứ hai
                     "    WHEN 'rejected' THEN 3 " +     // Đã từ chối cuối cùng
                     "    ELSE 4 " +
                     "  END, " +
                     "  r.created_at DESC";               // Trong mỗi nhóm: mới nhất trước
        
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(extractCongThuc(rs));
            }
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi lấy tất cả công thức: " + e.getMessage());
            
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
        
        return list;
    }
    
    // ========= ✅ MỚI: Lấy công thức theo Status cụ thể (Admin) =========
    /**
     * Lấy công thức theo status cụ thể
     * @param status "pending", "approved", hoặc "rejected"
     */
    public List<congthuc> getRecipesByStatus(String status) {
        List<congthuc> list = new ArrayList<>();
        String sql = "SELECT r.*, c.category_name, u.full_name as author_name, u.avatar as author_avatar, " +
                     "ISNULL(COUNT(DISTINCT f.favorite_id), 0) as total_favorites " +
                     "FROM Recipes r " +
                     "JOIN Categories c ON r.category_id = c.category_id " +
                     "JOIN Users u ON r.user_id = u.user_id " +
                     "LEFT JOIN Favorites f ON r.recipe_id = f.recipe_id " +
                     "WHERE r.status = ? " +
                     "GROUP BY r.recipe_id, r.user_id, r.category_id, r.title, r.description, " +
                     "r.image_url, r.cooking_time, r.difficulty_level, r.servings, " +
                     "r.ingredients, r.instructions, r.notes, r.status, r.rejection_reason, " +
                     "r.view_count, r.created_at, r.updated_at, r.approved_at, r.approved_by, " +
                     "c.category_name, u.full_name, u.avatar " +
                     "ORDER BY r.created_at DESC";
        
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setString(1, status);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(extractCongThuc(rs));
            }
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi lấy công thức theo status: " + e.getMessage());
            
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
        
        return list;
    }
    
    // ========= ✅ MỚI: Đếm số công thức theo từng status =========
    /**
     * Đếm số lượng công thức theo status
     */
    public int countRecipesByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM Recipes WHERE status = ?";
        
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setString(1, status);
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
    
    // ========= ✅ MỚI: Đếm tổng số công thức =========
    public int countTotalRecipes() {
        String sql = "SELECT COUNT(*) FROM Recipes";
        
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi đếm tổng công thức: " + e.getMessage());
            
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
        
        return 0;
    }
    
    // ========= READ - Lấy tất cả đã duyệt (Cho User) =========
    public List<congthuc> getAllApprovedCongThuc() {
        List<congthuc> list = new ArrayList<>();
        String sql = "SELECT r.*, c.category_name, u.full_name as author_name, u.avatar as author_avatar, " +
                     "ISNULL(COUNT(DISTINCT f.favorite_id), 0) as total_favorites " +
                     "FROM Recipes r " +
                     "JOIN Categories c ON r.category_id = c.category_id " +
                     "JOIN Users u ON r.user_id = u.user_id " +
                     "LEFT JOIN Favorites f ON r.recipe_id = f.recipe_id " +
                     "WHERE r.status = 'approved' " +
                     "GROUP BY r.recipe_id, r.user_id, r.category_id, r.title, r.description, " +
                     "r.image_url, r.cooking_time, r.difficulty_level, r.servings, " +
                     "r.ingredients, r.instructions, r.notes, r.status, r.rejection_reason, " +
                     "r.view_count, r.created_at, r.updated_at, r.approved_at, r.approved_by, " +
                     "c.category_name, u.full_name, u.avatar " +
                     "ORDER BY r.created_at DESC";
        
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(extractCongThuc(rs));
            }
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi lấy danh sách công thức: " + e.getMessage());
            
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
        
        return list;
    }
    
    // ========= CREATE =========
    public int addCongThuc(congthuc ct) {
        String sql = "INSERT INTO Recipes (user_id, category_id, title, description, image_url, " +
                     "cooking_time, difficulty_level, servings, ingredients, instructions, notes, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'pending')";
        
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            ps.setInt(1, ct.getUserId());
            ps.setInt(2, ct.getCategoryId());
            ps.setString(3, ct.getTitle());
            ps.setString(4, ct.getDescription());
            ps.setString(5, ct.getImageUrl());
            ps.setInt(6, ct.getCookingTime());
            ps.setString(7, ct.getDifficultyLevel());
            ps.setInt(8, ct.getServings());
            ps.setString(9, ct.getIngredients());
            ps.setString(10, ct.getInstructions());
            ps.setString(11, ct.getNotes());
            
            int affected = ps.executeUpdate();
            
            if (affected > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) return rs.getInt(1);
            }
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi thêm công thức: " + e.getMessage());
            
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
        
        return -1;
    }
    
    // ========= READ - Lấy theo ID =========
    public congthuc getCongThucById(int recipeId) {
        String sql = "SELECT r.*, c.category_name, u.full_name as author_name, u.avatar as author_avatar, " +
                     "ISNULL(COUNT(DISTINCT f.favorite_id), 0) as total_favorites " +
                     "FROM Recipes r " +
                     "JOIN Categories c ON r.category_id = c.category_id " +
                     "JOIN Users u ON r.user_id = u.user_id " +
                     "LEFT JOIN Favorites f ON r.recipe_id = f.recipe_id " +
                     "WHERE r.recipe_id = ? " +
                     "GROUP BY r.recipe_id, r.user_id, r.category_id, r.title, r.description, " +
                     "r.image_url, r.cooking_time, r.difficulty_level, r.servings, " +
                     "r.ingredients, r.instructions, r.notes, r.status, r.rejection_reason, " +
                     "r.view_count, r.created_at, r.updated_at, r.approved_at, r.approved_by, " +
                     "c.category_name, u.full_name, u.avatar";
        
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setInt(1, recipeId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                congthuc recipe = extractCongThuc(rs);
                
                // 🔥 LOGIC MỚI: CHỈ TĂNG VIEW COUNT KHI STATUS = 'approved'
                if ("approved".equals(recipe.getStatus())) {
                    increaseViewCount(recipeId);
                    System.out.println("✅ View count increased for approved recipe #" + recipeId);
                } else {
                    System.out.println("⏸️ View count NOT increased - recipe #" + recipeId + " status: " + recipe.getStatus());
                }
                
                return recipe;
            }
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi lấy công thức theo ID: " + e.getMessage());
            
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
        
        return null;
    }
    
    // ========= READ - Lấy của user =========
    public List<congthuc> getCongThucByUserId(int userId) {
        List<congthuc> list = new ArrayList<>();
        String sql = "SELECT r.*, c.category_name, u.full_name as author_name, u.avatar as author_avatar, " +
                     "ISNULL(COUNT(DISTINCT f.favorite_id), 0) as total_favorites " +
                     "FROM Recipes r " +
                     "JOIN Categories c ON r.category_id = c.category_id " +
                     "JOIN Users u ON r.user_id = u.user_id " +
                     "LEFT JOIN Favorites f ON r.recipe_id = f.recipe_id " +
                     "WHERE r.user_id = ? " +
                     "GROUP BY r.recipe_id, r.user_id, r.category_id, r.title, r.description, " +
                     "r.image_url, r.cooking_time, r.difficulty_level, r.servings, " +
                     "r.ingredients, r.instructions, r.notes, r.status, r.rejection_reason, " +
                     "r.view_count, r.created_at, r.updated_at, r.approved_at, r.approved_by, " +
                     "c.category_name, u.full_name, u.avatar " +
                     "ORDER BY r.created_at DESC";
        
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(extractCongThuc(rs));
            }
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi lấy công thức của user: " + e.getMessage());
            
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
        
        return list;
    }
    
    // ========= SEARCH =========
    public List<congthuc> searchCongThucAdvanced(String keyword) {
        List<congthuc> list = new ArrayList<>();
        String sql = "SELECT r.*, c.category_name, u.full_name as author_name, u.avatar as author_avatar, " +
                     "ISNULL(COUNT(DISTINCT f.favorite_id), 0) as total_favorites " +
                     "FROM Recipes r " +
                     "JOIN Categories c ON r.category_id = c.category_id " +
                     "JOIN Users u ON r.user_id = u.user_id " +
                     "LEFT JOIN Favorites f ON r.recipe_id = f.recipe_id " +
                     "WHERE r.status = 'approved' AND (" +
                     "r.title LIKE ? OR " +
                     "r.description LIKE ? OR " +
                     "r.ingredients LIKE ? OR " +
                     "c.category_name LIKE ?" +
                     ") " +
                     "GROUP BY r.recipe_id, r.user_id, r.category_id, r.title, r.description, " +
                     "r.image_url, r.cooking_time, r.difficulty_level, r.servings, " +
                     "r.ingredients, r.instructions, r.notes, r.status, r.rejection_reason, " +
                     "r.view_count, r.created_at, r.updated_at, r.approved_at, r.approved_by, " +
                     "c.category_name, u.full_name, u.avatar " +
                     "ORDER BY r.created_at DESC";
        
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);
            
            rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(extractCongThuc(rs));
            }
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi tìm kiếm công thức: " + e.getMessage());
            
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
        
        return list;
    }
    
    // ========= GET BY CATEGORY =========
    public List<congthuc> getCongThucByCategory(int categoryId) {
        List<congthuc> list = new ArrayList<>();
        String sql = "SELECT r.*, c.category_name, u.full_name as author_name, u.avatar as author_avatar, " +
                     "ISNULL(COUNT(DISTINCT f.favorite_id), 0) as total_favorites " +
                     "FROM Recipes r " +
                     "JOIN Categories c ON r.category_id = c.category_id " +
                     "JOIN Users u ON r.user_id = u.user_id " +
                     "LEFT JOIN Favorites f ON r.recipe_id = f.recipe_id " +
                     "WHERE r.category_id = ? AND r.status = 'approved' " +
                     "GROUP BY r.recipe_id, r.user_id, r.category_id, r.title, r.description, " +
                     "r.image_url, r.cooking_time, r.difficulty_level, r.servings, " +
                     "r.ingredients, r.instructions, r.notes, r.status, r.rejection_reason, " +
                     "r.view_count, r.created_at, r.updated_at, r.approved_at, r.approved_by, " +
                     "c.category_name, u.full_name, u.avatar " +
                     "ORDER BY r.created_at DESC";
        
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setInt(1, categoryId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(extractCongThuc(rs));
            }
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi lấy công thức theo danh mục: " + e.getMessage());
            
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
        
        return list;
    }
    
    // ========= GET LATEST =========
    public List<congthuc> getLatestRecipes(int limit) {
        List<congthuc> list = new ArrayList<>();
        String sql = "SELECT TOP (?) r.*, c.category_name, u.full_name as author_name, u.avatar as author_avatar, " +
                     "ISNULL(COUNT(DISTINCT f.favorite_id), 0) as total_favorites " +
                     "FROM Recipes r " +
                     "JOIN Categories c ON r.category_id = c.category_id " +
                     "JOIN Users u ON r.user_id = u.user_id " +
                     "LEFT JOIN Favorites f ON r.recipe_id = f.recipe_id " +
                     "WHERE r.status = 'approved' " +
                     "GROUP BY r.recipe_id, r.user_id, r.category_id, r.title, r.description, " +
                     "r.image_url, r.cooking_time, r.difficulty_level, r.servings, " +
                     "r.ingredients, r.instructions, r.notes, r.status, r.rejection_reason, " +
                     "r.view_count, r.created_at, r.updated_at, r.approved_at, r.approved_by, " +
                     "c.category_name, u.full_name, u.avatar " +
                     "ORDER BY r.created_at DESC";

        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setInt(1, limit);
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(extractCongThuc(rs));
            }

        } catch (Exception e) {
            System.err.println("❌ Lỗi lấy công thức mới nhất: " + e.getMessage());

        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }

        return list;
    }
    
    // ========= UPDATE =========
    public boolean updateCongThuc(congthuc ct) {
        String sql = "UPDATE Recipes SET category_id = ?, title = ?, description = ?, " +
                     "image_url = ?, cooking_time = ?, difficulty_level = ?, servings = ?, " +
                     "ingredients = ?, instructions = ?, notes = ?, updated_at = GETDATE() " +
                     "WHERE recipe_id = ?";

        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;

        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);

            ps.setInt(1, ct.getCategoryId());
            ps.setString(2, ct.getTitle());
            ps.setString(3, ct.getDescription());
            ps.setString(4, ct.getImageUrl());
            ps.setInt(5, ct.getCookingTime());
            ps.setString(6, ct.getDifficultyLevel());
            ps.setInt(7, ct.getServings());
            ps.setString(8, ct.getIngredients());
            ps.setString(9, ct.getInstructions());
            ps.setString(10, ct.getNotes());
            ps.setInt(11, ct.getRecipeId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("❌ Lỗi update công thức: " + e.getMessage());
            return false;

        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
    }
    
    // ========= DELETE =========
    public boolean deleteCongThuc(int recipeId) {
        String sql = "DELETE FROM Recipes WHERE recipe_id = ?";

        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;

        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setInt(1, recipeId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("❌ Lỗi xóa công thức: " + e.getMessage());
            return false;

        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
    }
    
    // ========= APPROVE =========
    public boolean approveRecipe(int recipeId, int adminId) {
        String sql = "UPDATE Recipes SET status = 'approved', approved_at = GETDATE(), " +
                     "approved_by = ? WHERE recipe_id = ?";

        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;

        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);

            ps.setInt(1, adminId);
            ps.setInt(2, recipeId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("❌ Lỗi duyệt công thức: " + e.getMessage());
            return false;

        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
    }
    
    // ========= REJECT =========
    public boolean rejectRecipe(int recipeId, String reason, int adminId) {
        String sql = "UPDATE Recipes SET status = 'rejected', rejection_reason = ?, " +
                     "approved_by = ?, approved_at = GETDATE() WHERE recipe_id = ?";

        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;

        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);

            ps.setString(1, reason);
            ps.setInt(2, adminId);
            ps.setInt(3, recipeId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("❌ Lỗi từ chối công thức: " + e.getMessage());
            return false;

        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
    }

    // ========= HELPER =========
    private void increaseViewCount(int recipeId) {
        String sql = "UPDATE Recipes SET view_count = view_count + 1 WHERE recipe_id = ?";

        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;

        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setInt(1, recipeId);
            ps.executeUpdate();

        } catch (Exception e) {
            System.err.println("❌ Lỗi tăng lượt xem: " + e.getMessage());

        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
    }
    
    
    
    // ========= ✅ SEARCH RECIPES FOR ADMIN - Tìm kiếm công thức theo nhiều tiêu chí =========
    /**
     * Tìm kiếm công thức cho Admin theo:
     * - recipe_id (mã công thức)
     * - title (tên công thức)
     * - category_id (mã danh mục)
     * - category_name (tên danh mục)
     * 
     * @param keyword Từ khóa tìm kiếm
     * @param statusFilter Filter theo trạng thái ("all", "pending", "approved", "rejected")
     * @param categoryFilter Filter theo category_id (null = tất cả)
     * @return Danh sách công thức khớp với tiêu chí
     */
    public List<congthuc> searchRecipesForAdmin(String keyword, String statusFilter, Integer categoryFilter) {
        List<congthuc> list = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT r.*, c.category_name, u.full_name as author_name, u.avatar as author_avatar, ");
        sql.append("ISNULL(COUNT(DISTINCT f.favorite_id), 0) as total_favorites ");
        sql.append("FROM Recipes r ");
        sql.append("JOIN Categories c ON r.category_id = c.category_id ");
        sql.append("JOIN Users u ON r.user_id = u.user_id ");
        sql.append("LEFT JOIN Favorites f ON r.recipe_id = f.recipe_id ");
        sql.append("WHERE 1=1 ");
        
        // ✅ Search keyword
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (CAST(r.recipe_id AS NVARCHAR) LIKE ? ");
            sql.append("OR r.title LIKE ? ");
            sql.append("OR CAST(c.category_id AS NVARCHAR) LIKE ? ");
            sql.append("OR c.category_name LIKE ?) ");
        }
        
        // ✅ Filter by status
        if (statusFilter != null && !statusFilter.equals("all")) {
            sql.append("AND r.status = ? ");
        }
        
        // ✅ Filter by category
        if (categoryFilter != null) {
            sql.append("AND r.category_id = ? ");
        }
        
        sql.append("GROUP BY r.recipe_id, r.user_id, r.category_id, r.title, r.description, ");
        sql.append("r.image_url, r.cooking_time, r.difficulty_level, r.servings, ");
        sql.append("r.ingredients, r.instructions, r.notes, r.status, r.rejection_reason, ");
        sql.append("r.view_count, r.created_at, r.updated_at, r.approved_at, r.approved_by, ");
        sql.append("c.category_name, u.full_name, u.avatar ");
        sql.append("ORDER BY ");
        sql.append("  CASE r.status ");
        sql.append("    WHEN 'pending' THEN 1 ");
        sql.append("    WHEN 'approved' THEN 2 ");
        sql.append("    WHEN 'rejected' THEN 3 ");
        sql.append("    ELSE 4 ");
        sql.append("  END, ");
        sql.append("  r.created_at DESC");
        
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            
            // Set keyword parameters
            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchPattern = "%" + keyword.trim() + "%";
                ps.setString(paramIndex++, searchPattern);  // recipe_id
                ps.setString(paramIndex++, searchPattern);  // title
                ps.setString(paramIndex++, searchPattern);  // category_id
                ps.setString(paramIndex++, searchPattern);  // category_name
            }
            
            // Set status parameter
            if (statusFilter != null && !statusFilter.equals("all")) {
                ps.setString(paramIndex++, statusFilter);
            }
            
            // Set category parameter
            if (categoryFilter != null) {
                ps.setInt(paramIndex++, categoryFilter);
            }
            
            rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(extractCongThuc(rs));
            }
            
            System.out.println("ℹ️ Tìm thấy " + list.size() + " công thức với keyword: " + keyword + 
                             ", status: " + statusFilter + ", category: " + categoryFilter);
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi tìm kiếm công thức: " + e.getMessage());
            e.printStackTrace();
            
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
        
        return list;
    }
}