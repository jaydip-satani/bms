<%@ page import="java.sql.*" %>
<%@ page language="java" %>

<%
    // Check if the user is an admin, otherwise redirect
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "");

        // Query to get session logs along with associated user information
        String query = "SELECT sl.log_id, sl.user_id, u.username, sl.session_id, sl.ip_address, sl.login_time, sl.logout_time, sl.status " +
                       "FROM session_logs sl " +
                       "JOIN users u ON sl.user_id = u.user_id " +
                       "ORDER BY sl.login_time DESC";
        ps = con.prepareStatement(query);
        rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Session Logs - Admin View</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h1 class="mb-4">Session Logs</h1>
        <div class="table-responsive">
            <table class="table table-bordered table-striped">
                <thead class="thead-dark">
                    <tr>
                        <th>Log ID</th>
                        <th>User ID</th>
                        <th>Username</th>
                        <th>Session ID</th>
                        <th>IP Address</th>
                        <th>Login Time</th>
                        <th>Logout Time</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("log_id") %></td>
                        <td><%= rs.getInt("user_id") %></td>
                        <td><%= rs.getString("username") %></td>
                        <td><%= rs.getString("session_id") %></td>
                        <td><%= rs.getString("ip_address") %></td>
                        <td><%= rs.getTimestamp("login_time") %></td>
                        <td><%= rs.getTimestamp("logout_time") %></td>
                        <td>
                            <span class="badge <%= "active".equals(rs.getString("status")) ? "badge-success" : "badge-secondary" %>">
                                <%= rs.getString("status") %>
                            </span>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
        <a href="adminDashboard.jsp" class="btn btn-primary mt-3">Back to Dashboard</a>
    </div>

    <!-- Bootstrap JS, Popper.js, and jQuery -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>

<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
