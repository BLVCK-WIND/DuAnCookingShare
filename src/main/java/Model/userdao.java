package Model;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class userdao {
    
    // ========= Helper: Convert ResultSet -> user object =========
    private user extractUser(ResultSet rs, boolean includePassword) throws SQLException {
        user u = new user();
        u.setUserId(rs.getInt("user_id"));
        u.setUsername(rs.getString("username"));
        if (includePassword) {
            u.setPassword(rs.getString("password"));
        }
        u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setAvatar(rs.getString("avatar"));
        u.setAdmin(rs.getBoolean("is_admin"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        return u;
    }


    // ========= CREATE - Register user =========
    public boolean registerUser(user user) {
        String sql = "INSERT INTO Users (username, password, full_name, email, avatar, is_admin) VALUES (?, ?, ?, ?, ?, ?)";
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());  // Password đã hash từ Servlet
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getAvatar() != null ? user.getAvatar() : "avatar1");
            ps.setBoolean(6, user.isAdmin());
            
            int result = ps.executeUpdate();
            if (result > 0) {
                System.out.println("✅ User registered: " + user.getUsername());
            }
            return result > 0;
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi đăng ký: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
    }

    // ========= READ - Login =========
    public user login(String username, String hashedPassword) {
        String sql = "SELECT * FROM Users WHERE username = ? AND password = ?";
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, hashedPassword);  // So sánh hash với hash trong DB
            rs = ps.executeQuery();
            
            if (rs.next()) {
                user u = extractUser(rs, true);
                System.out.println("✅ Login successful: " + username);
                return u;
            }
            
            System.out.println("❌ Login failed: " + username);
            return null;
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi đăng nhập: " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
    }
    
 // ========= GET USER BY ID =========
    public user getUserById(int userId) {
        String sql = "SELECT * FROM Users WHERE user_id = ?";
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return extractUser(rs, true);
            }
        } catch (Exception e) {
            System.err.println("Lỗi lấy user: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
        return null;
    }

    // ========= GET ALL USERS (Admin only) =========
    public List<user> getAllUsers() {
        List<user> list = new ArrayList<>();
        String sql = "SELECT * FROM Users ORDER BY created_at DESC";

        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(extractUser(rs, false));
            }

        } catch (Exception e) {
            System.err.println("❌ Lỗi getAllUsers: " + e.getMessage());

        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }

        return list;
    }

    // ========= CHECK USERNAME =========
    public boolean isUsernameExist(String username) {
        String sql = "SELECT 1 FROM Users WHERE username = ?";

        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setString(1, username);
            rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            System.err.println("❌ Lỗi check username: " + e.getMessage());

        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }

        return false;
    }

    // ========= CHECK EMAIL =========
    public boolean isEmailExist(String email) {
        String sql = "SELECT 1 FROM Users WHERE email = ?";

        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setString(1, email);
            rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            System.err.println("❌ Lỗi check email: " + e.getMessage());

        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }

        return false;
    }

    // ========= ✅ MỚI: UPDATE USER PROFILE (CHỈ CẬP NHẬT FULL_NAME VÀ AVATAR) =========
    public boolean updateUserProfile(user user) {
        String sql = "UPDATE Users SET full_name = ?, avatar = ? WHERE user_id = ?";
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getAvatar());
            ps.setInt(3, user.getUserId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Lỗi update profile: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
    }


    // ========= UPDATE - Change password =========
    public boolean changePassword(int userId, String newPassword) {
        String sql = "UPDATE Users SET password = ? WHERE user_id = ?";
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setString(1, newPassword);  // Password đã hash từ Servlet
            ps.setInt(2, userId);
            
            int result = ps.executeUpdate();
            if (result > 0) {
                System.out.println("✅ Password changed for user ID: " + userId);
            }
            return result > 0;
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi đổi password: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
        return false;
    }
    
    public int countUserRecipes(int userId) {
        String sql = "SELECT COUNT(*) FROM Recipes WHERE user_id = ?";
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            System.err.println("Lỗi đếm: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
        return 0;
    }
    
    public int countUserFavoritesReceived(int userId) {
        String sql = "SELECT COUNT(*) FROM Favorites f JOIN Recipes r ON f.recipe_id = r.recipe_id WHERE r.user_id = ?";
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            System.err.println("Lỗi: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
        return 0;
    }
    
    public int countUserFavoritesSent(int userId) {
        String sql = "SELECT COUNT(*) FROM Favorites WHERE user_id = ?";
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            System.err.println("Lỗi: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
        return 0;
    }


    // ========= DELETE USER (Admin only) =========
    public boolean deleteUser(int userId) {
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;

        try {
            kn.ketnoi();
            
            // Tắt autocommit để dùng transaction
            kn.cn.setAutoCommit(false);
            
            // BƯỚC 1: Xóa tất cả favorites liên quan đến recipes của user này
            // (Người khác đã thích recipes của user này)
            String sql1 = "DELETE FROM Favorites WHERE recipe_id IN (SELECT recipe_id FROM Recipes WHERE user_id = ?)";
            ps = kn.cn.prepareStatement(sql1);
            ps.setInt(1, userId);
            ps.executeUpdate();
            ps.close();
            
            System.out.println("✅ Đã xóa Favorites của recipes thuộc user " + userId);
            
            // BƯỚC 2: Xóa tất cả favorites mà user này đã thích
            // (User này đã thích recipes của người khác)
            String sql2 = "DELETE FROM Favorites WHERE user_id = ?";
            ps = kn.cn.prepareStatement(sql2);
            ps.setInt(1, userId);
            ps.executeUpdate();
            ps.close();
            
            System.out.println("✅ Đã xóa Favorites của user " + userId);
            
            // BƯỚC 3: Xóa tất cả recipes của user
            String sql3 = "DELETE FROM Recipes WHERE user_id = ?";
            ps = kn.cn.prepareStatement(sql3);
            ps.setInt(1, userId);
            ps.executeUpdate();
            ps.close();
            
            System.out.println("✅ Đã xóa Recipes của user " + userId);
            
            // BƯỚC 4: Xóa user
            String sql4 = "DELETE FROM Users WHERE user_id = ?";
            ps = kn.cn.prepareStatement(sql4);
            ps.setInt(1, userId);
            int result = ps.executeUpdate();
            
            // Commit transaction
            kn.cn.commit();
            
            System.out.println("✅ Đã xóa User " + userId + " thành công!");
            
            return result > 0;

        } catch (Exception e) {
            System.err.println("❌ Lỗi xóa user: " + e.getMessage());
            e.printStackTrace();
            
            // Rollback nếu có lỗi
            try {
                if (kn.cn != null) {
                    kn.cn.rollback();
                    System.out.println("⚠️ Đã rollback transaction");
                }
            } catch (Exception rollbackEx) {
                System.err.println("❌ Lỗi rollback: " + rollbackEx.getMessage());
            }
            
            return false;

        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { 
                if (kn.cn != null) {
                    kn.cn.setAutoCommit(true); // Bật lại autocommit
                    kn.cn.close(); 
                }
            } catch (Exception ignored) {}
        }
    }
    
    // ========= ✅ SEARCH USERS - Tìm kiếm user theo mã hoặc tên =========
    /**
     * Tìm kiếm user theo user_id hoặc username hoặc full_name
     * @param keyword Từ khóa tìm kiếm (có thể là mã số hoặc tên)
     * @return Danh sách user khớp với từ khóa
     */
    public List<user> searchUsers(String keyword) {
        List<user> list = new ArrayList<>();
        
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllUsers();
        }
        
        String sql = "SELECT user_id, username, full_name, email, avatar, is_admin, created_at, password " +
                     "FROM Users " +
                     "WHERE CAST(user_id AS CHAR) LIKE ? " +
                     "   OR username LIKE ? " +
                     "   OR full_name LIKE ? " +
                     "ORDER BY created_at DESC";
        
        ketnoidao kn = new ketnoidao();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            kn.ketnoi();
            ps = kn.cn.prepareStatement(sql);
            
            String searchPattern = "%" + keyword.trim() + "%";
            ps.setString(1, searchPattern);  // Search by user_id
            ps.setString(2, searchPattern);  // Search by username
            ps.setString(3, searchPattern);  // Search by full_name
            
            rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(extractUser(rs, true));
            }
            
            System.out.println("ℹ️ Tìm thấy " + list.size() + " user với keyword: " + keyword);
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi tìm kiếm user: " + e.getMessage());
            e.printStackTrace();
            
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (kn.cn != null) kn.cn.close(); } catch (Exception ignored) {}
        }
        
        return list;
    }
}