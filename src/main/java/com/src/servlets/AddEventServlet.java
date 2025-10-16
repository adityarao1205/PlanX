package com.src.servlets;
import java.io.IOException;
import java.text.SimpleDateFormat;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.src.ejb.EventServiceBean;
import com.src.model.Event;
import com.src.model.User;

@WebServlet("/addEvent")
public class AddEventServlet extends HttpServlet {

    @EJB
    private EventServiceBean eventService; // no-interface view injection

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User u = (User) req.getSession().getAttribute("currentUser");
        if (u == null || !( "ORGANIZER".equalsIgnoreCase(u.getRole()) || "ADMIN".equalsIgnoreCase(u.getRole()) )) {
            resp.sendRedirect("login.jsp");
            return;
        }

        try {
            String name = req.getParameter("eventName");
            String dateStr = req.getParameter("eventDate");
            String venue = req.getParameter("venue");
            String location = req.getParameter("location");
            double price = Double.parseDouble(req.getParameter("price"));
            int seats = Integer.parseInt(req.getParameter("totalSeats"));

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Event e = new Event();
            e.setEventName(name);
            e.setEventDate(sdf.parse(dateStr));
            e.setVenue(venue);
            e.setLocation(location);
            e.setPricePerTicket(price);
            e.setTotalSeats(seats);
            e.setAvailableSeats(seats);
            e.setOrganizerId(u.getUserId());

            // Admin auto-approve, organizer => pending
            boolean autoApprove = "ADMIN".equalsIgnoreCase(u.getRole());

            boolean success = eventService.createEvent(e, autoApprove);

            if (success) {
                if (autoApprove) {
                    resp.sendRedirect("admin-home.jsp?msg=Event+added+and+auto-approved");
                } else {
                    resp.sendRedirect("organizer-home.jsp?msg=Event+added+successfully");
                }
            } else {
                resp.sendRedirect("addevent.jsp?error=Failed+to+add+event");
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            resp.sendRedirect("addevent.jsp?error=Invalid+data");
        }
    }
}