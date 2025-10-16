package com.src.servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.src.daoimpl.BookingDaoImpl;
import com.src.daoimpl.EventDaoImpl;
import com.src.model.Event;
import com.src.model.User;

@WebServlet("/ConfirmBookingServlet")
public class ConfirmBookingServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User u = (User) req.getSession().getAttribute("currentUser");
        if (u == null || !"CUSTOMER".equalsIgnoreCase(u.getRole())) {
            resp.sendRedirect("login.jsp");
            return;
        }

        try {
            int eventId = Integer.parseInt(req.getParameter("eventId"));
            int tickets = Integer.parseInt(req.getParameter("tickets"));
            double totalAmount = Double.parseDouble(req.getParameter("total"));
            String upiId = req.getParameter("upiId");

            // ✅ Extra safeguard: prevent duplicate form submits
            if (req.getSession().getAttribute("bookingInProgress") != null) {
                resp.sendRedirect(req.getContextPath() + "/mybookings.jsp?msg=Payment+already+processed");
                return;
            }
            req.getSession().setAttribute("bookingInProgress", true);

            // Fetch event details
            EventDaoImpl eventDao = new EventDaoImpl();
            Event event = null;
            for (Event e : eventDao.getApprovedEvents()) {
                if (e.getEventId() == eventId) {
                    event = e;
                    break;
                }
            }

            if (event == null) {
                resp.sendRedirect("customer-home.jsp?error=Invalid+Event");
                return;
            }

            // ✅ Create booking
            BookingDaoImpl dao = new BookingDaoImpl();
            boolean success = dao.createBooking(u.getUserId(), eventId, tickets, totalAmount);

            if (success) {
                // Reduce available seats
                int newAvailable = event.getAvailableSeats() - tickets;
                event.setAvailableSeats(newAvailable);
                eventDao.updateEvent(event);

                // ✅ Clear temporary data so going Back won’t refill fields
                req.getSession().removeAttribute("bookingInProgress");

                // ✅ Add strong no-cache headers
                resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
                resp.setHeader("Pragma", "no-cache");
                resp.setDateHeader("Expires", 0);

                req.getSession().setAttribute("paymentDone", true);
                resp.sendRedirect(req.getContextPath() + "/mybookings.jsp?msg=Payment+successful");

            } else {
                req.getSession().removeAttribute("bookingInProgress");
                resp.sendRedirect("payment.jsp?error=Booking+failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().removeAttribute("bookingInProgress");
            resp.sendRedirect("payment.jsp?error=Invalid+data");
        }
    }
}
