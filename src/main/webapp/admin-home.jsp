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
if (u == null || !"ADMIN".equalsIgnoreCase(u.getRole())) {
    response.sendRedirect("login.jsp");
    return;
}

// Fetch events for all categories
EventDaoImpl dao = new EventDaoImpl();
List<Event> pendingEvents = dao.getPendingEvents();
List<Event> declinedEvents = dao.getEventsByStatusDynamic("DECLINED");
List<Event> approvedEvents = dao.getApprovedEvents();
%>

<div class="container py-5">

  <!-- Heading -->
  <div class="text-center mb-5">
    <h2 class="fw-bold text-danger">Welcome, <%=u.getName()%></h2>
    <p class="text-muted fs-5">Manage all events efficiently from one place.</p>
  </div>
  
  <div class="text-center mb-4">
  <a href="addevent.jsp" class="btn btn-danger rounded-pill px-4">
    <i class="bi bi-plus-circle"></i> Add New Event
  </a>
</div>

  <!-- SUCCESS & ERROR MESSAGES -->
  <% if (request.getParameter("msg") != null) { %>
    <div class="alert alert-success text-center fw-semibold rounded-pill">
      <%= request.getParameter("msg") %>
    </div>
  <% } else if (request.getParameter("error") != null) { %>
    <div class="alert alert-danger text-center fw-semibold rounded-pill">
      <%= request.getParameter("error") %>
    </div>
  <% } %>

  <!-- CLEANUP BUTTON -->
  <div class="text-center mb-4">
    <form action="adminAction" method="post" onsubmit="return confirm('Delete all completed events (past-date)?');">
      <input type="hidden" name="action" value="cleanup">
      <button type="submit" class="btn btn-outline-danger rounded-pill px-4 fw-bold">
        <i class="bi bi-trash3"></i> Clean Completed Events
      </button>
    </form>
  </div>

  <!-- ===================== PENDING EVENTS ===================== -->
  <div class="card shadow border-0 rounded-4 mb-5">
    <div class="card-body">
      <h4 class="fw-bold text-center mb-4 text-warning">
        <i class="bi bi-hourglass-split"></i> Pending Events
      </h4>

      <% if (pendingEvents == null || pendingEvents.isEmpty()) { %>
        <div class="text-center py-4 text-muted">No pending events.</div>
      <% } else { %>
        <div class="table-responsive">
          <table class="table table-striped align-middle text-center">
            <thead class="table-dark">
              <tr>
                <th>ID</th>
                <th>Event Name</th>
                <th>Date</th>
                <th>Venue</th>
                <th>Organizer ID</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              <% for (Event e : pendingEvents) { %>
                <tr>
                  <td><%= e.getEventId() %></td>
                  <td><%= e.getEventName() %></td>
                  <td><%= e.getEventDate() %></td>
                  <td><%= e.getVenue() %></td>
                  <td><%= e.getOrganizerId() %></td>
                  <td>
                    <form action="adminAction" method="post" class="d-inline">
                      <input type="hidden" name="eventId" value="<%= e.getEventId() %>">
                      <input type="hidden" name="action" value="approve">
                      <button type="submit" class="btn btn-success btn-sm rounded-pill px-3">
                        <i class="bi bi-check2-circle"></i> Approve
                      </button>
                    </form>

                    <form action="adminAction" method="post" class="d-inline">
                      <input type="hidden" name="eventId" value="<%= e.getEventId() %>">
                      <input type="hidden" name="action" value="decline">
                      <button type="submit" class="btn btn-danger btn-sm rounded-pill px-3">
                        <i class="bi bi-x-circle"></i> Decline
                      </button>
                    </form>
                  </td>
                </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      <% } %>
    </div>
  </div>

  <!-- ===================== DECLINED EVENTS ===================== -->
  <div class="card shadow border-0 rounded-4 mb-5">
    <div class="card-body">
      <h4 class="fw-bold text-center mb-4 text-danger">
        <i class="bi bi-x-octagon"></i> Declined Events
      </h4>

      <% if (declinedEvents == null || declinedEvents.isEmpty()) { %>
        <div class="text-center py-4 text-muted">No declined events.</div>
      <% } else { %>
        <div class="table-responsive">
          <table class="table table-striped align-middle text-center">
            <thead class="table-dark">
              <tr>
                <th>ID</th>
                <th>Event Name</th>
                <th>Date</th>
                <th>Venue</th>
                <th>Organizer ID</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              <% for (Event e : declinedEvents) { %>
                <tr>
                  <td><%= e.getEventId() %></td>
                  <td><%= e.getEventName() %></td>
                  <td><%= e.getEventDate() %></td>
                  <td><%= e.getVenue() %></td>
                  <td><%= e.getOrganizerId() %></td>
                  <td>
                    <form action="adminAction" method="post" class="d-inline">
                      <input type="hidden" name="eventId" value="<%= e.getEventId() %>">
                      <input type="hidden" name="action" value="reinstate">
                      <button type="submit" class="btn btn-info btn-sm rounded-pill px-3">
                        <i class="bi bi-arrow-repeat"></i> Reinstate
                      </button>
                    </form>

                    <form action="adminAction" method="post" class="d-inline">
                      <input type="hidden" name="eventId" value="<%= e.getEventId() %>">
                      <input type="hidden" name="action" value="delete">
                      <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill px-3">
                        <i class="bi bi-trash"></i> Delete
                      </button>
                    </form>
                  </td>
                </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      <% } %>
    </div>
  </div>

  <!-- ===================== APPROVED EVENTS ===================== -->
  <div class="card shadow border-0 rounded-4 mb-5">
    <div class="card-body">
      <h4 class="fw-bold text-center mb-4 text-success">
        <i class="bi bi-check-circle"></i> Approved Events
      </h4>

      <% if (approvedEvents == null || approvedEvents.isEmpty()) { %>
        <div class="text-center py-4 text-muted">No approved events yet.</div>
      <% } else { %>
        <div class="table-responsive">
          <table class="table table-striped align-middle text-center">
            <thead class="table-dark">
              <tr>
                <th>ID</th>
                <th>Event Name</th>
                <th>Date</th>
                <th>Venue</th>
                <th>Organizer ID</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              <% for (Event e : approvedEvents) { %>
                <tr>
                  <td><%= e.getEventId() %></td>
                  <td><%= e.getEventName() %></td>
                  <td><%= e.getEventDate() %></td>
                  <td><%= e.getVenue() %></td>
                  <td><%= e.getOrganizerId() %></td>
                  <td>
                    <form action="adminAction" method="post" class="d-inline">
                      <input type="hidden" name="eventId" value="<%= e.getEventId() %>">
                      <input type="hidden" name="action" value="delete">
                      <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill px-3">
                        <i class="bi bi-trash3"></i> Delete
                      </button>
                    </form>
                  </td>
                </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      <% } %>
    </div>
  </div>

  <!-- LOGOUT -->
  <div class="text-center mt-4">
    <a href="LogoutServlet" class="btn btn-outline-danger px-4 rounded-pill">
      <i class="bi bi-box-arrow-right"></i> Logout
    </a>
  </div>
</div>

<jsp:include page="/footer.jsp" />