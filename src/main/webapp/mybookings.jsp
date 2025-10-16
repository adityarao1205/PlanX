<%@ page import="java.sql.*" %>
<%@ page import="com.src.util.DBConnection" %>
<%@ page import="com.src.model.User" %>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
response.setHeader("Pragma", "no-cache"); // HTTP 1.0
response.setDateHeader("Expires", 0); // Proxies
%>
<jsp:include page="/header.jsp" />

<style>
body {
  background-color: #0f0f0f;
  color: #f5f5f5;
  font-family: 'Poppins', sans-serif;
}

h2.text-danger {
  color: #ff4040 !important;
}

.card {
  background: rgba(25, 25, 25, 0.95);
  color: #fff;
  border-radius: 16px;
  box-shadow: 0 0 15px rgba(255, 0, 0, 0.25);
  transition: 0.3s ease;
}

.card:hover {
  transform: scale(1.03);
  box-shadow: 0 0 25px rgba(255, 0, 0, 0.4);
}

.card h5, p, span {
  color: #fff !important;
}

.btn-outline-danger {
  border: 1px solid #ff4040;
  color: #ff4040;
  font-weight: 600;
  transition: all 0.3s ease;
}

.btn-outline-danger:hover {
  background: #ff4040;
  color: #fff;
  transform: scale(1.05);
}

.text-danger {
  color: #ff4040 !important;
}
</style>

<%
User u = (User) session.getAttribute("currentUser");
if (u == null || !"CUSTOMER".equalsIgnoreCase(u.getRole())) {
    response.sendRedirect("login.jsp");
    return;
}

Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;
%>

<div class="container py-5">
  <div class="text-center mb-5">
    <h2 class="fw-bold text-danger">My Bookings</h2>
    <p class="text-muted fs-5">View and manage your booked events below.</p>
  </div>

  <div class="row g-4">
<%
try {
    conn = DBConnection.getConnection();
    String sql =
        "SELECT b.booking_id, e.event_id, e.event_name, e.venue, e.event_date, " +
        "b.no_of_tickets, b.total_amount, b.payment_status, b.booking_time " +
        "FROM BOOKINGS b JOIN EVENTS e ON b.event_id = e.event_id " +
        "WHERE b.user_id = ?";
    ps = conn.prepareStatement(sql);
    ps.setInt(1, u.getUserId());
    rs = ps.executeQuery();

    boolean found = false;
    while (rs.next()) {
        found = true;

        String status = rs.getString("payment_status");
        String badgeClass = "bg-warning";
        if ("PAID".equalsIgnoreCase(status)) badgeClass = "bg-success";
        else if ("CANCELLED".equalsIgnoreCase(status)) badgeClass = "bg-danger";
%>

    <div class="col-12 col-md-6 col-lg-4">
      <div class="card border-0 shadow-lg rounded-4 ticket-card h-100">
        <div class="card-body d-flex flex-column">
          <div class="d-flex justify-content-between align-items-center mb-2">
            <h5 class="fw-bold"><%= rs.getString("event_name") %></h5>
            <span class="badge <%= badgeClass %> text-white rounded-pill px-3 py-2">
              <%= status.toUpperCase() %>
            </span>
          </div>
          <p><i class="bi bi-geo-alt"></i> <%= rs.getString("venue") %></p>
          <p><i class="bi bi-calendar-event"></i> <%= rs.getDate("event_date") %></p>
          <p><i class="bi bi-clock-history"></i> Booked On: <%= rs.getDate("booking_time") %></p>
          <hr>
          <p class="fw-semibold">Tickets: <%= rs.getInt("no_of_tickets") %></p>
          <p class="fw-semibold text-danger fs-5">Total: ₹<%= rs.getDouble("total_amount") %></p>
          <form action="CancelBookingServlet" method="post" 
                onsubmit="return confirm('Are you sure you want to cancel this booking?');" class="mt-auto">
            <input type="hidden" name="bookingId" value="<%= rs.getInt("booking_id") %>">
            <input type="hidden" name="eventId" value="<%= rs.getInt("event_id") %>">
            <input type="hidden" name="tickets" value="<%= rs.getInt("no_of_tickets") %>">
            <button type="submit" class="btn btn-outline-danger rounded-pill w-100 mt-3">
              <i class="bi bi-x-circle"></i> Cancel Booking
            </button>
          </form>
        </div>
      </div>
    </div>

<%
    }
    if (!found) {
%>
    <div class="col-12 text-center text-muted py-5">
      <i class="bi bi-ticket-detailed text-secondary display-4"></i>
      <p class="mt-3 fs-5">No bookings found yet! Book your first event today</p>
      <a href="customer-home.jsp" class="btn btn-danger rounded-pill px-4">Explore Events</a>
    </div>
<%
    }
} catch (Exception e) {
	e.printStackTrace(System.out);
} finally {
    if (rs != null) try { rs.close(); } catch (Exception ignore) {}
    if (ps != null) try { ps.close(); } catch (Exception ignore) {}
    if (conn != null) try { conn.close(); } catch (Exception ignore) {}
}
%>
  </div>
</div>

<jsp:include page="/footer.jsp" />
