package com.src.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.src.util.DBConnection;

public class BookingDaoImpl {

    public boolean createBooking(int userId, int eventId, int tickets, double totalAmount) {
        String sql = "INSERT INTO BOOKINGS (event_id, user_id, no_of_tickets, total_amount, payment_status) " +
                     "VALUES (?, ?, ?, ?, 'PAID')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, eventId);
            ps.setInt(2, userId);
            ps.setInt(3, tickets);
            ps.setDouble(4, totalAmount);

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}