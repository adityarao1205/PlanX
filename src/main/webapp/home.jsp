<%@ page import="java.util.List" %>
<%@ page import="com.src.model.Event" %>
<%@ page import="com.src.model.User" %>
<%@ page import="com.src.daoimpl.EventDaoImpl" %>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
response.setHeader("Pragma", "no-cache"); // HTTP 1.0
response.setDateHeader("Expires", 0); // Proxies
%>
<jsp:include page="/header.jsp" />

<%
User u = (User) session.getAttribute("currentUser");
String role = (u != null && u.getRole() != null) ? u.getRole().trim().toUpperCase() : "GUEST";
EventDaoImpl dao = new EventDaoImpl();
List<Event> events = dao.getApprovedEvents();
%>

<!-- =========================
     HERO CAROUSEL SECTION
========================== -->
<div id="heroCarousel" class="carousel slide" data-bs-ride="carousel">
  <div class="carousel-inner">
    <div class="carousel-item active">
      <img src="assets/images/banner1.jpg" class="d-block w-100 banner-img" alt="Banner 1">
      <div class="carousel-caption d-none d-md-block">
        <h2 class="fw-bold text-light display-6">Discover the Best Events Near You</h2>
        <p class="text-light">Book concerts, hackathons, dramas, and more instantly on PlanX!</p>
      </div>
    </div>
    <div class="carousel-item">
      <img src="assets/images/banner2.jpg" class="d-block w-100 banner-img" alt="Banner 2">
      <div class="carousel-caption d-none d-md-block">
        <h2 class="fw-bold text-light display-6">Experience the Magic of Live Events</h2>
        <p class="text-light">Get your tickets before they sell out!</p>
      </div>
    </div>
    <div class="carousel-item">
      <img src="assets/images/banner3.jpg" class="d-block w-100 banner-img" alt="Banner 3">
      <div class="carousel-caption d-none d-md-block">
        <h2 class="fw-bold text-light display-6">Organize Events Like a Pro</h2>
        <p class="text-light">Join as an Organizer and make your events shine.</p>
      </div>
    </div>
  </div>
  <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
    <span class="carousel-control-prev-icon"></span>
  </button>
  <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
    <span class="carousel-control-next-icon"></span>
  </button>
</div>

<!-- =========================
     FEATURED EVENTS SECTION
========================== -->
<div class="container py-5">
  <h3 class="fw-bold mb-4 text-danger text-center">🔥 Trending Events</h3>

  <% if (events == null || events.isEmpty()) { %>
    <p class="text-center text-muted fs-5">No events available yet. Check back soon!</p>
  <% } else { %>

  <div class="row g-4">
    <% for (Event e : events) {
         String name = e.getEventName().toLowerCase();
         String imgPath = "assets/images/events/";
         if (name.contains("dandiya")) imgPath += "dandiya-night.jpg";
         else if (name.contains("hackathon")) imgPath += "hackathon.jpg";
         else if (name.contains("helio")) imgPath += "helio-drama.jpg";
         else if (name.contains("music")) imgPath += "music-fest.jpg";
         else if (name.contains("food")) imgPath += "food-fest.jpg";
         else imgPath += "default.jpg";
    %>

    <div class="col-12 col-sm-6 col-md-4 col-lg-3">
      <div class="card event-card border-0 shadow-lg rounded-4 h-100">
        <img src="<%= imgPath %>" class="card-img-top rounded-top-4" alt="<%= e.getEventName() %>">
        <div class="card-body d-flex flex-column">
          <h5 class="card-title fw-bold"><%= e.getEventName() %></h5>
          <p class="text-muted mb-1"><i class="bi bi-geo-alt"></i> <%= e.getVenue() %></p>
          <p class="text-muted"><i class="bi bi-calendar-event"></i> <%= e.getEventDate() %></p>
          <p class="fw-semibold text-danger mb-3">₹<%= e.getPricePerTicket() %> / ticket</p>

          <% if ("CUSTOMER".equals(role)) { %>
          <button type="button" class="btn btn-danger mt-auto rounded-pill"
            onclick="openBookingModal(<%= e.getEventId() %>, '<%= e.getEventName() %>', <%= e.getPricePerTicket() %>)">
            <i class="bi bi-ticket-detailed"></i> Book Now
          </button>
          <% } else if ("GUEST".equals(role)) { %>
          <a href="login.jsp" class="btn btn-outline-danger mt-auto rounded-pill">Login to Book</a>
          <% } else { %>
          <button class="btn btn-secondary mt-auto rounded-pill" disabled>View Only</button>
          <% } %>
        </div>
      </div>
    </div>
    <% } %>
  </div>
  <% } %>
</div>

<!-- =========================
     BOOKING MODAL
========================== -->
<div class="modal fade" id="bookingModal" tabindex="-1" aria-labelledby="bookingModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow">
      <div class="modal-header bg-danger text-white">
        <h5 class="modal-title fw-bold">Book Event</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <form id="bookingForm" action="payment.jsp" method="get">
          <input type="hidden" name="eventId" id="modalEventId">
          <div class="mb-3">
            <label class="form-label">Event Name</label>
            <input type="text" class="form-control" id="modalEventName" readonly>
          </div>
          <div class="mb-3">
            <label class="form-label">Price per Ticket</label>
            <input type="text" class="form-control" id="modalEventPrice" readonly>
          </div>
          <div class="mb-3">
            <label class="form-label">Tickets</label>
            <input type="number" class="form-control" name="tickets" id="modalTickets" min="1" max="10" value="1" required>
          </div>
          <div class="text-center">
            <p class="fw-bold fs-5">Total: ₹<span id="modalTotal">0</span></p>
          </div>
          <div class="text-center">
            <button type="submit" class="btn btn-danger rounded-pill px-4">Proceed to Pay</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>

<script>
function openBookingModal(eventId, name, price) {
  document.getElementById("modalEventId").value = eventId;
  document.getElementById("modalEventName").value = name;
  document.getElementById("modalEventPrice").value = price;
  document.getElementById("modalTotal").innerText = price;

  let modalTickets = document.getElementById("modalTickets");
  modalTickets.addEventListener('input', function() {
    const total = price * this.value;
    document.getElementById("modalTotal").innerText = total;
  });

  new bootstrap.Modal(document.getElementById('bookingModal')).show();
}
</script>

<jsp:include page="/footer.jsp" />
