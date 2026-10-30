package com.ecotrack;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL =
            "jdbc:mysql://localhost:3306/ecotrack";

    private static final String USER = "root";

    // Replace this with your actual MySQL password.
    private static final String PASSWORD = "Amrutha@10";

    public static Connection getConnection() throws SQLException {

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException(
                    "MySQL JDBC driver not found.", e);
        }

        return DriverManager.getConnection(
                URL, USER, PASSWORD);
    }
}