package com.src.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.src.util.DBConnection;

@WebServlet("/CancelBookingServlet")
public class CancelBookingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int bookingId = Integer.parseInt(req.getParameter("bookingId"));
        int eventId = Integer.parseInt(req.getParameter("eventId"));
        int tickets = Integer.parseInt(req.getParameter("tickets"));

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Step 1: Delete booking
            ps = conn.prepareStatement("DELETE FROM BOOKINGS WHERE booking_id = ?");
            ps.setInt(1, bookingId);
            int deleted = ps.executeUpdate();

            if (deleted > 0) {
                // Step 2: Restore available seats in event
                PreparedStatement ps2 = conn.prepareStatement(
                    "UPDATE EVENTS SET available_seats = available_seats + ? WHERE event_id = ?");
                ps2.setInt(1, tickets);
                ps2.setInt(2, eventId);
                ps2.executeUpdate();
                ps2.close();

                conn.commit();
                resp.sendRedirect("/PlanX/mybookings.jsp"); // ✅ works with your setup
            } else {
                conn.rollback();
                resp.getWriter().println("<h3>Cancellation failed. Try again.</h3>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (Exception ignore) {}
            resp.getWriter().println("<h3>Error during cancellation.</h3>");
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignore) {}
            try { if (conn != null) conn.close(); } catch (Exception ignore) {}
        }
    }
}