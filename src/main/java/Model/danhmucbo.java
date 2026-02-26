package Model;

import java.util.ArrayList;
import java.util.List;

public class danhmucbo {
private danhmucdao dao = new danhmucdao();
    
    // Lấy tất cả danh mục
    public List<danhmuc> getAllDanhMuc() throws Exception {
        return dao.getAllDanhMuc();
    }
    
    // Lấy danh mục theo ID
    public danhmuc getDanhMucById(int categoryId) throws Exception {
        return dao.getDanhMucById(categoryId);
    }
    
    // Thêm danh mục
    public boolean addDanhMuc(danhmuc dm) throws Exception {
        return dao.addDanhMuc(dm);
    }
    
    // Sửa danh mục
    public boolean updateDanhMuc(danhmuc dm) throws Exception {
        return dao.updateDanhMuc(dm);
    }
    
    // Xóa danh mục
    public boolean deleteDanhMuc(int categoryId) throws Exception {
        return dao.deleteDanhMuc(categoryId);
    }
    
    // Kiểm tra tên danh mục đã tồn tại
    public boolean isCategoryNameExist(String categoryName) throws Exception {
        return dao.isCategoryNameExist(categoryName);
    }
    
    // Đếm số công thức trong danh mục
    public int countRecipesByCategory(int categoryId) throws Exception {
        return dao.countRecipesByCategory(categoryId);
    }
    
    // Lấy danh mục có ảnh
    public List<danhmuc> getCategoriesWithImages() throws Exception {
        return dao.getCategoriesWithImages();
    }
    
    // Tìm kiếm danh mục
    public List<danhmuc> searchCategories(String keyword) throws Exception {
        return dao.searchCategories(keyword);
    }
}
