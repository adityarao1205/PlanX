package com.src.servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.src.daoimpl.UserDaoImpl;
import com.src.model.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        UserDaoImpl dao = new UserDaoImpl();
        User user = dao.findByEmailAndPassword(email, password);

        if (user != null) {
            // ✅ Normalize role (fixes redirect issue)
            String role = user.getRole();
            if (role != null) {
                role = role.trim().toUpperCase();
                user.setRole(role);
            }

            HttpSession session = req.getSession();
            session.setAttribute("currentUser", user);

            // ✅ Debugging output (for console)
            System.out.println("✅ LOGIN SUCCESS: " + user.getEmail() + " | Role: " + user.getRole());

            // ✅ Redirect based on role
            switch (user.getRole()) {
                case "ADMIN":
                    resp.sendRedirect("admindashboard");
                    break;

                case "ORGANIZER":
                    resp.sendRedirect("organizer-home.jsp");
                    break;

                case "CUSTOMER":
                    resp.sendRedirect("customer-home.jsp");
                    break;

                default:
                    resp.sendRedirect("login.jsp?error=Unknown+role");
                    break;
            }

        } else {
            // ❌ Login failed
            System.out.println("❌ LOGIN FAILED: " + email);
            resp.sendRedirect("login.jsp?error=Invalid+Email+or+Password");
        }
    }
}