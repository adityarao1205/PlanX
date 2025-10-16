<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.src.model.User" %>
<html>
<head>
    <title>All Users</title>
    <style>
        body { font-family: Arial; margin: 40px; background:#111; color:#eee; }
        table { border-collapse: collapse; width: 90%; margin: 0 auto; }
        th, td { border: 1px solid #444; padding: 10px; text-align: left; }
        th { background-color: #222; color:#ffd; }
        h2 { text-align: center; color:#ff4444; }
    </style>
</head>
<body>
    <h2>Registered Users</h2>
    <%
        List<User> users = (List<User>) request.getAttribute("usersList");
        String error = (String) request.getAttribute("error");

        if (error != null) {
    %>
        <p style="color:#f88; text-align:center;"><%= error %></p>
    <%
        } else if (users == null || users.isEmpty()) {
    %>
        <p style="text-align:center;">No users found.</p>
    <%
        } else {
    %>
        <table>
            <tr>
                <th>User ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Role</th>
            </tr>
            <%
                for (User u : users) {
            %>
            <tr>
                <td><%= u.getUserId() %></td>
                <td><%= u.getName() %></td>
                <td><%= u.getEmail() %></td>
                <td><%= u.getRole() %></td>
            </tr>
            <%
                }
            %>
        </table>
    <%
        }
    %>
</body>
</html>