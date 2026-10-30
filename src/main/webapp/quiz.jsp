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

    String questionText = null;
    String optionA = null;
    String optionB = null;
    String optionC = null;
    String optionD = null;
    int questionId = 0;

    String sql =
        "SELECT question_id, question_text, option_a, option_b, option_c, option_d " +
        "FROM quiz_questions WHERE active = TRUE " +
        "AND question_id NOT IN (" +
        "SELECT question_id FROM quiz_history " +
        "WHERE user_id = ? AND quiz_date = CURDATE()" +
        ") ORDER BY RAND() LIMIT 1";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, userId);

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                questionId = rs.getInt("question_id");
                questionText = rs.getString("question_text");
                optionA = rs.getString("option_a");
                optionB = rs.getString("option_b");
                optionC = rs.getString("option_c");
                optionD = rs.getString("option_d");
            }
        }

    } catch (Exception e) {
        application.log("Unable to load quiz question.", e);
        request.setAttribute(
            "quizError", "Unable to load the quiz. Please try again later."
        );
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Daily Quiz | EcoTrack</title>

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

    <div class="card shadow-sm border-0 mx-auto" style="max-width:700px;">

        <div class="card-body p-4 p-md-5">

            <h2 class="text-success fw-bold mb-2">
                📝 Daily Green Quiz
            </h2>

            <p class="text-muted">
                Answer today's question and earn green points.
            </p>

            <% if (request.getAttribute("quizError") != null) { %>

                <div class="alert alert-danger">
                    <%= request.getAttribute("quizError") %>
                </div>

            <% } else if (questionText != null) { %>

                <h5 class="mt-4 mb-4">
                    <%= questionText %>
                </h5>

                <form action="submitQuiz" method="post">

                    <input type="hidden"
                        name="questionId"
                        value="<%= questionId %>">

                    <div class="form-check border rounded p-3 mb-3">
                        <input class="form-check-input ms-1"
                            type="radio" name="answer" value="A"
                            id="optionA" required>

                        <label class="form-check-label ms-3"
                            for="optionA">
                            <%= optionA %>
                        </label>
                    </div>

                    <div class="form-check border rounded p-3 mb-3">
                        <input class="form-check-input ms-1"
                            type="radio" name="answer" value="B"
                            id="optionB">

                        <label class="form-check-label ms-3"
                            for="optionB">
                            <%= optionB %>
                        </label>
                    </div>

                    <div class="form-check border rounded p-3 mb-3">
                        <input class="form-check-input ms-1"
                            type="radio" name="answer" value="C"
                            id="optionC">

                        <label class="form-check-label ms-3"
                            for="optionC">
                            <%= optionC %>
                        </label>
                    </div>

                    <div class="form-check border rounded p-3 mb-4">
                        <input class="form-check-input ms-1"
                            type="radio" name="answer" value="D"
                            id="optionD">

                        <label class="form-check-label ms-3"
                            for="optionD">
                            <%= optionD %>
                        </label>
                    </div>

                    <button type="submit"
                        class="btn btn-success w-100 py-2">
                        Submit Answer
                    </button>

                </form>

            <% } else { %>

                <div class="alert alert-success mt-4">
                    🎉 You've completed all the available questions
                    for today! Come back tomorrow for another quiz.
                </div>

            <% } %>

            <a href="dashboard.jsp"
                class="btn btn-outline-success w-100 mt-3">
                Back to Dashboard
            </a>

        </div>
    </div>
</div>

</body>
</html>