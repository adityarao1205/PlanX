<%@ page import="com.src.model.User" %>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
response.setHeader("Pragma", "no-cache"); // HTTP 1.0
response.setDateHeader("Expires", 0); // Proxies
%>

<jsp:include page="/header.jsp" />

<%
User u = (User) session.getAttribute("currentUser");
if (u == null || 
(!"ORGANIZER".equalsIgnoreCase(u.getRole()) && 
 !"ADMIN".equalsIgnoreCase(u.getRole()))) {
 response.sendRedirect("login.jsp");
 return;
}
%>

<h2 class="text-center text-danger mb-4">Add New Event</h2>

<div class="card shadow-lg border-0 p-4 mx-auto" style="max-width: 600px;">
    <form method="post" action="${pageContext.request.contextPath}/addEvent">
    <div class="mb-3">
      <label class="form-label">Event Name</label>
      <input name="eventName" class="form-control" required>
    </div>
    <div class="mb-3">
      <label class="form-label">Date</label>
      <input type="date" name="eventDate" class="form-control" required>
    </div>
    <div class="mb-3">
      <label class="form-label">Venue</label>
      <input name="venue" class="form-control" required>
    </div>
    <div class="mb-3">
      <label class="form-label">Location</label>
      <input name="location" class="form-control" required>
    </div>
    <div class="mb-3">
      <label class="form-label">Price per Ticket</label>
      <input type="number" step="0.01" name="price" class="form-control" required>
    </div>
    <div class="mb-3">
      <label class="form-label">Total Seats</label>
      <input type="number" name="totalSeats" class="form-control" required>
    </div>
    <div class="text-center">
      <input type="submit" value="Add Event" class="btn btn-danger px-4">
    </div>
  </form>

  <% if (request.getParameter("msg") != null) { %>
    <p class="text-success text-center mt-3"><%= request.getParameter("msg") %></p>
  <% } %>

  <% if (request.getParameter("error") != null) { %>
    <p class="text-danger text-center mt-3"><%= request.getParameter("error") %></p>
  <% } %>
</div>
<script>
  window.addEventListener("pageshow", function(event) {
    if (event.persisted) {
      // If user navigated back, reset form
      document.querySelector("form").reset();
    }
  });
</script>

<jsp:include page="/footer.jsp" />