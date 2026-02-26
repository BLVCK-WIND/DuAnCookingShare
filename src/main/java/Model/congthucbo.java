package Model;

import java.util.ArrayList;
import java.util.List;

public class congthucbo {
private congthucdao dao = new congthucdao();
    
    // Lấy tất cả công thức đã duyệt
    public List<congthuc> getAllApprovedCongThuc() throws Exception {
        return dao.getAllApprovedCongThuc();
    }
    
    // Lấy công thức theo ID
    public congthuc getCongThucById(int recipeId) throws Exception {
        return dao.getCongThucById(recipeId);
    }
    
    // Lấy công thức theo user
    public List<congthuc> getCongThucByUserId(int userId) throws Exception {
        return dao.getCongThucByUserId(userId);
    }
    
    // Lấy công thức theo category
    public List<congthuc> getCongThucByCategory(int categoryId) throws Exception {
        return dao.getCongThucByCategory(categoryId);
    }
    
    // Tìm kiếm công thức
    public List<congthuc> searchCongThucAdvanced(String keyword) throws Exception {
        return dao.searchCongThucAdvanced(keyword);
    }
    
    // Thêm công thức mới
    public int addCongThuc(congthuc ct) throws Exception {
        return dao.addCongThuc(ct);
    }
    
    // Sửa công thức
    public boolean updateCongThuc(congthuc ct) throws Exception {
        return dao.updateCongThuc(ct);
    }
    
    // Xóa công thức
    public boolean deleteCongThuc(int recipeId) throws Exception {
        return dao.deleteCongThuc(recipeId);
    }
    
    // Duyệt công thức (Admin)
    public boolean approveRecipe(int recipeId, int adminId) throws Exception {
        return dao.approveRecipe(recipeId, adminId);
    }
    
    // Từ chối công thức (Admin)
    public boolean rejectRecipe(int recipeId, String reason, int adminId) throws Exception {
        return dao.rejectRecipe(recipeId, reason, adminId);
    }
    
    // Lấy tất cả công thức (Admin)
    public List<congthuc> getAllRecipesForAdmin() throws Exception {
        return dao.getAllRecipesForAdmin();
    }
    
    // Lấy công thức theo status
    public List<congthuc> getRecipesByStatus(String status) throws Exception {
        return dao.getRecipesByStatus(status);
    }
    
    // Đếm công thức theo status
    public int countRecipesByStatus(String status) throws Exception {
        return dao.countRecipesByStatus(status);
    }
    
    public int countTotalRecipes() throws Exception{
    	return dao.countTotalRecipes();
    }
    
    public List<congthuc> getLatestRecipes(int limit) throws Exception{
    	return dao.getLatestRecipes(limit);
    }
    
    // Tìm kiếm cho admin
    public List<congthuc> searchRecipesForAdmin(String keyword, String statusFilter, Integer categoryFilter) throws Exception {
        return dao.searchRecipesForAdmin(keyword, statusFilter, categoryFilter);
    }
}
