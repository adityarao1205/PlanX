<%@ page import="com.src.model.User" %>
<%@ page import="com.src.daoimpl.EventDaoImpl" %>
<%@ page import="com.src.model.Event" %>

<%
  // ✅ Disable browser caching completely
  response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
  response.setHeader("Pragma", "no-cache"); // HTTP 1.0
  response.setDateHeader("Expires", 0); // Proxies

  // ✅ If user tries to go back after payment — redirect them
  if (session.getAttribute("paymentDone") != null) {
      session.removeAttribute("paymentDone"); // clear flag
      response.sendRedirect("customer-home.jsp?msg=Payment+session+expired");
      return;
  }
%>

<%
User u = (User) session.getAttribute("currentUser");
if (u == null || !"CUSTOMER".equalsIgnoreCase(u.getRole())) {
    response.sendRedirect("login.jsp");
    return;
}

String totalParam = request.getParameter("total");
if (totalParam == null || totalParam.isEmpty()) {
    response.sendRedirect("customer-home.jsp");
    return;
}

int eventId = Integer.parseInt(request.getParameter("eventId"));
int tickets = Integer.parseInt(request.getParameter("tickets"));
double total = Double.parseDouble(totalParam);

EventDaoImpl dao = new EventDaoImpl();
Event e = null;
for (Event ev : dao.getApprovedEvents()) {
    if (ev.getEventId() == eventId) { e = ev; break; }
}
%>

<jsp:include page="/header.jsp" />

<style>
  body {
    background-color: #0f0f0f;
    color: #fff;
    font-family: 'Poppins', sans-serif;
  }
  .card {
    background-color: #1a1a1a;
    color: #fff;
  }
  .form-control {
    background-color: #2b2b2b;
    border: none;
    color: #fff;
  }
  .form-control:focus {
    background-color: #333;
    box-shadow: 0 0 8px rgba(255, 64, 64, 0.6);
  }
  label {
    color: #fff;
  }
  .text-muted {
    color: #ccc !important;
  }
</style>

<div class="container py-5">
  <div class="row justify-content-center">
    <div class="col-md-8">
      <div class="card border-0 shadow-lg rounded-4">
        <div class="card-body p-5">
          <h3 class="fw-bold text-center mb-4 text-danger">Payment</h3>

          <!-- Event Info -->
          <div class="border-bottom pb-3 mb-3">
            <h5><i class="bi bi-calendar-event"></i> <%= e.getEventName() %></h5>
            <p class="mb-0">
              Venue: <%= e.getVenue() %><br>
              Tickets: <%= tickets %><br>
              <span class="fw-bold text-white">Total: ₹<%= total %></span>
            </p>
          </div>

          <!-- Payment Options -->
          <h6 class="fw-bold mb-3">Choose Payment Method</h6>
          <ul class="nav nav-pills mb-4" id="paymentTabs" role="tablist">
            <li class="nav-item" role="presentation">
              <button class="nav-link active" id="upi-tab" data-bs-toggle="pill" data-bs-target="#upi" type="button" role="tab">UPI</button>
            </li>
            <li class="nav-item" role="presentation">
              <button class="nav-link" id="card-tab" data-bs-toggle="pill" data-bs-target="#card" type="button" role="tab">Card</button>
            </li>
            <li class="nav-item" role="presentation">
              <button class="nav-link" id="net-tab" data-bs-toggle="pill" data-bs-target="#net" type="button" role="tab">Net Banking</button>
            </li>
          </ul>

          <div class="tab-content" id="paymentTabContent">
            <!-- ✅ UPI Payment Form -->
            <div class="tab-pane fade show active" id="upi" role="tabpanel">
              <form id="upiForm" action="ConfirmBookingServlet" method="post" autocomplete="off">
                <input type="hidden" name="eventId" value="<%= eventId %>">
                <input type="hidden" name="tickets" value="<%= tickets %>">
                <input type="hidden" name="total" value="<%= total %>">

                <div class="mb-3">
                  <label class="form-label fw-semibold">Enter UPI ID</label>
                  <input type="text" class="form-control rounded-pill" name="upiId" id="upiId" placeholder="example@upi" required>
                  <small id="upiError" class="text-danger d-none">⚠️ Please enter a valid UPI ID (e.g. aditya@ybl).</small>
                </div>

                <div class="text-center mt-4">
                  <button type="button" id="payNowBtn" class="btn btn-danger px-5 rounded-pill">
                    <i class="bi bi-cash-stack"></i> Pay ₹<%= total %>
                  </button>
                </div>
              </form>
            </div>

            <!-- Other Tabs -->
            <div class="tab-pane fade" id="card" role="tabpanel">
              <p class="text-muted">Card payments are currently unavailable.</p>
            </div>
            <div class="tab-pane fade" id="net" role="tabpanel">
              <p class="text-muted">Net Banking is coming soon!</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- ✅ Success Animation Modal -->
<div class="modal fade" id="paymentSuccess" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 text-center p-5 bg-dark text-white">
      <div class="text-success mb-3">
        <i class="bi bi-check-circle-fill" style="font-size: 3rem;"></i>
      </div>
      <h4 class="fw-bold text-white">Payment Successful!</h4>
      <p class="text-muted mb-4">Redirecting to My Bookings...</p>
      <div class="spinner-border text-success"></div>
    </div>
  </div>
</div>

<!-- ✅ UPI Validation & Payment Logic -->
<script>
  const payBtn = document.getElementById('payNowBtn');
  const form = document.getElementById('upiForm');
  const upiInput = document.getElementById('upiId');
  const errorText = document.getElementById('upiError');

  payBtn.addEventListener('click', () => {
    const upi = upiInput.value.trim();
    const upiPattern = /^[a-zA-Z0-9.\-_]{2,50}@[a-zA-Z]{2,20}$/;

    if (!upiPattern.test(upi)) {
      errorText.classList.remove('d-none');
      upiInput.focus();
      return;
    }

    errorText.classList.add('d-none');
    payBtn.disabled = true;
    new bootstrap.Modal(document.getElementById('paymentSuccess')).show();
    setTimeout(() => form.submit(), 2000);
  });
//✅ Clear all payment form fields if user revisits the page (Back-tab issue)
  window.addEventListener("pageshow", function (event) {
    if (event.persisted || performance.getEntriesByType("navigation")[0].type === "back_forward") {
      // Clear all input values
      const form = document.getElementById("upiForm");
      if (form) {
        form.reset();
        document.getElementById('upiId').value = ""; // clear UPI ID explicitly
      }
    }
  });

</script>

<jsp:include page="/footer.jsp" />
