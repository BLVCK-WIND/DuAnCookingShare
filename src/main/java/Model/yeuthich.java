package Model;

import java.sql.Timestamp;

public class yeuthich {
	private int favoriteId;
    private int userId;
    private int recipeId;
    private Timestamp createdAt;
	public yeuthich() {
		super();
		// TODO Auto-generated constructor stub
	}
	public yeuthich(int favoriteId, int userId, int recipeId, Timestamp createdAt) {
		super();
		this.favoriteId = favoriteId;
		this.userId = userId;
		this.recipeId = recipeId;
		this.createdAt = createdAt;
	}
	public int getFavoriteId() {
		return favoriteId;
	}
	public void setFavoriteId(int favoriteId) {
		this.favoriteId = favoriteId;
	}
	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	public int getRecipeId() {
		return recipeId;
	}
	public void setRecipeId(int recipeId) {
		this.recipeId = recipeId;
	}
	public Timestamp getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}
    
    
}
