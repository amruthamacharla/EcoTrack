<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Boolean correct = (Boolean) session.getAttribute("quizCorrect");
    Integer points = (Integer) session.getAttribute("quizPointsEarned");
    String explanation =
        (String) session.getAttribute("quizExplanation");
    String correctAnswer =
        (String) session.getAttribute("quizCorrectAnswer");

    if (correct == null || points == null) {
        response.sendRedirect("quiz.jsp");
        return;
    }

    // Remove feedback so refreshing cannot show a stale result.
    session.removeAttribute("quizCorrect");
    session.removeAttribute("quizPointsEarned");
    session.removeAttribute("quizExplanation");
    session.removeAttribute("quizCorrectAnswer");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Quiz Result | EcoTrack</title>

    <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">

    <link rel="stylesheet" href="css/style.css">
</head>

<body class="bg-light">

<div class="container py-5">

    <div class="card shadow-sm border-0 mx-auto text-center"
         style="max-width:600px;">

        <div class="card-body p-5">

            <% if (correct) { %>

                <h1 class="text-success">🎉 Correct Answer!</h1>

                <p class="lead mt-3">
                    Excellent work! You're helping create a greener planet.
                </p>

                <h2 class="text-success fw-bold mt-4">
                    +<%= points %> Green Points
                </h2>

            <% } else { %>

                <h1 class="text-danger">Not Quite! 🌱</h1>

                <p class="lead mt-3">
                    Don't worry. Every question is a chance to learn.
                </p>

                <h5 class="mt-4">
                    Correct option: <%= correctAnswer %>
                </h5>

                <p class="text-muted">
                    No points were awarded for this answer.
                </p>

            <% } %>

            <% if (explanation != null && !explanation.isEmpty()) { %>

                <div class="alert alert-info mt-4">
                    <strong>Did you know?</strong><br>
                    <%= explanation %>
                </div>

            <% } %>

            <a href="quiz.jsp"
               class="btn btn-success w-100 mt-3">
                Next Question
            </a>

            <a href="dashboard.jsp"
               class="btn btn-outline-success w-100 mt-3">
                View My Dashboard
            </a>

        </div>
    </div>
</div>

</body>
</html>