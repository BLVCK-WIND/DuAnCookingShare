package Controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Kiểm tra đã verify PIN chưa
        HttpSession session = request.getSession();
        Boolean pinVerified = (Boolean) session.getAttribute("adminPinVerified");
        
        if (pinVerified == null || !pinVerified) {
            response.sendRedirect("AdminPinCheckServlet");
            return;
        }
        
        // Hiển thị trang login admin
        request.getRequestDispatcher("adminLogin.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}