package com.src.daoimpl;

import java.sql.Connection;
import java.sql.Date;
import java.sql.Types;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.src.dao.EventDAO;
import com.src.model.Event;
import com.src.util.DBConnection;

public class EventDaoImpl implements EventDAO{

    @Override
    public boolean createEvent(Event e) {
    	String sql = "INSERT INTO EVENTS (event_name, event_date, venue, location, price_per_ticket, total_seats, available_seats, status, organizer_id) VALUES (?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, e.getEventName());
            ps.setDate(2, new java.sql.Date(e.getEventDate().getTime()));
            ps.setString(3, e.getVenue());
            ps.setString(4, e.getLocation());
            ps.setDouble(5, e.getPricePerTicket());
            ps.setInt(6, e.getTotalSeats());
            ps.setInt(7, e.getAvailableSeats());
            ps.setString(8, e.getStatus());
            ps.setInt(9, e.getOrganizerId());
            return ps.executeUpdate() == 1;

        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    @Override
    public List<Event> getEventsByOrganizer(int organizerId) {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT * FROM EVENTS WHERE organizer_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, organizerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Event e = mapRow(rs);
                list.add(e);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public List<Event> getPendingEvents() {
        return getEventsByStatus("PENDING");
    }

    @Override
    public boolean updateEvent(Event e) {
        String sql = "UPDATE EVENTS SET event_name=?, event_date=?, venue=?, location=?, price_per_ticket=?, total_seats=?, available_seats=? WHERE event_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, e.getEventName());
            ps.setDate(2, new java.sql.Date(e.getEventDate().getTime()));
            ps.setString(3, e.getVenue());
            ps.setString(4, e.getLocation());
            ps.setDouble(5, e.getPricePerTicket());
            ps.setInt(6, e.getTotalSeats());
            ps.setInt(7, e.getAvailableSeats());
            ps.setInt(8, e.getEventId());
            return ps.executeUpdate() == 1;
        } catch (SQLException ex) { ex.printStackTrace(); }
        return false;
    }

    @Override
    public boolean approveEvent(int eventId, String status) {
        String sql = "UPDATE EVENTS SET status=? WHERE event_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, eventId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public List<Event> getApprovedEvents() {
        return getEventsByStatus("APPROVED");
    }

    private List<Event> getEventsByStatus(String status) {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT * FROM EVENTS WHERE TRIM(UPPER(status)) = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status.toUpperCase());
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private Event mapRow(ResultSet rs) throws SQLException {
        Event e = new Event();
        e.setEventId(rs.getInt("event_id"));
        e.setEventName(rs.getString("event_name"));
        e.setEventDate(rs.getDate("event_date"));
        e.setVenue(rs.getString("venue"));
        e.setLocation(rs.getString("location"));
        e.setPricePerTicket(rs.getDouble("price_per_ticket"));
        e.setTotalSeats(rs.getInt("total_seats"));
        e.setAvailableSeats(rs.getInt("available_seats"));
        e.setStatus(rs.getString("status"));
        e.setOrganizerId(rs.getInt("organizer_id"));
        return e;
        
        
    }
 // ✅ Update event status (used for approve, decline, reinstate)
    public boolean updateEventStatus(int eventId, String status, Integer adminId, String comment) {
        // If you don't have approved_by, approved_at, admin_comment columns in DB, use the shorter SQL below
        String sql = "UPDATE EVENTS SET status = ? WHERE event_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, eventId);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    // ✅ Delete a specific event (by ID)
    public boolean deleteEventById(int eventId) {
        String sql = "DELETE FROM EVENTS WHERE event_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            int rows=ps.executeUpdate();
            return rows > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    // ✅ Delete all events where event date < today (completed events)
    public int deleteEventsBeforeToday() {
        String sql = "DELETE FROM EVENTS WHERE event_date < TRUNC(SYSDATE)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            return ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
            return 0;
        }
    }

    // ✅ (Optional) Get events by specific status (like DECLINED)
    public List<Event> getEventsByStatusDynamic(String status) {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT * FROM EVENTS WHERE TRIM(UPPER(status)) = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status.toUpperCase());
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

    public boolean deleteEventsBeforeDate(java.sql.Date cutoff) {
        String sql = "DELETE FROM EVENTS WHERE event_date < ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, cutoff);
            int r = ps.executeUpdate();
            return r >= 0; // true even if zero rows
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }
   
}