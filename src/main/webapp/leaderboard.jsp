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

    String currentUsername =
        (String) session.getAttribute("username");

    String sql =
        "SELECT user_id, username, green_points, " +
        "RANK() OVER (ORDER BY green_points DESC) AS user_rank " +
        "FROM users " +
        "ORDER BY green_points DESC, username ASC";

    String errorMessage = null;
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>Leaderboard | EcoTrack</title>

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">

    <style>
        body {
            background: #f0fdf4;
        }

        .page-title {
            color: #166534;
            font-weight: bold;
        }

        .leaderboard-card {
            background: white;
            border-radius: 18px;
            overflow: hidden;
            border: none;
        }

        .leaderboard-table thead th {
            background: #198754;
            color: white;
            padding: 16px;
            white-space: nowrap;
        }

        .leaderboard-table tbody td {
            padding: 16px;
            vertical-align: middle;
        }

        .leaderboard-table tbody tr:hover {
            background: #f0fdf4;
        }

        .current-user {
            background: #dcfce7 !important;
            font-weight: bold;
        }

        .rank-number {
            font-size: 18px;
            font-weight: bold;
        }

        .score {
            color: #15803d;
            font-weight: bold;
        }

        .back-button {
            background: #198754;
            color: white;
            border: 2px solid #198754;
            padding: 10px 20px;
            border-radius: 10px;
            text-decoration: none;
            display: inline-block;
        }

        .back-button:hover {
            background: white;
            color: #198754;
        }

        .my-position {
            background: #dcfce7;
            border-radius: 12px;
            padding: 18px;
        }
    </style>
</head>

<body>

<nav class="navbar navbar-dark bg-success">
    <div class="container">

        <a class="navbar-brand fw-bold" href="index.jsp">
            🌱 EcoTrack
        </a>

        <div>
            <a href="dashboard.jsp"
               class="btn btn-light btn-sm me-2">
                Dashboard
            </a>

            <a href="logout"
               class="btn btn-outline-light btn-sm">
                Logout
            </a>
        </div>

    </div>
</nav>


<div class="container py-5">

    <h2 class="page-title">
        🏆 EcoTrack Leaderboard
    </h2>

    <p class="text-muted">
        See where you stand among all registered EcoTrack users!
    </p>


    <div class="card leaderboard-card shadow-sm mt-4">

        <div class="table-responsive">

            <table class="table leaderboard-table table-hover mb-0">

                <thead>
                    <tr>
                        <th>Position</th>
                        <th>Username</th>
                        <th>Green Points</th>
                    </tr>
                </thead>

                <tbody>

                <%
                    try (Connection con = DBConnection.getConnection();
                         PreparedStatement ps = con.prepareStatement(sql);
                         ResultSet rs = ps.executeQuery()) {

                        boolean hasUsers = false;

                        while (rs.next()) {

                            hasUsers = true;

                            int listedUserId = rs.getInt("user_id");
                            String listedUsername =
                                rs.getString("username");

                            int points =
                                rs.getInt("green_points");

                            int rank =
                                rs.getInt("user_rank");

                            String medal = "";

                            if (rank == 1) {
                                medal = "🥇";
                            } else if (rank == 2) {
                                medal = "🥈";
                            } else if (rank == 3) {
                                medal = "🥉";
                            }

                            String rowClass =
                                listedUserId == userId
                                    ? "current-user"
                                    : "";
                %>

                    <tr class="<%= rowClass %>">

                        <td>
                            <span class="rank-number">
                                <%= medal %> #<%= rank %>
                            </span>
                        </td>

                        <td>
                            <%= listedUsername %>

                            <% if (listedUserId == userId) { %>
                                <span class="badge bg-success">
                                    You
                                </span>
                            <% } %>
                        </td>

                        <td class="score">
                            🌿 <%= points %>
                        </td>

                    </tr>

                <%
                        }

                        if (!hasUsers) {
                %>

                    <tr>
                        <td colspan="3" class="text-center p-4">
                            No registered users yet.
                        </td>
                    </tr>

                <%
                        }

                    } catch (Exception e) {

                        application.log(
                            "Error loading leaderboard.", e
                        );

                        errorMessage =
                            "Unable to load the leaderboard. " +
                            "Please check the database connection.";
                    }
                %>

                </tbody>

            </table>

        </div>

    </div>


    <% if (errorMessage != null) { %>

        <div class="alert alert-danger mt-3">
            <%= errorMessage %>
        </div>

    <% } %>


    <div class="my-position mt-4">

        <h5 class="text-success fw-bold">
            🌿 Your EcoTrack Journey
        </h5>

        <p class="mb-0">
            Your row is highlighted in green.
            Earn more green points through correct quiz answers
            and completed challenges to improve your position.
        </p>

    </div>


    <div class="text-center mt-4">

        <a href="dashboard.jsp" class="back-button">
            ← Back to Dashboard
        </a>

    </div>

</div>

</body>
</html>