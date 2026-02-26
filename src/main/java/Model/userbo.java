package Model;

import java.util.ArrayList; // ← THÊM DÒNG NÀY
import java.util.List;      // ← THÊM DÒNG NÀY (nếu cần)

public class userbo {
    private userdao dao = new userdao();
    
    // Đăng ký user
    public boolean registerUser(user u) throws Exception {
        return dao.registerUser(u);
    }
    
    // Đăng nhập
    public user login(String username, String hashedPassword) throws Exception {
        return dao.login(username, hashedPassword);
    }
    
    // Lấy user theo ID
    public user getUserById(int userId) throws Exception {
        return dao.getUserById(userId);
    }
    
    // Cập nhật user profile (full_name, avatar)
    public boolean updateUserProfile(user u) throws Exception {
        return dao.updateUserProfile(u); // ← SỬA TÊN METHOD
    }
    
    // Đổi password
    public boolean changePassword(int userId, String hashedNewPassword) throws Exception {
        return dao.changePassword(userId, hashedNewPassword); // ← SỬA TÊN METHOD
    }
    
    // Xóa user (Admin)
    public boolean deleteUser(int userId) throws Exception {
        return dao.deleteUser(userId);
    }
    
    // Lấy tất cả users (Admin)
    public List<user> getAllUsers() throws Exception {
        return dao.getAllUsers(); // ← CAST List → ArrayList
    }
    
    // Kiểm tra username đã tồn tại
    public boolean isUsernameExist(String username) throws Exception {
        return dao.isUsernameExist(username);
    }
    
    // Kiểm tra email đã tồn tại
    public boolean isEmailExist(String email) throws Exception {
        return dao.isEmailExist(email);
    }
    
    // Đếm số recipes của user
    public int countUserRecipes(int userId) throws Exception {
        return dao.countUserRecipes(userId);
    }
    
    // Đếm số favorites nhận được
    public int countUserFavoritesReceived(int userId) throws Exception {
        return dao.countUserFavoritesReceived(userId);
    }
    
    // Đếm số favorites đã gửi
    public int countUserFavoritesSent(int userId) throws Exception {
        return dao.countUserFavoritesSent(userId);
    }
    
    // Tìm kiếm users
    public List<user> searchUsers(String keyword) throws Exception {
        return dao.searchUsers(keyword);
    }
}