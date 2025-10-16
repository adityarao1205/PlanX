<%@ page import="java.util.List" %>
<%@ page import="com.src.model.User" %>
<%@ page import="com.src.model.Event" %>
<%@ page import="com.src.daoimpl.EventDaoImpl" %>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
response.setHeader("Pragma", "no-cache"); // HTTP 1.0
response.setDateHeader("Expires", 0); // Proxies
%>
<style>
body {
  background-color: #0f0f0f;
  color: #f5f5f5;
  font-family: 'Poppins', sans-serif;
}

/* Banner Carousel */
.banner-img {
  width: 100%;
  height: 500px; /* Cinematic look */
  object-fit: cover;
  border-bottom: 4px solid #ff2b2b;
}

.carousel-caption {
  background: rgba(0, 0, 0, 0.5);
  padding: 20px 40px;
  border-radius: 12px;
  backdrop-filter: blur(4px);
}

.carousel-caption h2 {
  font-size: 2rem;
  color: #ff4d4d;
}

.carousel-caption p {
  font-size: 1rem;
  color: #f1f1f1;
}

/* Event Cards */
.card {
  background-color: #1c1c1c;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.card:hover {
  transform: scale(1.04);
  box-shadow: 0 8px 25px rgba(255, 0, 0, 0.3);
}

h2.fw-bold.text-danger {
  color: #ff4040 !important;
}

.modal-content {
  background: #1e1e1e;
  color: #fff;
  border-radius: 15px;
  border: none;
}

