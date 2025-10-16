package com.src.restclient;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Arrays;
import java.util.List;
import com.google.gson.Gson;
import com.src.model.User;

public class UserServiceClient {

    public List<User> fetchAllUsers(String baseApiUrl) throws Exception {
        String endpoint = baseApiUrl + "/users"; // Example: http://localhost:8080/PlanXService/api/users
        System.out.println("🌐 Connecting to: " + endpoint);

        URL url = new URL(endpoint);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Accept", "application/json");

        if (conn.getResponseCode() != 200) {
            throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
        }

        BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
        StringBuilder sb = new StringBuilder();
        String output;
        while ((output = br.readLine()) != null) {
            sb.append(output);
        }

        conn.disconnect();

        // ✅ Parse JSON array into List<User>
        Gson gson = new Gson();
        User[] users = gson.fromJson(sb.toString(), User[].class);
        return Arrays.asList(users);
    }
}