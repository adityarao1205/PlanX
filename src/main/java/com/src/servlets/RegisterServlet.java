package com.src.servlets;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.src.daoimpl.UserDaoImpl;
import com.src.model.User;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String role = req.getParameter("role");

        // prevent someone from registering as admin manually
        if ("ADMIN".equalsIgnoreCase(role)) {
            resp.sendRedirect("register.jsp?error=Cannot+register+as+Admin");
            return;
        }

        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(password);
        user.setRole(role);

        UserDaoImpl dao = new UserDaoImpl();
        boolean success = dao.registerUser(user);

        if (success) {
            resp.sendRedirect("login.jsp?msg=Registration+Successful!+Please+Login");
        } else {
            resp.sendRedirect("register.jsp?error=Registration+Failed");
        }
    }
}