<%@ page import="com.src.model.User" %>
<%
User user = (User) session.getAttribute("currentUser");
String role = (user != null) ? user.getRole().toUpperCase() : "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>PlanX - Smart Event Booking</title>

  <!-- Bootstrap & Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

 <!-- Favicon -->
<link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/events/favicon.png">

  <!-- Custom Styles -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>

<body class="bg-dark text-light">

<!-- ================== NAVBAR ================== -->
<nav class="navbar navbar-expand-lg navbar-dark bg-black shadow-sm sticky-top">
  <div class="container py-1">
    <!-- Logo + Brand -->
   <!-- Navbar Logo -->
<a class="navbar-brand d-flex align-items-center fw-bold" href="${pageContext.request.contextPath}/home.jsp">
  <img src="${pageContext.request.contextPath}/assets/images/events/planx-logo.png" alt="PlanX Logo" height="38" class="me-2">
  <span class="text-danger fs-4">PlanX</span>
</a>
 

    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navMenu">
      <ul class="navbar-nav ms-auto align-items-center">

        <% if ("ADMIN".equals(role)) { %>
          <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admindashboard">Dashboard</a></li>
          <li class="nav-item"><a class="nav-link text-danger fw-bold" href="${pageContext.request.contextPath}/LogoutServlet">Logout</a></li>

        <% } else if ("ORGANIZER".equals(role)) { %>
          <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/organizer-home.jsp">My Events</a></li>
          <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/addevent.jsp">Add Event</a></li>
          <li class="nav-item"><a class="nav-link text-danger fw-bold" href="${pageContext.request.contextPath}/LogoutServlet">Logout</a></li>

        <% } else if ("CUSTOMER".equals(role)) { %>
          <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/customer-home.jsp">Events</a></li>
          <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/mybookings.jsp">My Bookings</a></li>
          <li class="nav-item"><a class="nav-link text-danger fw-bold" href="${pageContext.request.contextPath}/LogoutServlet">Logout</a></li>

        <% } else { %>
          <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/login.jsp">Login</a></li>
          <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/register.jsp">Register</a></li>
        <% } %>

      </ul>
    </div>
  </div>
</nav>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
