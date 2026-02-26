package Controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Model.user;
import Model.userbo;
import Model.mahoaMD5;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        
        // Validate
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty()) {
            
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
            request.setAttribute("username", username);
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Kiểm tra mật khẩu
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.setAttribute("username", username);
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        if (password.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự!");
            request.setAttribute("username", username);
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Kiểm tra username đã tồn tại
        userbo bo = new userbo();
        try {
	        if (bo.isUsernameExist(username.trim())) {
	            request.setAttribute("error", "Tên đăng nhập đã tồn tại!");
	            request.setAttribute("username", username);
	            request.setAttribute("fullName", fullName);
	            request.setAttribute("email", email);
	            request.getRequestDispatcher("register.jsp").forward(request, response);
	            return;
	        }
	        
	        // Kiểm tra email đã tồn tại
	        if (bo.isEmailExist(email.trim())) {
	            request.setAttribute("error", "Email đã được sử dụng!");
	            request.setAttribute("username", username);
	            request.setAttribute("fullName", fullName);
	            request.setAttribute("email", email);
	            request.getRequestDispatcher("register.jsp").forward(request, response);
	            return;
	        }
			
		} catch (Exception e) {
			// TODO: handle exception
		}
        
        // ✅ MÃ HÓA MẬT KHẨU BẰNG MD5
        String hashedPassword;
        try {
            hashedPassword = mahoaMD5.encrypt(password.trim());
            System.out.println("🔐 Password hashed successfully");
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi mã hóa mật khẩu: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "Lỗi hệ thống khi mã hóa mật khẩu!");
            request.setAttribute("username", username);
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Tạo user mới
        user newUser = new user();
        newUser.setUsername(username.trim());
        newUser.setPassword(hashedPassword);  // ✅ LƯU MẬT KHẨU ĐÃ MÃ HÓA
        newUser.setFullName(fullName.trim());
        newUser.setEmail(email.trim());
        newUser.setAdmin(false); // User thường
        try {
	        boolean success = bo.registerUser(newUser);
	        
	        if (success) {
	            System.out.println("✅ User registered: " + username);
	            request.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
	            request.getRequestDispatcher("login.jsp").forward(request, response);
	        } else {
	            request.setAttribute("error", "Đăng ký thất bại! Vui lòng thử lại.");
	            request.setAttribute("username", username);
	            request.setAttribute("fullName", fullName);
	            request.setAttribute("email", email);
	            request.getRequestDispatcher("register.jsp").forward(request, response);
	        }
		
		} catch (Exception e) {
			// TODO: handle exception
		}
    }
}