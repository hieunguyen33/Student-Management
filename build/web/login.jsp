<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Bounce logged-in users straight to dashboard
    if (session != null && session.getAttribute("loggedInUser") != null) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }
    String errorMessage = (String) request.getAttribute("errorMessage");
    String username     = (String) request.getAttribute("username");
    if (username == null) username = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login – Student Management</title>
    <!-- Bootstrap 5 CDN -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.4);
            overflow: hidden;
            width: 100%;
            max-width: 420px;
        }
        .login-header {
            background: linear-gradient(135deg, #0f3460, #533483);
            color: white;
            padding: 2rem;
            text-align: center;
        }
        .login-header .icon {
            font-size: 3rem;
            margin-bottom: 0.5rem;
        }
        .login-body {
            padding: 2rem;
        }
        .form-control:focus {
            border-color: #0f3460;
            box-shadow: 0 0 0 0.2rem rgba(15,52,96,.25);
        }
        .btn-login {
            background: linear-gradient(135deg, #0f3460, #533483);
            border: none;
            letter-spacing: 1px;
        }
        .btn-login:hover {
            background: linear-gradient(135deg, #533483, #0f3460);
        }
        .hint-box {
            background: #f0f4ff;
            border-left: 4px solid #0f3460;
            padding: 0.75rem 1rem;
            border-radius: 0 8px 8px 0;
            font-size: 0.85rem;
        }
    </style>
</head>
<body>
<div class="login-card">
    <div class="login-header">
        <div class="icon"><i class="bi bi-mortarboard-fill"></i></div>
        <h4 class="mb-0">Student Management</h4>
        <small class="opacity-75">Sign in to continue</small>
    </div>
    <div class="login-body">

        <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
        <div class="alert alert-danger d-flex align-items-center" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>
            <%= errorMessage %>
        </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/login" method="POST" novalidate>
            <div class="mb-3">
                <label for="username" class="form-label fw-semibold">
                    <i class="bi bi-person me-1"></i>Username
                </label>
                <input type="text" class="form-control form-control-lg"
                       id="username" name="username"
                       value="<%= username %>"
                       placeholder="Enter username" required autofocus>
            </div>
            <div class="mb-4">
                <label for="password" class="form-label fw-semibold">
                    <i class="bi bi-lock me-1"></i>Password
                </label>
                <div class="input-group">
                    <input type="password" class="form-control form-control-lg"
                           id="password" name="password"
                           placeholder="Enter password" required>
                    <button class="btn btn-outline-secondary" type="button"
                            onclick="togglePassword()">
                        <i class="bi bi-eye" id="eyeIcon"></i>
                    </button>
                </div>
            </div>
            <button type="submit" class="btn btn-login btn-primary w-100 btn-lg text-white mb-3">
                <i class="bi bi-box-arrow-in-right me-2"></i>Sign In
            </button>
        </form>

        <div class="hint-box">
            <i class="bi bi-info-circle me-1"></i>
            <strong>Demo credentials:</strong><br>
            Username: <code>admin</code> &nbsp;|&nbsp; Password: <code>admin123</code>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function togglePassword() {
        const pwd  = document.getElementById('password');
        const icon = document.getElementById('eyeIcon');
        if (pwd.type === 'password') {
            pwd.type = 'text';
            icon.classList.replace('bi-eye', 'bi-eye-slash');
        } else {
            pwd.type = 'password';
            icon.classList.replace('bi-eye-slash', 'bi-eye');
        }
    }
</script>
</body>
</html>