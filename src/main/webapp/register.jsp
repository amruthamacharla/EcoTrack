<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Register | EcoTrack</title>

    <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">

    <link rel="stylesheet" href="css/style.css">
</head>

<body class="auth-page">

<div class="container d-flex justify-content-center align-items-center min-vh-100">

    <div class="auth-card w-100">

        <h2 class="text-center mb-2">Create Your Account 🌱</h2>

        <p class="text-center text-muted mb-4">
            Join EcoTrack and start your green journey!
        </p>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form action="register" method="post">

            <div class="mb-3">
                <label class="form-label">Full Name</label>
                <input type="text" name="fullName"
                    class="form-control"
                    placeholder="Enter your full name"
                    maxlength="100"
                    required>
            </div>

            <div class="mb-3">
                <label class="form-label">Email</label>
                <input type="email" name="email"
                    class="form-control"
                    placeholder="Enter your email"
                    maxlength="150"
                    required>
            </div>

            <div class="mb-3">
                <label class="form-label">Username</label>
                <input type="text" name="username"
                    class="form-control"
                    placeholder="Choose a username"
                    maxlength="50"
                    required>
            </div>

            <div class="mb-3">
                <label class="form-label">Password</label>
                <input type="password" name="password"
                    class="form-control"
                    placeholder="Create a password"
                    minlength="8"
                    required>
            </div>

            <div class="mb-3">
                <label class="form-label">Confirm Password</label>
                <input type="password" name="confirmPassword"
                    class="form-control"
                    placeholder="Re-enter your password"
                    minlength="8"
                    required>
            </div>

            <button type="submit"
                class="btn btn-success w-100">
                Register
            </button>

        </form>

        <p class="text-center mt-4 mb-2">
            Already have an account?
            <a href="login.jsp">Login here</a>
        </p>

        <p class="text-center mb-0">
            <a href="index.jsp">← Back to Home</a>
        </p>

    </div>

</div>

</body>
</html>