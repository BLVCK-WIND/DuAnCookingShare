package Model;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class cacbuocnaudao {
	private cacbuocnau extractStep(ResultSet rs) throws Exception {
        cacbuocnau step = new cacbuocnau();
        step.setStepId(rs.getInt("step_id"));
        step.setRecipeId(rs.getInt("recipe_id"));
        step.setStepNumber(rs.getInt("step_number"));
        step.setDescription(rs.getString("step_description"));
        return step;
    }

    // CREATE
    public boolean addStep(cacbuocnau step) {
        String sql = "INSERT INTO Recipe_Steps (recipe_id, step_number, step_description) VALUES (?, ?, ?)";

        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;

        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);

            ps.setInt(1, step.getRecipeId());
            ps.setInt(2, step.getStepNumber());
            ps.setString(3, step.getDescription());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("❌ Lỗi thêm bước nấu: " + e.getMessage());
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
        return false;
    }

    // READ: lấy steps theo recipe_id
    public List<cacbuocnau> getStepsByRecipeId(int recipeId) {
        List<cacbuocnau> list = new ArrayList<>();

        String sql = "SELECT * FROM Recipe_Steps WHERE recipe_id = ? ORDER BY step_number ASC";

        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setInt(1, recipeId);
            rs = ps.executeQuery();

            while (rs.next()) list.add(extractStep(rs));

        } catch (Exception e) {
            System.err.println("❌ Lỗi lấy các bước nấu: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }

        return list;
    }

    // UPDATE
    public boolean updateStep(cacbuocnau step) {
        String sql = "UPDATE Recipe_Steps SET step_number = ?, step_description = ?, updated_at = GETDATE() WHERE step_id = ?";

        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;

        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);

            ps.setInt(1, step.getStepNumber());
            ps.setString(2, step.getDescription());
            ps.setInt(3, step.getStepId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("❌ Lỗi cập nhật bước: " + e.getMessage());
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }

        return false;
    }

    // DELETE 1 bước
    public boolean deleteStep(int stepId) {
        String sql = "DELETE FROM Recipe_Steps WHERE step_id = ?";

        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;

        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setInt(1, stepId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("❌ Lỗi xóa bước: " + e.getMessage());
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }

        return false;
    }

    // DELETE ALL steps của recipe (khi admin xoá công thức)
    public boolean deleteStepsByRecipeId(int recipeId) {
        String sql = "DELETE FROM Recipe_Steps WHERE recipe_id = ?";

        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;

        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setInt(1, recipeId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("❌ Lỗi xóa tất cả bước: " + e.getMessage());
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }

        return false;
    }

}
