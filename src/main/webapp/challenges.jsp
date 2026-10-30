<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.ecotrack.DBConnection" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String sql =
        "SELECT challenge_id, title, description, points " +
        "FROM green_challenges WHERE active = TRUE " +
        "ORDER BY challenge_id";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Green Challenges | EcoTrack</title>

    <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">

    <link rel="stylesheet" href="css/style.css">
</head>

<body class="bg-light">

<nav class="navbar navbar-dark bg-success">
    <div class="container">
        <a class="navbar-brand fw-bold" href="dashboard.jsp">
            🌱 EcoTrack
        </a>

        <a href="logout" class="btn btn-light btn-sm">Logout</a>
    </div>
</nav>

<div class="container py-5">

    <h2 class="text-success fw-bold">🌳 Green Challenges</h2>

    <p class="text-muted">
        Complete eco-friendly activities and earn green points.
    </p>
    <% if ("1".equals(request.getParameter("completed"))) { %>
    <div class="alert alert-success">
        Challenge recorded successfully! Your points have been updated.
    </div>
<% } %>

<% if ("1".equals(request.getParameter("alreadyCompleted"))) { %>
    <div class="alert alert-info">
        You've already completed this challenge today.
    </div>
<% } %>

<% if ("1".equals(request.getParameter("error"))) { %>
    <div class="alert alert-danger">
        Unable to record your challenge. Please try again.
    </div>
<% } %>

    <div class="row g-4 mt-2">

        <%
            while (rs.next()) {
                int challengeId = rs.getInt("challenge_id");
                String title = rs.getString("title");
                String description = rs.getString("description");
                int points = rs.getInt("points");
        %>

        <div class="col-md-6 col-lg-4">

            <div class="card h-100 shadow-sm border-0">

                <div class="card-body p-4">

                    <h5 class="text-success fw-bold">
                        <%= title %>
                    </h5>

                    <p><%= description %></p>

                    <p class="fw-bold">
                        🌿 Reward: <%= points %> points
                    </p>

                    <form action="completeChallenge" method="post">

                        <input type="hidden"
                            name="challengeId"
                            value="<%= challengeId %>">

                        <button type="submit"
                            class="btn btn-success w-100">
                            Mark as Completed
                        </button>

                    </form>

                </div>

            </div>

        </div>

        <% } %>

    </div>

    <a href="dashboard.jsp"
       class="btn btn-outline-success mt-4">
        ← Back to Dashboard
    </a>

</div>

</body>
</html>

<%
    } catch (Exception e) {
        application.log("Unable to load green challenges.", e);
%>

<div class="container py-5">
    <div class="alert alert-danger">
        Unable to load challenges. Please try again later.
    </div>
    <a href="dashboard.jsp">Back to Dashboard</a>
</div>

<%
    }
%>