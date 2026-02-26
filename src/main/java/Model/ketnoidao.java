package Model;

import java.sql.Connection;
import java.sql.DriverManager;

public class ketnoidao {
	public Connection cn;

    public void ketnoi() throws Exception {
        // Nạp driver JDBC
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

        // Kết nối tới SQL Server
        cn = DriverManager.getConnection(
        	    "jdbc:sqlserver://localhost\\SQLEXPRESS:1433;"
        	  + "databaseName=CookingShareDB;"
        	  + "user=sa;"
        	  + "password=123;"
        	  + "encrypt=true;"
        	  + "trustServerCertificate=true;"
        	);

    }

    public static void main(String[] args) {
        ketnoidao kn = new ketnoidao();
        try {
            kn.ketnoi();
        } catch (Exception e) {
            System.out.println("❌ Lỗi kết nối: " + e.getMessage());
            e.printStackTrace();
        }
    }

}
