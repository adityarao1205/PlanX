package com.src.servlets;

import com.src.model.User;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.lang.reflect.Type;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.List;

@WebServlet("/viewAllUsers")
public class ViewAllUsersServlet extends HttpServlet {

    // Change this if your REST base url / port differs
    private static final String USERS_API = "http://localhost:8080/PlanXService/api/users";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpURLConnection conn = null;
        try {
            URL url = new URL(USERS_API);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/json");
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(5000);

            int status = conn.getResponseCode();
            if (status != 200) {
                req.setAttribute("error", "Failed to fetch users: HTTP " + status);
                req.getRequestDispatcher("/viewAllUsers.jsp").forward(req, resp);
                return;
            }

            try (InputStream is = conn.getInputStream();
                 InputStreamReader isr = new InputStreamReader(is, StandardCharsets.UTF_8);
                 BufferedReader br = new BufferedReader(isr)) {

                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) sb.append(line);

                String json = sb.toString();
                Gson gson = new Gson();
                Type listType = new TypeToken<List<User>>(){}.getType();
                List<User> users = gson.fromJson(json, listType);

                req.setAttribute("usersList", users);
                req.getRequestDispatcher("/viewAllUsers.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error fetching users: " + e.getMessage());
            req.getRequestDispatcher("/viewAllUsers.jsp").forward(req, resp);
        } finally {
            if (conn != null) conn.disconnect();
        }
    }
}