.modal-header {
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.modal-body input {
  background: #2a2a2a;
  border: none;
  color: #fff;
}

.modal-body input:focus {
  background: #333;
  box-shadow: 0 0 5px rgba(255, 0, 0, 0.4);
}

.modal h5, .modal label {
  color: #ff4040;
}

.btn-danger {
  background: linear-gradient(90deg, #ff4040, #ff6a6a);
  border: none;
}
</style>

<jsp:include page="/header.jsp" />

<%
User u = (User) session.getAttribute("currentUser");
if (u == null || u.getRole() == null || !u.getRole().trim().equalsIgnoreCase("CUSTOMER")) {
    response.sendRedirect("login.jsp");
    return;
}

// ✅ Fetch all APPROVED events
EventDaoImpl dao = new EventDaoImpl();
List<Event> events = dao.getApprovedEvents();
%>

<!-- =========================
     CUSTOMER HOME - PLANX
========================== -->
<div id="mainCarousel" class="carousel slide" data-bs-ride="carousel">
  <div class="carousel-inner">
    <div class="carousel-item active">
      <img src="assets/images/events/banner1.jpg" class="d-block w-100 banner-img" alt="Dandiya Night">
    </div>

    <div class="carousel-item">
      <img src="assets/images/events/banner2.jpg" class="d-block w-100 banner-img" alt="Hackathon 2025">
    </div>

    <div class="carousel-item">
      <img src="assets/images/events/banner3.jpg" class="d-block w-100 banner-img" alt="Music Fest">
    </div>
  </div>

  <!-- Carousel Controls -->
  <button class="carousel-control-prev" type="button" data-bs-target="#mainCarousel" data-bs-slide="prev">
    <span class="carousel-control-prev-icon"></span>
  </button>
  <button class="carousel-control-next" type="button" data-bs-target="#mainCarousel" data-bs-slide="next">
    <span class="carousel-control-next-icon"></span>
  </button>
</div>

<!-- Recommended Events Section -->
<div class="container py-5">
  <div class="text-center mb-4">
    <h2 class="fw-bold text-danger">Recommended Events</h2>
    <p class="text-white">Book your favourite events happening near you</p>
  </div>

  <% if (events == null || events.isEmpty()) { %>
    <div class="text-center text-white fs-5">No approved events available right now.</div>
  <% } else { %>

  <div class="row g-4">
    <% for (Event e : events) {
        String name = e.getEventName().toLowerCase();
        String imgPath = "assets/images/events/";

        if (name.contains("dhandiya")) imgPath += "dandiya-night.jpg";
        else if (name.contains("hackwave")) imgPath += "hackathon.jpg";
        else if (name.contains("helio")) imgPath += "helio-drama.jpg";
        else if (name.contains("music")) imgPath += "music-fest.jpg";
        else if (name.contains("food")) imgPath += "food-fest.jpg";
        else imgPath += "default.jpg";
    %>

    <div class="col-12 col-sm-6 col-md-4 col-lg-3">
      <div class="card event-card border-0 shadow-sm h-100 rounded-4 overflow-hidden">
        <div class="position-relative">
          <img src="<%= imgPath %>" class="card-img-top" alt="<%= e.getEventName() %>" style="height: 230px; object-fit: cover;">
          <span class="badge bg-danger position-absolute top-0 end-0 m-2 px-3 py-2">New</span>
        </div>
        <div class="card-body d-flex flex-column">
          <h5 class="fw-bold"><%= e.getEventName() %></h5>
          <p class="text-white mb-1"><i class="bi bi-geo-alt"></i> <%= e.getVenue() %></p>
          <p class="text-white"><i class="bi bi-calendar-event"></i> <%= e.getEventDate() %></p>
          <p class="fw-bold text-danger fs-6 mb-3">₹<%= e.getPricePerTicket() %> / Ticket</p>
          <button type="button" 
                  class="btn btn-danger w-100 rounded-pill"
                  onclick="openBookingModal(<%= e.getEventId() %>, '<%= e.getEventName() %>', <%= e.getPricePerTicket() %>, <%= e.getAvailableSeats() %>)">
            <i class="bi bi-ticket"></i> Book Now
          </button>
        </div>
      </div>
    </div>

    <% } %>
  </div>
  <% } %>
</div>

<!-- Booking Modal -->
<div class="modal fade" id="bookingModal" tabindex="-1" aria-labelledby="bookingModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow-lg">
      <div class="modal-header bg-danger text-white">
        <h5 class="modal-title fw-bold" id="bookingModalLabel">Book Tickets</h5>
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
            <label class="form-label">Select Number of Tickets</label>
            <input type="number" class="form-control" name="tickets" id="modalTickets" min="1" required>
            <small class="text-muted">Max available: <span id="maxSeats"></span></small>
          </div>

          <div class="text-center mt-3 mb-4">
            <h5>Total: ₹<span id="modalTotal">0</span></h5>
          </div>

          <div class="text-center">
            <button type="submit" class="btn btn-danger rounded-pill px-4">
              <i class="bi bi-wallet2"></i> Proceed to Pay
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>

<script>
function openBookingModal(eventId, name, price, availableSeats) {
  document.getElementById("modalEventId").value = eventId;
  document.getElementById("modalEventName").value = name;
  document.getElementById("modalEventPrice").value = price;
  document.getElementById("modalTickets").max = availableSeats;
  document.getElementById("maxSeats").innerText = availableSeats;
  document.getElementById("modalTotal").innerText = price;

  let ticketInput = document.getElementById("modalTickets");
  ticketInput.value = 1;

  ticketInput.addEventListener("input", () => {
    const tickets = parseInt(ticketInput.value || 1);
    document.getElementById("modalTotal").innerText = (tickets * price).toFixed(2);
  });

  new bootstrap.Modal(document.getElementById('bookingModal')).show();
}

document.getElementById("bookingForm").addEventListener("submit", function(e) {
  const tickets = document.getElementById("modalTickets").value;
  const price = document.getElementById("modalEventPrice").value;
  const total = tickets * price;

  const totalInput = document.createElement("input");
  totalInput.type = "hidden";
  totalInput.name = "total";
  totalInput.value = total;
  this.appendChild(totalInput);
});
</script>

<jsp:include page="/footer.jsp" />
