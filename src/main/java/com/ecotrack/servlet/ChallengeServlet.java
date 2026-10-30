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

@WebServlet("/completeChallenge")
public class ChallengeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

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

        int challengeId;

        try {
            challengeId = Integer.parseInt(
                request.getParameter("challengeId")
            );
        } catch (Exception e) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid challenge."
            );
            return;
        }

        Connection con = null;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // Get the reward from the database, not from the browser.
            String challengeSql =
                "SELECT points FROM green_challenges " +
                "WHERE challenge_id = ? AND active = TRUE FOR UPDATE";

            int points;

            try (PreparedStatement ps =
                     con.prepareStatement(challengeSql)) {

                ps.setInt(1, challengeId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        con.rollback();
                        response.sendError(
                            HttpServletResponse.SC_NOT_FOUND,
                            "Challenge not found."
                        );
                        return;
                    }

                    points = rs.getInt("points");
                }
            }

            // Record the completion for this user and date.
            String insertSql =
                "INSERT INTO challenge_history " +
                "(user_id, challenge_id, completed_on, points_earned) " +
                "VALUES (?, ?, CURDATE(), ?)";

            try (PreparedStatement ps =
                     con.prepareStatement(insertSql)) {

                ps.setInt(1, userId);
                ps.setInt(2, challengeId);
                ps.setInt(3, points);

                ps.executeUpdate();
            }

            // Award points only to this logged-in user.
            String updateSql =
                "UPDATE users SET green_points = green_points + ? " +
                "WHERE user_id = ?";

            try (PreparedStatement ps =
                     con.prepareStatement(updateSql)) {

                ps.setInt(1, points);
                ps.setInt(2, userId);

                int updated = ps.executeUpdate();

                if (updated != 1) {
                    throw new SQLException("User account not found.");
                }
            }

            con.commit();

            response.sendRedirect(
                request.getContextPath() +
                "/challenges.jsp?completed=1"
            );

        } catch (SQLException e) {

            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException rollbackError) {
                    getServletContext().log(
                        "Challenge rollback failed.", rollbackError
                    );
                }
            }

            // MySQL duplicate-key error: already completed today.
            if ("23000".equals(e.getSQLState())) {
                response.sendRedirect(
                    request.getContextPath() +
                    "/challenges.jsp?alreadyCompleted=1"
                );
            } else {
                getServletContext().log(
                    "Error completing green challenge.", e
                );

                response.sendRedirect(
                    request.getContextPath() +
                    "/challenges.jsp?error=1"
                );
            }

        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException closeError) {
                    getServletContext().log(
                        "Could not close database connection.",
                        closeError
                    );
                }
            }
        }
    }
}