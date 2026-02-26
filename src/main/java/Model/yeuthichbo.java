package Model;

import java.util.ArrayList;
import java.util.List;

public class yeuthichbo {
private yeuthichdao dao = new yeuthichdao();
    
    // Thêm yêu thích
    public boolean addFavorite(int userId, int recipeId) throws Exception {
        return dao.addFavorite(userId, recipeId);
    }
    
    // Bỏ yêu thích
    public boolean removeFavorite(int userId, int recipeId) throws Exception {
        return dao.removeFavorite(userId, recipeId);
    }
    
    // Kiểm tra đã yêu thích chưa
    public boolean isFavorite(int userId, int recipeId) throws Exception {
        return dao.isFavorite(userId, recipeId);
    }
    
    // Lấy danh sách yêu thích của user
    public List<yeuthich> getFavoritesByUserId(int userId) throws Exception {
        return dao.getFavoritesByUserId(userId);
    }
    
    // Lấy công thức yêu thích (kèm thông tin đầy đủ)
    public List<congthuc> getFavoriteRecipes(int userId) throws Exception {
        return dao.getFavoriteRecipes(userId);
    }
    
    // Đếm số lượt yêu thích của một công thức
    public int countFavoritesByRecipeId(int recipeId) throws Exception {
        return dao.countFavoritesByRecipeId(recipeId);
    }
}
