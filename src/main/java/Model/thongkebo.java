package Model;

import java.util.List;

public class thongkebo {
    private thongkedao dao = new thongkedao();
    
    // Lấy top 5 most viewed
    public List<congthuc> getTop5MostViewed() throws Exception {
        return dao.getTop5MostViewed();
    }
    
    // Lấy top 5 most favorite
    public List<congthuc> getTop5MostFavorite() throws Exception {
        return dao.getTop5MostFavorite();
    }
    
    // Lấy top 5 highest rated
    public List<congthuc> getTop5HighestRated() throws Exception {
        return dao.getTop5HighestRated();
    }
    
    // Đếm tổng recipes
    public int countTotalRecipes() throws Exception {
        return dao.countTotalRecipes();
    }
    
    // Đếm tổng users
    public int countTotalUsers() throws Exception {
        return dao.countTotalUsers();
    }
    
    // Đếm recipes last 7 days
    public int countRecipesLast7Days() throws Exception {
        return dao.countRecipesLast7Days();
    }
}