<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>EcoTrack - Smart Waste Management</title>

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">

    <link rel="stylesheet" href="css/style.css">

    <style>
        body {
            background: #f4fbf5;
        }

        .hero {
            background: linear-gradient(135deg, #166534, #22c55e);
            color: white;
            padding: 65px 20px;
            border-radius: 0 0 30px 30px;
        }

        .feature-card {
            border: none;
            border-radius: 18px;
            height: 100%;
            transition: transform 0.2s ease;
        }

        .feature-card:hover {
            transform: translateY(-5px);
        }

        .feature-icon {
            font-size: 38px;
        }

        .feature-card h5 {
            color: #166534;
            font-weight: bold;
        }
    </style>
</head>

<body>

<!-- Navigation -->
<nav class="navbar navbar-expand-lg navbar-dark bg-success">

    <div class="container">

        <a class="navbar-brand fw-bold" href="index.jsp">
            🌱 EcoTrack
        </a>

        <button class="navbar-toggler"
                type="button"
                data-bs-toggle="collapse"
                data-bs-target="#mainNav"
                aria-controls="mainNav"
                aria-expanded="false"
                aria-label="Toggle navigation">

            <span class="navbar-toggler-icon"></span>

        </button>

        <div class="collapse navbar-collapse" id="mainNav">

            <div class="navbar-nav ms-auto align-items-lg-center">

                <a class="nav-link" href="index.jsp">
                    Home
                </a>

                <a class="nav-link" href="#features">
                    Features
                </a>

                <a class="btn btn-light text-success fw-bold ms-lg-3 mt-2 mt-lg-0"
                   href="login.jsp">
                    Login
                </a>

                <a class="btn btn-warning fw-bold ms-lg-2 mt-2 mt-lg-0"
                   href="register.jsp">
                    Register
                </a>

            </div>

        </div>

    </div>

</nav>


<!-- Hero Section -->
<section class="hero text-center">

    <div class="container">

        <h1 class="display-4 fw-bold">
            Welcome to EcoTrack 🌍
        </h1>

        <p class="lead mt-3">
            Smart Waste Classification and Green Points System
        </p>

        <p>
            Learn responsible waste management, complete green challenges,
            and make every action count.
        </p>

        <div class="mt-4">

            <a href="register.jsp"
               class="btn btn-warning btn-lg fw-bold me-2">
                Get Started
            </a>

            <a href="login.jsp"
               class="btn btn-outline-light btn-lg">
                Login
            </a>

        </div>

    </div>

</section>


<!-- Features -->
<div class="container py-5" id="features">

    <h2 class="text-center fw-bold text-success mb-2">
        Explore EcoTrack
    </h2>

    <p class="text-center text-muted mb-5">
        Everything you need to build greener habits.
    </p>

    <div class="row g-4">

        <!-- Daily Quiz -->
        <div class="col-md-6 col-lg-4">

            <div class="card feature-card shadow-sm">
                <div class="card-body text-center p-4">

                    <div class="feature-icon">📝</div>

                    <h5 class="mt-3">Daily Quiz</h5>

                    <p>
                        Test your environmental knowledge
                        and earn green points.
                    </p>

                    <a href="login.jsp"
                       class="btn btn-success">
                        Start Quiz
                    </a>

                </div>
            </div>

        </div>


        <!-- Waste Disposal Guide -->
        <div class="col-md-6 col-lg-4" id="disposal-guide">

            <div class="card feature-card shadow-sm">
                <div class="card-body text-center p-4">

                    <div class="feature-icon">♻️</div>

                    <h5 class="mt-3">Waste Disposal Guide</h5>

                    <p>
                        Learn how to separate and dispose
                        of different types of waste.
                    </p>

                    <a href="login.jsp"
                       class="btn btn-success">
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
                        Earn points for correct quiz answers
                        and completed green challenges.
                    </p>

                    <a href="login.jsp"
                       class="btn btn-success">
                        View Points
                    </a>

                </div>
            </div>

        </div>


        <!-- Green Challenges -->
        <div class="col-md-6 col-lg-4" id="challenges">

            <div class="card feature-card shadow-sm">
                <div class="card-body text-center p-4">

                    <div class="feature-icon">🌳</div>

                    <h5 class="mt-3">Green Challenges</h5>

                    <p>
                        Complete eco-friendly activities
                        and collect green points.
                    </p>

                    <a href="login.jsp"
                       class="btn btn-success">
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
                        Track your points, quizzes,
                        and completed challenges.
                    </p>

                    <a href="login.jsp"
                       class="btn btn-success">
                        View Progress
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
                        Compare your green points
                        with other registered users.
                    </p>

                    <a href="login.jsp"
                       class="btn btn-success">
                        View Leaderboard
                    </a>

                </div>
            </div>

        </div>

    </div>

</div>


<!-- Footer -->
<footer class="text-center text-muted py-4">

    <p>
        🌱 EcoTrack — Small Actions, Greener Future
    </p>

</footer>


<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>
</html>