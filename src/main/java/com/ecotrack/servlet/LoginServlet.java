package com.ecotrack.servlet;

import com.ecotrack.DBConnection;
import com.ecotrack.PasswordUtil;

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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String usernameOrEmail =
                request.getParameter("usernameOrEmail");

        String password = request.getParameter("password");

        if (usernameOrEmail == null || password == null ||
            usernameOrEmail.trim().isEmpty() || password.isEmpty()) {

            request.setAttribute(
                "error", "Please enter your username/email and password."
            );

            request.getRequestDispatcher("/login.jsp")
                   .forward(request, response);
            return;
        }

        String sql =
            "SELECT user_id, full_name, username, password_hash " +
            "FROM users WHERE username = ? OR email = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            String loginValue = usernameOrEmail.trim();

            ps.setString(1, loginValue);
            ps.setString(2, loginValue);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    String storedHash = rs.getString("password_hash");

                    if (PasswordUtil.checkPassword(password, storedHash)) {

                        // Start a fresh session after successful login
                        HttpSession oldSession = request.getSession(false);

                        if (oldSession != null) {
                            oldSession.invalidate();
                        }

                        HttpSession session = request.getSession(true);

                        session.setAttribute(
                            "userId", rs.getInt("user_id")
                        );

                        session.setAttribute(
                            "fullName", rs.getString("full_name")
                        );

                        session.setAttribute(
                            "username", rs.getString("username")
                        );

                        session.setMaxInactiveInterval(30 * 60);

                        response.sendRedirect(
                            request.getContextPath() + "/dashboard.jsp"
                        );
                        return;
                    }
                }

                request.setAttribute(
                    "error", "Invalid username/email or password."
                );

                request.getRequestDispatcher("/login.jsp")
                       .forward(request, response);
            }

        } catch (SQLException e) {

            getServletContext().log("Database error during login.", e);

            request.setAttribute(
                "error",
                "Unable to connect to the database. Please try again."
            );

            request.getRequestDispatcher("/login.jsp")
                   .forward(request, response);

        } catch (Exception e) {

            getServletContext().log("Unexpected error during login.", e);

            request.setAttribute(
                "error", "Something went wrong. Please try again."
            );

            request.getRequestDispatcher("/login.jsp")
                   .forward(request, response);
        }
    }
}