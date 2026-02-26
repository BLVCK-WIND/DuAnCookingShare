package Model;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class thongkedao {
	
	private int getCount(String sql) {
        ketnoidao kn = new ketnoidao();
        try {
            kn.ketnoi();
            PreparedStatement ps = kn.cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            System.err.println("❌ Lỗi thống kê: " + e.getMessage());
        }
        return 0;
    }

    // ======= 1. Tổng số công thức =======
    public int countTotalRecipes() {
        return getCount("SELECT COUNT(*) FROM Recipes");
    }

    // ======= 2. Tổng số user =======
    public int countTotalUsers() {
        return getCount("SELECT COUNT(*) FROM Users");
    }

    // ======= 3. Số công thức đăng trong 7 ngày gần nhất =======
    public int countRecipesLast7Days() {
        return getCount("""
            SELECT COUNT(*) 
            FROM Recipes 
            WHERE created_at >= DATEADD(day, -7, GETDATE())
        """);
    }

    // ======= Helper: dùng chung để chuyển ResultSet -> congthuc =======
    private congthuc extractCongThuc(ResultSet rs) throws Exception {
        congthuc ct = new congthuc();

        ct.setRecipeId(rs.getInt("recipe_id"));
        ct.setTitle(rs.getString("title"));
        ct.setImageUrl(rs.getString("image_url"));
        ct.setViewCount(rs.getInt("view_count"));

        // ✅ BẮT BUỘC PHẢI CÓ
        ct.setCookingTime(rs.getInt("cooking_time"));
        ct.setDifficultyLevel(rs.getString("difficulty_level"));

        // Optional
        try { ct.setCategoryName(rs.getString("category_name")); } catch (Exception ignored) {}
        try { ct.setAuthorName(rs.getString("author_name")); } catch (Exception ignored) {}
        try { ct.setTotalFavorites(rs.getInt("total_favorites")); } catch (Exception ignored) {}

        return ct;
    }


    // ======= 4. Top 5 công thức xem nhiều nhất =======
    public List<congthuc> getTop5MostViewed() {
        List<congthuc> list = new ArrayList<>();

        String sql = """
            SELECT TOP 5
			    r.recipe_id,
			    r.title,
			    r.image_url,
			    r.view_count,
			    r.cooking_time,
			    r.difficulty_level,
			    c.category_name,
			    u.full_name AS author_name
            FROM Recipes r
            JOIN Categories c ON r.category_id = c.category_id
            JOIN Users u ON r.user_id = u.user_id
            WHERE r.status = 'approved'
            ORDER BY r.view_count DESC
        """;

        ketnoidao kn = new ketnoidao();

        try {
            kn.ketnoi();
            PreparedStatement ps = kn.cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) list.add(extractCongThuc(rs));

        } catch (Exception e) {
            System.err.println("❌ Lỗi lấy top view: " + e.getMessage());
        }

        return list;
    }

    // ======= 5. Top 5 công thức được yêu thích nhất =======
    public List<congthuc> getTop5MostFavorite() {
        List<congthuc> list = new ArrayList<>();

        String sql = """
				    SELECT TOP 5
					    r.recipe_id,
					    r.title,
					    r.image_url,
					    r.view_count,
					    r.cooking_time,
					    r.difficulty_level,
					    c.category_name,
					    u.full_name AS author_name,
					    COUNT(f.favorite_id) AS total_favorites
					FROM Favorites f
					JOIN Recipes r ON f.recipe_id = r.recipe_id
					JOIN Categories c ON r.category_id = c.category_id
					JOIN Users u ON r.user_id = u.user_id
					GROUP BY 
					    r.recipe_id,
					    r.title,
					    r.image_url,
					    r.view_count,
					    r.cooking_time,
					    r.difficulty_level,
					    c.category_name,
					    u.full_name
					ORDER BY total_favorites DESC

        """;

        ketnoidao kn = new ketnoidao();

        try {
            kn.ketnoi();
            PreparedStatement ps = kn.cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) list.add(extractCongThuc(rs));

        } catch (Exception e) {
            System.err.println("❌ Lỗi lấy top yêu thích: " + e.getMessage());
        }

        return list;
    }

    // ======= 6. Top 5 công thức được xem nhiều nhất (thay thế cho rating) =======
    public List<congthuc> getTop5HighestRated() {
        // ✅ Thay vì lấy theo rating, giờ lấy theo lượt xem (view_count)
        // hoặc có thể lấy theo lượt yêu thích
        List<congthuc> list = new ArrayList<>();

        String sql = """
            SELECT TOP 5
			    r.recipe_id,
			    r.title,
			    r.image_url,
			    r.view_count,
			    r.cooking_time,
			    r.difficulty_level,
			    c.category_name,
			    u.full_name AS author_name,
			    COUNT(f.favorite_id) AS total_favorites
			FROM Recipes r
			JOIN Categories c ON r.category_id = c.category_id
			JOIN Users u ON r.user_id = u.user_id
			LEFT JOIN Favorites f ON r.recipe_id = f.recipe_id
			WHERE r.status = 'approved'
			GROUP BY
			    r.recipe_id,
			    r.title,
			    r.image_url,
			    r.view_count,
			    r.cooking_time,
			    r.difficulty_level,
			    c.category_name,
			    u.full_name
			ORDER BY r.view_count DESC, total_favorites DESC

        """;

        ketnoidao kn = new ketnoidao();

        try {
            kn.ketnoi();
            PreparedStatement ps = kn.cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) list.add(extractCongThuc(rs));

        } catch (Exception e) {
            System.err.println("❌ Lỗi lấy top công thức: " + e.getMessage());
        }

        return list;
    }

}