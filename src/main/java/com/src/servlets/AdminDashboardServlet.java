package com.src.servlets;

import java.io.IOException;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.src.daoimpl.EventDaoImpl;
import com.src.model.Event;
import com.src.model.User;

@WebServlet("/admindashboard")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        User u = (User) session.getAttribute("currentUser");
        if (!"ADMIN".equalsIgnoreCase(u.getRole())) {
            resp.sendRedirect("login.jsp");
            return;
        }

        EventDaoImpl dao = new EventDaoImpl();
        List<Event> pendingEvents = dao.getPendingEvents();

        System.out.println("DEBUG: Pending events found = " + pendingEvents.size()); // ✅ Debug check

        req.setAttribute("pendingEvents", pendingEvents);
        RequestDispatcher rd = req.getRequestDispatcher("admin-home.jsp");
        rd.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}