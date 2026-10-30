package com.ecotrack.servlet;

import com.ecotrack.DBConnection;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/submitQuiz")
public class QuizServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final int POINTS_PER_CORRECT_ANSWER = 10;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        String questionIdValue = request.getParameter("questionId");
        String selectedAnswer = request.getParameter("answer");

        int questionId;

        try {
            questionId = Integer.parseInt(questionIdValue);
        } catch (Exception e) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid question."
            );
            return;
        }

        if (selectedAnswer == null ||
            !selectedAnswer.matches("[ABCD]")) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Please select a valid answer."
            );
            return;
        }

        Connection con = null;

        try {
            con = com.ecotrack.DBConnection.getConnection();
            con.setAutoCommit(false);

            // Lock the question row while processing the submission.
            String questionSql =
                "SELECT correct_answer, explanation " +
                "FROM quiz_questions " +
                "WHERE question_id = ? AND active = TRUE " +
                "FOR UPDATE";

            String correctAnswer;
            String explanation;

            try (PreparedStatement ps =
                     con.prepareStatement(questionSql)) {

                ps.setInt(1, questionId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        con.rollback();
                        response.sendError(
                            HttpServletResponse.SC_NOT_FOUND,
                            "Question not found."
                        );
                        return;
                    }

                    correctAnswer = rs.getString("correct_answer");
                    explanation = rs.getString("explanation");
                }
            }

            // Verify the question has not already been attempted today.
            String checkSql =
                "SELECT history_id FROM quiz_history " +
                "WHERE user_id = ? AND question_id = ? " +
                "AND quiz_date = CURDATE()";

            try (PreparedStatement ps =
                     con.prepareStatement(checkSql)) {

                ps.setInt(1, userId);
                ps.setInt(2, questionId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        con.rollback();
                        response.sendRedirect(
                            request.getContextPath() +
                            "/quiz.jsp?alreadyAttempted=1"
                        );
                        return;
                    }
                }
            }

            boolean isCorrect =
                selectedAnswer.equalsIgnoreCase(correctAnswer);

            int pointsEarned =
                isCorrect ? POINTS_PER_CORRECT_ANSWER : 0;

            // Save this user's answer.
            String historySql =
                "INSERT INTO quiz_history " +
                "(user_id, question_id, quiz_date, selected_answer, " +
                "is_correct, points_earned) " +
                "VALUES (?, ?, CURDATE(), ?, ?, ?)";

            try (PreparedStatement ps =
                     con.prepareStatement(historySql)) {

                ps.setInt(1, userId);
                ps.setInt(2, questionId);
                ps.setString(3, selectedAnswer);
                ps.setBoolean(4, isCorrect);
                ps.setInt(5, pointsEarned);

                ps.executeUpdate();
            }

            // Update only the logged-in user's points.
            if (isCorrect) {
                String updateSql =
                    "UPDATE users SET green_points = green_points + ? " +
                    "WHERE user_id = ?";

                try (PreparedStatement ps =
                         con.prepareStatement(updateSql)) {

                    ps.setInt(1, pointsEarned);
                    ps.setInt(2, userId);

                    int updated = ps.executeUpdate();

                    if (updated != 1) {
                        throw new SQLException("User account not found.");
                    }
                }
            }

            con.commit();

            // Store feedback for the result page.
            session.setAttribute("quizCorrect", isCorrect);
            session.setAttribute("quizPointsEarned", pointsEarned);
            session.setAttribute("quizExplanation", explanation);
            session.setAttribute("quizCorrectAnswer", correctAnswer);

            response.sendRedirect(
                request.getContextPath() + "/quizResult.jsp"
            );

        } catch (SQLException e) {

            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException rollbackError) {
                    getServletContext().log(
                        "Could not roll back quiz submission.",
                        rollbackError
                    );
                }
            }

            getServletContext().log(
                "Database error during quiz submission.", e
            );

            response.sendRedirect(
                request.getContextPath() + "/quiz.jsp?error=1"
            );

        } finally {

            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException closeError) {
                    getServletContext().log(
                        "Could not close quiz database connection.",
                        closeError
                    );
                }
            }
        }
    }
}