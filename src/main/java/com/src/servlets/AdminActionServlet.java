package com.src.servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.src.daoimpl.EventDaoImpl;
import com.src.model.User;

@WebServlet("/adminAction")
public class AdminActionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        User admin = (User) session.getAttribute("currentUser");
        if (!"ADMIN".equalsIgnoreCase(admin.getRole())) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String action = req.getParameter("action"); // approve | decline | reinstate | delete | cleanup
        String msg = "";
        String err = "";

        EventDaoImpl dao = new EventDaoImpl();

        try {
            if ("approve".equalsIgnoreCase(action)) {
                int eventId = Integer.parseInt(req.getParameter("eventId"));
                boolean ok = dao.updateEventStatus(eventId, "APPROVED", admin.getUserId(), null);
                msg = ok ? "Event approved successfully!" : "Failed to approve event.";

            } else if ("decline".equalsIgnoreCase(action)) {
                int eventId = Integer.parseInt(req.getParameter("eventId"));
                boolean ok = dao.updateEventStatus(eventId, "DECLINED", admin.getUserId(), null);
                msg = ok ? "Event declined successfully!" : "Failed to decline event.";

            } else if ("reinstate".equalsIgnoreCase(action)) {
                int eventId = Integer.parseInt(req.getParameter("eventId"));
                boolean ok = dao.updateEventStatus(eventId, "APPROVED", admin.getUserId(), null);
                msg = ok ? "Declined event reinstated successfully!" : "Failed to reinstate event.";

            } else if ("delete".equalsIgnoreCase(action)) {
                int eventId = Integer.parseInt(req.getParameter("eventId"));
                boolean ok = dao.deleteEventById(eventId);
                msg = ok ? "Event deleted successfully!" : "Failed to delete event.";

            } else if ("cleanup".equalsIgnoreCase(action)) {
                int removed = dao.deleteEventsBeforeToday();
                msg = removed + " completed event(s) removed.";
            } else {
                err = "Unknown action.";
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            err = "Error: " + ex.getMessage();
        }

        // Redirect back to admin dashboard with message
        String target = req.getContextPath() + "/admin-home.jsp";
        if (!msg.isEmpty()) target += "?msg=" + java.net.URLEncoder.encode(msg, "UTF-8");
        if (!err.isEmpty()) target += (msg.isEmpty() ? "?" : "&") + "error=" + java.net.URLEncoder.encode(err, "UTF-8");

        resp.sendRedirect(target);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doPost(req, resp);
    }
}