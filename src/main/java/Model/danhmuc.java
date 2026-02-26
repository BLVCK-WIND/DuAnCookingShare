package Model;

public class danhmuc {
    private int categoryId;
    private String categoryName;
    private String description;
    private String imageUrl; // ✅ Thêm mới
    
    // =========== CONSTRUCTORS ===========
    public danhmuc() {
    }
    
    public danhmuc(int categoryId, String categoryName, String description, String imageUrl) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.description = description;
        this.imageUrl = imageUrl;
    }
    
    // =========== GETTERS & SETTERS ===========
    public int getCategoryId() {
        return categoryId;
    }
    
    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }
    
    public String getCategoryName() {
        return categoryName;
    }
    
    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    // ✅ THÊM MỚI: Getter & Setter cho imageUrl
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    // =========== UTILITY METHODS ===========
    @Override
    public String toString() {
        return "danhmuc{" +
                "categoryId=" + categoryId +
                ", categoryName='" + categoryName + '\'' +
                ", description='" + description + '\'' +
                ", imageUrl='" + imageUrl + '\'' +
                '}';
    }
}