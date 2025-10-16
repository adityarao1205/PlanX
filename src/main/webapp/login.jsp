<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login | PlanX</title>

  <!-- Bootstrap & Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

  <!-- Favicon -->
  <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/events/favicon.png">

  <style>
    body {
      background: url('${pageContext.request.contextPath}/assets/images/events/banner1.jpg') no-repeat center center/cover;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      font-family: 'Poppins', sans-serif;
      color: white;
      position: relative;
    }

    .overlay {
      position: absolute;
      top: 0; left: 0;
      width: 100%; height: 100%;
      background: rgba(0, 0, 0, 0.85);
      backdrop-filter: blur(5px);
      z-index: 0;
    }

    .login-card {
      position: relative;
      z-index: 1;
      background: rgba(20, 20, 20, 0.95);
      border-radius: 20px;
      box-shadow: 0 0 25px rgba(255, 0, 0, 0.3);
      width: 100%;
      max-width: 420px;
      padding: 2.5rem;
      animation: fadeIn 0.8s ease-in-out;
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(-15px); }
      to { opacity: 1; transform: translateY(0); }
    }

    .logo img {
      height: 70px;
      filter: drop-shadow(0 0 8px rgba(255, 64, 64, 0.8));
    }

    .login-card h3 {
      color: #ff4040;
      font-weight: 700;
    }

    /* ✅ Fixed form input text color and glow */
    .form-control {
      background: #222;
      border: none;
      border-radius: 50px;
      padding: 12px 20px;
      color: #fff !important;
      font-weight: 500;
      caret-color: #ff4040;
      transition: all 0.3s ease;
    }

    .form-control::placeholder {
      color: #bbb !important;
      opacity: 1;
    }

    .form-control:focus {
      background: #2b2b2b;
      color: #fff !important;
      box-shadow: 0 0 10px rgba(255, 64, 64, 0.6);
      outline: none;
    }

    .btn-login {
      border-radius: 50px;
      padding: 10px 20px;
      background: linear-gradient(90deg, #ff4040, #ff6a6a);
      color: white;
      font-weight: 600;
      transition: all 0.3s ease;
      border: none;
    }

    .btn-login:hover {
      transform: translateY(-2px);
      box-shadow: 0 5px 15px rgba(255, 0, 0, 0.4);
    }

    .text-muted {
      color: #ccc !important;
    }

    .text-muted a {
      color: #ff4040;
      font-weight: 600;
      text-decoration: none;
      transition: color 0.3s ease;
    }

    .text-muted a:hover {
      color: #ff7070;
      text-decoration: underline;
    }

    .footer-text {
      font-size: 0.9rem;
      color: #aaa;
    }
  </style>
</head>

<body>
  <div class="overlay"></div>

  <div class="login-card text-center">
    <div class="logo mb-3">
      <img src="${pageContext.request.contextPath}/assets/images/events/planx-logo.png" alt="PlanX Logo">
    </div>
    <h3>Welcome </h3>
    <p class="text-secondary mb-4">Book your favorite events instantly</p>

    <form action="login" method="post">
      <div class="mb-3 text-start">
        <label class="form-label fw-semibold">Email</label>
        <input type="email" name="email" class="form-control" required placeholder="you@example.com">
      </div>
      <div class="mb-4 text-start">
        <label class="form-label fw-semibold">Password</label>
        <input type="password" name="password" class="form-control" required placeholder="••••••••">
      </div>
      <div class="d-grid mb-3">
        <button type="submit" class="btn btn-login">Login</button>
      </div>
    </form>

    <div class="text-center mt-3">
      <span class="text-muted">Don’t have an account? </span>
      <a href="register.jsp">Register</a>
    </div>

    <div class="mt-3">
      <font color="red">${param.error}</font>
      <font color="lightgreen">${param.msg}</font>
    </div>

    <div class="footer-text mt-4">
      © 2025 PlanX | Smart Event Booking
    </div>
  </div>
</body>
</html>
