package Model;

import java.sql.Timestamp;

public class cacbuocnau {
	private int stepId;
    private int recipeId;
    private int stepNumber;
    private String description;
    private Timestamp createdAt;
    private Timestamp updatedAt;
	public cacbuocnau() {
		super();
		// TODO Auto-generated constructor stub
	}
	public cacbuocnau(int stepId, int recipeId, int stepNumber, String description, Timestamp createdAt,
			Timestamp updatedAt) {
		super();
		this.stepId = stepId;
		this.recipeId = recipeId;
		this.stepNumber = stepNumber;
		this.description = description;
		this.createdAt = createdAt;
		this.updatedAt = updatedAt;
	}
	public int getStepId() {
		return stepId;
	}
	public void setStepId(int stepId) {
		this.stepId = stepId;
	}
	public int getRecipeId() {
		return recipeId;
	}
	public void setRecipeId(int recipeId) {
		this.recipeId = recipeId;
	}
	public int getStepNumber() {
		return stepNumber;
	}
	public void setStepNumber(int stepNumber) {
		this.stepNumber = stepNumber;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public Timestamp getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}
	public Timestamp getUpdatedAt() {
		return updatedAt;
	}
	public void setUpdatedAt(Timestamp updatedAt) {
		this.updatedAt = updatedAt;
	}
    
    

}
