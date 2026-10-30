<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.ecotrack.DBConnection" %>

<%
    // Check whether the user is logged in
    Integer userId = (Integer) session.getAttribute("userId");

    if (userId == null) {
        response.sendRedirect(
            request.getContextPath() + "/login.jsp"
        );
        return;
    }

    String fullName = (String) session.getAttribute("fullName");
    String username = (String) session.getAttribute("username");

    if (fullName == null || fullName.trim().isEmpty()) {
        fullName = username != null ? username : "User";
    }

    int greenPoints = 0;
    int quizzesCompleted = 0;
    int challengesCompleted = 0;

    String dashboardError = null;

    // Load the logged-in user's statistics
    try (Connection con = DBConnection.getConnection()) {

        // Get personal green points
        String pointsSql =
            "SELECT green_points FROM users WHERE user_id = ?";

        try (PreparedStatement ps = con.prepareStatement(pointsSql)) {
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    greenPoints = rs.getInt("green_points");
                }
            }
        }

        // Count distinct days with quiz attempts
        String quizSql =
            "SELECT COUNT(DISTINCT quiz_date) AS total " +
            "FROM quiz_history WHERE user_id = ?";

        try (PreparedStatement ps = con.prepareStatement(quizSql)) {
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    quizzesCompleted = rs.getInt("total");
                }
            }
        }

        // Count completed challenges
        String challengeSql =
            "SELECT COUNT(*) AS total " +
            "FROM challenge_history WHERE user_id = ?";

        try (PreparedStatement ps = con.prepareStatement(challengeSql)) {
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    challengesCompleted = rs.getInt("total");
                }
            }
        }

    } catch (Exception e) {
        application.log("Error loading EcoTrack dashboard.", e);

        dashboardError =
            "Unable to load your statistics. Please try again.";
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>EcoTrack | My Dashboard</title>

    <!-- Bootstrap CSS -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">

    <style>
        body {
            background: #f0fdf4;
            font-family: Arial, sans-serif;
        }

        .navbar-brand {
            font-size: 23px;
            font-weight: bold;
        }

        .welcome-section {
            background: linear-gradient(135deg, #dcfce7, #bbf7d0);
            border-radius: 20px;
            padding: 30px;
        }

        .dashboard-heading {
            color: #166534;
            font-weight: bold;
        }

        .stat-card,
        .feature-card,
        .details-card {
            border: none;
            border-radius: 18px;
        }

        .stat-card,
        .feature-card {
            transition: transform 0.3s ease,
                        box-shadow 0.3s ease;
        }

        .stat-card:hover,
        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(22, 101, 52, 0.12);
        }

        .feature-card {
            height: 100%;
        }

        .feature-icon {
            font-size: 38px;
        }

        .feature-card h5 {
            color: #166534;
            font-weight: bold;
        }

        .stat-number {
            font-size: 38px;
            font-weight: bold;
            color: #15803d;
        }

        .feature-card .btn {
            background-color: #198754;
            color: #ffffff;
            border: 2px solid #198754;
            border-radius: 10px;
            padding: 10px 15px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .feature-card .btn:hover {
            background-color: #ffffff;
            color: #198754;
            border-color: #198754;
            transform: translateY(-2px);
        }

        .feature-card .btn:focus-visible {
            outline: 3px solid #86efac;
            outline-offset: 3px;
        }

        .details-card {
            background: #ffffff;
        }

        /* Visual progress chart cards */
        .chart-card {
            background: #ffffff;
            border: none;
            border-radius: 18px;
            height: 100%;
            transition: box-shadow 0.3s ease;
        }

        .chart-card:hover {
            box-shadow: 0 10px 25px rgba(22, 101, 52, 0.12);
        }

        .chart-container {
            position: relative;
            width: 100%;
            max-width: 420px;
            height: 300px;
            margin: 0 auto;
        }

        .chart-note {
            color: #64748b;
            font-size: 14px;
        }

        footer {
            color: #64748b;
        }

        @media (max-width: 576px) {
            .welcome-section {
                padding: 22px;
            }

            .stat-number {
                font-size: 32px;
            }

            .chart-container {
                height: 260px;
            }
        }
    </style>

</head>

<body>

<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-success">

    <div class="container">

        <a class="navbar-brand"
           href="<%= request.getContextPath() %>/index.jsp">
            🌱 EcoTrack
        </a>

        <button class="navbar-toggler"
                type="button"
                data-bs-toggle="collapse"
                data-bs-target="#dashboardNav"
                aria-controls="dashboardNav"
                aria-expanded="false"
                aria-label="Toggle navigation">

            <span class="navbar-toggler-icon"></span>

        </button>

        <div class="collapse navbar-collapse" id="dashboardNav">

            <div class="navbar-nav ms-auto">

                <a class="nav-link"
                   href="<%= request.getContextPath() %>/index.jsp">
                    Home
                </a>

                <a class="nav-link"
                   href="<%= request.getContextPath() %>/quiz.jsp">
                    Daily Quiz
                </a>

                <a class="nav-link"
                   href="<%= request.getContextPath() %>/disposable.jsp">
                    Waste Disposal Guide
                </a>

                <a class="nav-link"
                   href="<%= request.getContextPath() %>/challenges.jsp">
                    Green Challenges
                </a>

                <a class="nav-link"
                   href="<%= request.getContextPath() %>/leaderboard.jsp">
                    Leaderboard
                </a>

                <a class="btn btn-light btn-sm ms-lg-3 mt-2 mt-lg-0"
                   href="<%= request.getContextPath() %>/logout">
                    Logout
                </a>

            </div>

        </div>

    </div>

</nav>


<!-- Main Dashboard -->
<div class="container py-5">

    <!-- Welcome Section -->
    <div class="welcome-section mb-4">

        <h2 class="dashboard-heading">
            Welcome, <%= fullName %>! 🌿
        </h2>

        <p class="mb-0">
            Every small green action makes a difference.
            Continue your journey towards a cleaner planet!
        </p>

    </div>


    <!-- Database Error -->
    <% if (dashboardError != null) { %>

        <div class="alert alert-warning">
            <%= dashboardError %>
        </div>

    <% } %>


    <!-- Statistics -->
    <h3 class="dashboard-heading mb-3">My Progress</h3>

    <div class="row g-4">

        <!-- Green Points -->
        <div class="col-md-4">

            <div class="card stat-card shadow-sm h-100">

                <div class="card-body text-center p-4">

                    <div class="feature-icon">🌿</div>

                    <h5 class="mt-2">My Green Points</h5>

                    <div class="stat-number">
                        <%= greenPoints %>
                    </div>

                    <p class="text-muted mb-0">Points earned</p>

                </div>

            </div>

        </div>


        <!-- Quiz Activity -->
        <div class="col-md-4">

            <div class="card stat-card shadow-sm h-100">

                <div class="card-body text-center p-4">

                    <div class="feature-icon">📝</div>

                    <h5 class="mt-2">Quiz Activity</h5>

                    <div class="stat-number">
                        <%= quizzesCompleted %>
                    </div>

                    <p class="text-muted mb-0">
                        Days with quiz attempts
                    </p>

                </div>

            </div>

        </div>


        <!-- Challenge Activity -->
        <div class="col-md-4">

            <div class="card stat-card shadow-sm h-100">

                <div class="card-body text-center p-4">

                    <div class="feature-icon">🌳</div>

                    <h5 class="mt-2">Green Challenges</h5>

                    <div class="stat-number">
                        <%= challengesCompleted %>
                    </div>

                    <p class="text-muted mb-0">
                        Challenges completed
                    </p>

                </div>

            </div>

        </div>

    </div>


    <!-- Feature Cards -->
    <h3 class="dashboard-heading mt-5 mb-3">
        Explore EcoTrack
    </h3>

    <div class="row g-4">

        <!-- Daily Quiz -->
        <div class="col-md-6 col-lg-4">

            <div class="card feature-card shadow-sm">

                <div class="card-body text-center p-4">

                    <div class="feature-icon">📝</div>

                    <h5 class="mt-3">Daily Quiz</h5>

                    <p>
                        Test your waste-management knowledge
                        and earn green points.
                    </p>

                    <a href="<%= request.getContextPath() %>/quiz.jsp"
                       class="btn w-100">
                        Start Quiz
                    </a>

                </div>

            </div>

        </div>


        <!-- Waste Disposal Guide -->
        <div class="col-md-6 col-lg-4">

            <div class="card feature-card shadow-sm">

                <div class="card-body text-center p-4">

                    <div class="feature-icon">♻️</div>

                    <h5 class="mt-3">Waste Disposal Guide</h5>

                    <p>
                        Learn how to separate and dispose
                        of waste responsibly.
                    </p>

                    <a href="<%= request.getContextPath() %>/disposable.jsp"
                       class="btn w-100">
                        Explore Guide
                    </a>

                </div>

            </div>

        </div>


        <!-- Green Points -->
        <div class="col-md-6 col-lg-4">

            <div class="card feature-card shadow-sm">

                <div class="card-body text-center p-4">

                    <div class="feature-icon">🌿</div>

                    <h5 class="mt-3">Green Points</h5>

                    <p>
                        View your personal score and track
                        the points you have earned.
                    </p>

                    <a href="#my-points" class="btn w-100">
                        View Points
                    </a>

                </div>

            </div>

        </div>


        <!-- Green Challenges -->
        <div class="col-md-6 col-lg-4">

            <div class="card feature-card shadow-sm">

                <div class="card-body text-center p-4">

                    <div class="feature-icon">🌳</div>

                    <h5 class="mt-3">Green Challenges</h5>

                    <p>
                        Complete eco-friendly activities
                        and earn additional green points.
                    </p>

                    <a href="<%= request.getContextPath() %>/challenges.jsp"
                       class="btn w-100">
                        View Challenges
                    </a>

                </div>

            </div>

        </div>


        <!-- My Progress -->
        <div class="col-md-6 col-lg-4">

            <div class="card feature-card shadow-sm">

                <div class="card-body text-center p-4">

                    <div class="feature-icon">📊</div>

                    <h5 class="mt-3">My Progress</h5>

                    <p>
                        Review your points, quiz activity
                        and completed challenges visually.
                    </p>

                    <a href="#visual-progress" class="btn w-100">
                        View My Progress
                    </a>

                </div>

            </div>

        </div>


        <!-- Leaderboard -->
        <div class="col-md-6 col-lg-4">

            <div class="card feature-card shadow-sm">

                <div class="card-body text-center p-4">

                    <div class="feature-icon">🏆</div>

                    <h5 class="mt-3">Leaderboard</h5>

                    <p>
                        Compare your green points with
                        other registered EcoTrack users.
                    </p>

                    <a href="<%= request.getContextPath() %>/leaderboard.jsp"
                       class="btn w-100">
                        View Leaderboard
                    </a>

                </div>

            </div>

        </div>

    </div>


    <!-- Green Points Details -->
    <div id="my-points" class="card details-card shadow-sm mt-5">

        <div class="card-body p-4">

            <h4 class="dashboard-heading">
                🌿 My Green Points
            </h4>

            <p class="mb-0">
                Your current score is
                <strong><%= greenPoints %> green points</strong>.
                Keep learning and completing green activities!
            </p>

        </div>

    </div>


    <!-- Activity Summary -->
    <div id="progress-details"
         class="card details-card shadow-sm mt-4">

        <div class="card-body p-4">

            <h4 class="dashboard-heading">
                📊 My Activity Summary
            </h4>

            <p>
                Days with quiz attempts:
                <strong><%= quizzesCompleted %></strong>
            </p>

            <p class="mb-0">
                Challenge completions:
                <strong><%= challengesCompleted %></strong>
            </p>

        </div>

    </div>


    <!-- Visual Progress Charts -->
    <div id="visual-progress" class="mt-5">

        <h3 class="dashboard-heading mb-3">
            📊 My Visual Progress
        </h3>

        <p class="text-muted mb-4">
            Visualise your EcoTrack activity using your personal statistics.
        </p>

        <div class="row g-4">

            <!-- Doughnut Chart -->
            <div class="col-md-6">

                <div class="card chart-card shadow-sm">

                    <div class="card-body p-4">

                        <h5 class="dashboard-heading text-center mb-4">
                            My Activity Distribution
                        </h5>

                        <div class="chart-container">

                            <canvas id="activityChart"
                                    aria-label="Doughnut chart showing quiz days and completed challenges"
                                    role="img">
                            </canvas>

                        </div>

                        <p class="chart-note text-center mt-3 mb-0">
                            Quiz days and completed challenges.
                        </p>

                    </div>

                </div>

            </div>


            <!-- Bar Chart -->
            <div class="col-md-6">

                <div class="card chart-card shadow-sm">

                    <div class="card-body p-4">

                        <h5 class="dashboard-heading text-center mb-4">
                            My EcoTrack Statistics
                        </h5>

                        <div class="chart-container">

                            <canvas id="statisticsChart"
                                    aria-label="Bar chart showing green points, quiz days and challenges"
                                    role="img">
                            </canvas>

                        </div>

                        <p class="chart-note text-center mt-3 mb-0">
                            Your current points and activity totals.
                        </p>

                    </div>

                </div>

            </div>

        </div>

    </div>


    <!-- Footer -->
    <footer class="text-center mt-5">

        <p>🌱 EcoTrack — Small Actions, Greener Future</p>

    </footer>

</div>


<!-- Bootstrap JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- Chart.js Library -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<!-- Chart Configuration -->
<script>
document.addEventListener("DOMContentLoaded", function () {

    // Personal values loaded by the JSP from MySQL.
    const greenPoints = <%= greenPoints %>;
    const quizzesCompleted = <%= quizzesCompleted %>;
    const challengesCompleted = <%= challengesCompleted %>;

    // Show a helpful message if Chart.js could not load.
    if (typeof Chart === "undefined") {

        const chartSection = document.getElementById("visual-progress");

        if (chartSection) {
            chartSection.insertAdjacentHTML(
                "beforeend",
                '<div class="alert alert-warning mt-3">' +
                'The charts could not load. Please check your internet connection and refresh the page.' +
                '</div>'
            );
        }

        return;
    }

    // Activity Doughnut Chart
    const activityCanvas = document.getElementById("activityChart");

    if (activityCanvas) {

        new Chart(activityCanvas, {

            type: "doughnut",

            data: {

                labels: [
                    "Quiz Activity",
                    "Completed Challenges"
                ],

                datasets: [{

                    data: [
                        quizzesCompleted,
                        challengesCompleted
                    ],

                    backgroundColor: [
                        "#198754",
                        "#86efac"
                    ],

                    borderColor: "#ffffff",
                    borderWidth: 3,
                    hoverOffset: 8

                }]

            },

            options: {

                responsive: true,
                maintainAspectRatio: false,

                plugins: {

                    legend: {
                        position: "bottom"
                    },

                    tooltip: {
                        enabled: true
                    }

                }

            }

        });

    }


    // Statistics Bar Chart
    const statisticsCanvas =
        document.getElementById("statisticsChart");

    if (statisticsCanvas) {
    new Chart(statisticsCanvas, {

            type: "bar",

            data: {

                labels: [
                    "Green Points",
                    "Quiz Days",
                    "Challenges"
                ],

                datasets: [{

                    label: "Your Statistics",

                    data: [
                        greenPoints,
                        quizzesCompleted,
                        challengesCompleted
                    ],

                    backgroundColor: [
                        "#198754",
                        "#4ade80",
                        "#86efac"
                    ],

                    borderColor: [
                        "#14532d",
                        "#16a34a",
                        "#22c55e"
                    ],

                    borderWidth: 1,
                    borderRadius: 8

                }]

            },

            options: {

                responsive: true,
                maintainAspectRatio: false,

                scales: {

                    y: {
                        beginAtZero: true,

                        ticks: {
                            precision: 0
                        }
                    }

                },

                plugins: {

                    legend: {
                        display: false
                    },

                    tooltip: {
                        enabled: true
                    }

                }

            }

        });

    }

});
</script>

</body>
</html>