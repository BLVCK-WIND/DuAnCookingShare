package Model;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class yeuthichdao {
	private yeuthich extractFavorite(ResultSet rs) throws Exception {
        yeuthich yt = new yeuthich();
        yt.setFavoriteId(rs.getInt("favorite_id"));
        yt.setUserId(rs.getInt("user_id"));
        yt.setRecipeId(rs.getInt("recipe_id"));
        yt.setCreatedAt(rs.getTimestamp("created_at"));
        return yt;
    }

    // ============================================================
    // 1. ADD FAVORITE
    // ============================================================
    public boolean addFavorite(int userId, int recipeId) {
        String sql = "INSERT INTO Favorites (user_id, recipe_id) VALUES (?, ?)";

        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;

        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, recipeId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("❌ Lỗi thêm yêu thích: " + e.getMessage());
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }

        return false;
    }

    // ============================================================
    // 2. REMOVE FAVORITE
    // ============================================================
    public boolean removeFavorite(int userId, int recipeId) {
        String sql = "DELETE FROM Favorites WHERE user_id = ? AND recipe_id = ?";

        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;

        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, recipeId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("❌ Lỗi xóa yêu thích: " + e.getMessage());
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }

        return false;
    }

    // ============================================================
    // 3. CHECK FAVORITE
    // ============================================================
    public boolean isFavorite(int userId, int recipeId) {
        String sql = "SELECT 1 FROM Favorites WHERE user_id = ? AND recipe_id = ?";

        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, recipeId);
            rs = ps.executeQuery();

            return rs.next(); // có bản ghi = đã thích

        } catch (Exception e) {
            System.err.println("❌ Lỗi kiểm tra yêu thích: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }

        return false;
    }

    // ============================================================
    // 4. LIST FAVORITES OF USER (CHỈ FAVORITE RECORDS)
    // ============================================================
    public List<yeuthich> getFavoritesByUserId(int userId) {
        List<yeuthich> list = new ArrayList<>();

        String sql = "SELECT * FROM Favorites WHERE user_id = ? ORDER BY created_at DESC";

        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            while (rs.next()) list.add(extractFavorite(rs));

        } catch (Exception e) {
            System.err.println("❌ Lỗi lấy danh sách yêu thích: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }

        return list;
    }

    // ============================================================
    // 5. GET FAVORITE RECIPES WITH FULL INFO (ĐÃ LOẠI BỎ RATING)
    // ============================================================
    /**
     * Lấy danh sách công thức yêu thích của user với đầy đủ thông tin
     * JOIN với bảng Recipes, Categories, Users để lấy tất cả dữ liệu cần thiết
     * ✅ ĐÃ LOẠI BỎ các tham chiếu đến bảng Ratings
     */
    public List<congthuc> getFavoriteRecipes(int userId) {
        List<congthuc> list = new ArrayList<>();

        String sql = "SELECT " +
                " r.recipe_id, r.title, r.description, r.ingredients, r.instructions, " +
                " r.cooking_time, r.difficulty_level, r.servings, r.image_url, " +
                " r.category_id, c.category_name, " +
                " r.user_id, u.full_name AS author_name, " +
                " r.status, r.view_count, r.created_at, r.updated_at, " +
                " COUNT(f2.recipe_id) AS total_favorites " +
                "FROM Favorites f " +
                "JOIN Recipes r ON f.recipe_id = r.recipe_id " +
                "JOIN Categories c ON r.category_id = c.category_id " +
                "JOIN Users u ON r.user_id = u.user_id " +
                "LEFT JOIN Favorites f2 ON r.recipe_id = f2.recipe_id " +
                "WHERE f.user_id = ? " +
                "GROUP BY " +
                " r.recipe_id, r.title, r.description, r.ingredients, r.instructions, " +
                " r.cooking_time, r.difficulty_level, r.servings, r.image_url, " +
                " r.category_id, c.category_name, " +
                " r.user_id, u.full_name, " +
                " r.status, r.view_count, r.created_at, r.updated_at " +
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
                congthuc recipe = new congthuc();
                
                recipe.setRecipeId(rs.getInt("recipe_id"));
                recipe.setTitle(rs.getString("title"));
                recipe.setDescription(rs.getString("description"));
                recipe.setIngredients(rs.getString("ingredients"));
                recipe.setInstructions(rs.getString("instructions"));
                recipe.setCookingTime(rs.getInt("cooking_time"));
                recipe.setDifficultyLevel(rs.getString("difficulty_level"));
                recipe.setServings(rs.getInt("servings"));
                recipe.setImageUrl(rs.getString("image_url"));
                recipe.setCategoryId(rs.getInt("category_id"));
                recipe.setCategoryName(rs.getString("category_name"));
                recipe.setUserId(rs.getInt("user_id"));
                recipe.setAuthorName(rs.getString("author_name"));
                recipe.setStatus(rs.getString("status"));
                recipe.setViewCount(rs.getInt("view_count"));
                recipe.setCreatedAt(rs.getTimestamp("created_at"));
                recipe.setUpdatedAt(rs.getTimestamp("updated_at"));
                
                // Chỉ lấy số lượt yêu thích, không có rating
                recipe.setTotalFavorites(rs.getInt("total_favorites"));
                
                list.add(recipe);
            }

            System.out.println("✅ Đã lấy " + list.size() + " công thức yêu thích cho user " + userId);

        } catch (Exception e) {
            System.err.println("❌ Lỗi lấy công thức yêu thích: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }

        return list;
    }

    // ============================================================
    // 6. COUNT FAVORITES
    // ============================================================
    public int countFavoritesByRecipeId(int recipeId) {
        String sql = "SELECT COUNT(*) FROM Favorites WHERE recipe_id = ?";

        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setInt(1, recipeId);
            rs = ps.executeQuery();

            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            System.err.println("❌ Lỗi đếm yêu thích: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }

        return 0;
    }
}