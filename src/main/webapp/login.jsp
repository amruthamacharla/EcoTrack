<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Login | EcoTrack</title>

    <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">

    <link rel="stylesheet" href="css/style.css">
</head>

<body class="auth-page">

<div class="container d-flex justify-content-center align-items-center min-vh-100">

    <div class="auth-card w-100">

        <h2 class="text-center mb-2">Welcome Back! 🌿</h2>

        <p class="text-center text-muted mb-4">
            Login to continue your green journey.
        </p>

        <% if ("1".equals(request.getParameter("registered"))) { %>
            <div class="alert alert-success">
                Registration successful! Please log in.
            </div>
        <% } %>

        <% if ("1".equals(request.getParameter("loggedout"))) { %>
            <div class="alert alert-info">
                You have logged out successfully.
            </div>
        <% } %>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form action="login" method="post">

            <div class="mb-3">
                <label class="form-label">Username or Email</label>

                <input type="text"
                    name="usernameOrEmail"
                    class="form-control"
                    placeholder="Enter username or email"
                    required>
            </div>

            <div class="mb-3">
                <label class="form-label">Password</label>

                <input type="password"
                    name="password"
                    class="form-control"
                    placeholder="Enter your password"
                    required>
            </div>

            <button type="submit"
                class="btn btn-success w-100">
                Login
            </button>

        </form>

        <p class="text-center mt-4 mb-2">
            Don't have an account?
            <a href="register.jsp">Register here</a>
        </p>

        <p class="text-center mb-0">
            <a href="index.jsp">← Back to Home</a>
        </p>

    </div>

</div>

</body>
</html>