 package com.src.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utility class for managing Oracle JDBC connection.
 * Singleton design pattern ensures only one connection instance is used.
 */
public class DBConnection {
    private static final String URL = "jdbc:oracle:thin:@localhost:1521:xe"; // XE default
    private static final String USERNAME = "system"; // change if needed
    private static final String PASSWORD = "TIGER";  // change if needed

    private static Connection connection = null;

    // Private constructor prevents instantiation
    private DBConnection() {}

    /**
     * Returns a singleton DB connection object.
     */
    public static Connection getConnection() throws SQLException {
        if (connection == null || connection.isClosed()) {
            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            } catch (ClassNotFoundException e) {
                System.out.println("Oracle JDBC Driver not found!");
                e.printStackTrace();
            } catch (SQLException e) {
                System.out.println("Database connection failed!");
                throw e;
            }
        }
        return connection;
    }
}
