<%@ page import="java.util.List" %>
<%@ page import="com.src.model.User" %>
<%@ page import="com.src.model.Event" %>
<%@ page import="com.src.daoimpl.EventDaoImpl" %>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
response.setHeader("Pragma", "no-cache"); // HTTP 1.0
response.setDateHeader("Expires", 0); // Proxies
%>
<jsp:include page="/header.jsp" />

<%
User u = (User) session.getAttribute("currentUser");
if (u == null || !"ORGANIZER".equalsIgnoreCase(u.getRole())) {
    response.sendRedirect("login.jsp");
    return;
}

EventDaoImpl dao = new EventDaoImpl();
List<Event> events = dao.getEventsByOrganizer(u.getUserId());
%>

<!-- =========================
     ORGANIZER DASHBOARD
========================== -->
<div class="container py-5">
  <div class="text-center mb-5">
    <h2 class="fw-bold text-danger">Welcome, <%=u.getName()%></h2>
    <p class="text-white fs-5">Manage your events efficiently with PlanX Organizer Portal.</p>
  </div>

  <% if (events == null || events.isEmpty()) { %>
    <div class="text-center text-white fs-5 py-5">
      <i class="bi bi-calendar-x display-4 text-secondary"></i>
      <p class="mt-3">You haven’t created any events yet.</p>
      <a href="addevent.jsp" class="btn btn-danger rounded-pill mt-3 px-4">
        <i class="bi bi-plus-circle"></i> Add Your First Event
      </a>
    </div>
  <% } else { %>

  <div class="row g-4">
    <% 
      for (Event e : events) {
          String name = e.getEventName().toLowerCase();
          String imgPath = "assets/images/events/";

          if (name.contains("dandiya")) imgPath += "dandiya-night.jpg";
          else if (name.contains("hackathon")) imgPath += "hackathon.jpg";
          else if (name.contains("helio")) imgPath += "helio-drama.jpg";
          else if (name.contains("music")) imgPath += "music-fest.jpg";
          else if (name.contains("food")) imgPath += "food-fest.jpg";
          else imgPath += "default.jpg";

          String status = e.getStatus().toUpperCase();
          String badgeClass = "bg-warning";
          String badgeText = "Pending Approval";

          if ("APPROVED".equals(status)) {
              badgeClass = "bg-success";
              badgeText = "Approved ✅";
          } else if ("DECLINED".equals(status)) {
              badgeClass = "bg-danger";
              badgeText = "Declined ❌";
          }
    %>

    <div class="col-12 col-sm-6 col-md-4 col-lg-3">
      <div class="card border-0 shadow-lg rounded-4 h-100 event-card">
        <img src="<%= imgPath %>" class="card-img-top rounded-top-4" alt="<%= e.getEventName() %>" height="200" style="object-fit: cover;">
        <div class="card-body d-flex flex-column">
          <h5 class="fw-bold text-white"><%= e.getEventName() %></h5>
          <span class="badge <%= badgeClass %> text-white mb-2 px-3 py-2 rounded-pill"><%= badgeText %></span>
          <p class="text-white mb-1"><i class="bi bi-geo-alt"></i> <%= e.getVenue() %></p>
          <p class="text-white mb-1"><i class="bi bi-calendar-event"></i> <%= e.getEventDate() %></p>
          <p class="fw-semibold text-danger mb-3">₹<%= e.getPricePerTicket() %> / ticket</p>
          <div class="d-flex justify-content-between mt-auto">
            <small class="text-secondary">Total: <%= e.getTotalSeats() %></small>
            <small class="text-secondary">Available: <%= e.getAvailableSeats() %></small>
          </div>
        </div>
      </div>
    </div>

    <% } %>
  </div>
  <% } %>
</div>

<!-- Floating Add Button -->
<a href="addevent.jsp" class="btn btn-danger rounded-circle position-fixed shadow-lg" 
   style="bottom: 40px; right: 40px; width: 60px; height: 60px; display: flex; align-items: center; justify-content: center;">
  <i class="bi bi-plus-lg fs-4 text-white"></i>
</a>

<jsp:include page="/footer.jsp" />
