package com.ecotrack.servlet;

import com.ecotrack.DBConnection;
import com.ecotrack.PasswordUtil;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Check that all fields are provided
        if (fullName == null || email == null ||
            username == null || password == null ||
            confirmPassword == null ||
            fullName.trim().isEmpty() ||
            email.trim().isEmpty() ||
            username.trim().isEmpty() ||
            password.isEmpty() ||
            confirmPassword.isEmpty()) {

            request.setAttribute("error", "Please fill in all fields.");
            request.getRequestDispatcher("/register.jsp")
                   .forward(request, response);
            return;
        }

        fullName = fullName.trim();
        email = email.trim();
        username = username.trim();

        // Check password length
        if (password.length() < 8) {
            request.setAttribute(
                "error", "Password must contain at least 8 characters."
            );
            request.getRequestDispatcher("/register.jsp")
                   .forward(request, response);
            return;
        }

        // Check whether passwords match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/register.jsp")
                   .forward(request, response);
            return;
        }

        String sql = "INSERT INTO users " +
                     "(full_name, email, username, password_hash, green_points) " +
                     "VALUES (?, ?, ?, ?, 0)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            // Hash the password before storing it
            String hashedPassword = PasswordUtil.hashPassword(password);

            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, username);
            ps.setString(4, hashedPassword);

            ps.executeUpdate();

            // Registration successful
            response.sendRedirect(
                request.getContextPath() +
                "/login.jsp?registered=1"
            );

        } catch (SQLException e) {

            // MySQL duplicate username or email
            if ("23000".equals(e.getSQLState())) {
                request.setAttribute(
                    "error",
                    "That email or username is already registered. " +
                    "Please use a different one."
                );
            } else {
                getServletContext().log(
                    "Database error during registration.", e
                );

                request.setAttribute(
                    "error",
                    "Registration failed because of a server error. " +
                    "Please try again."
                );
            }

            request.getRequestDispatcher("/register.jsp")
                   .forward(request, response);

        } catch (Exception e) {

            getServletContext().log(
                "Unexpected error during registration.", e
            );

            request.setAttribute(
                "error",
                "Something went wrong. Please try again."
            );

            request.getRequestDispatcher("/register.jsp")
                   .forward(request, response);
        }
    }
}