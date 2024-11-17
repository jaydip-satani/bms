<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*, java.util.*" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("username") == null || !userSession.getAttribute("role").equals("employee")) {
        response.sendRedirect("../login.jsp"); 
        return; 
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Review ATM Card Requests</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container">
        <h1 class="mt-5">Review ATM Card Requests</h1>
        <table class="table table-striped mt-4">
            <thead class="thead-light">
                <tr>
                    <th>Request ID</th>
                    <th>Customer Name</th>
                    <th>Account ID</th>
                    <th>Contact Number</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
<%
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "");

        String sql = "SELECT ar.request_id, u.username, ar.account_id, ar.contact_number, ar.status " +
                     "FROM atm_card_requests ar " +
                     "JOIN users u ON ar.user_id = u.user_id " +
                     "WHERE ar.status = 'pending'";  

        ps = conn.prepareStatement(sql);
        rs = ps.executeQuery();

        while (rs.next()) {
            int requestId = rs.getInt("request_id");
            String customerName = rs.getString("username");
            String accountId = rs.getString("account_id");
            String contactNumber = rs.getString("contact_number");
            String status = rs.getString("status");
%>
                <tr>
                    <td><%= requestId %></td>
                    <td><%= customerName %></td>
                    <td><%= accountId %></td>
                    <td><%= contactNumber %></td>
                    <td><%= status %></td>
                    <td>
                        <form method="post" action="processAtmRequest.jsp">
                            <input type="hidden" name="requestId" value="<%= requestId %>">
                            <button type="submit" name="action" value="approved" class="btn btn-sm btn-success">Approve</button>
                            <button type="submit" name="action" value="rejected" class="btn btn-sm btn-danger">Reject</button>
                        </form>
                    </td>
                </tr>
<%
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
        out.println("<h3>Error fetching ATM requests: " + e.getMessage() + "</h3>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
            </tbody>
        </table>
        <a href="employeeDashboard.jsp" class="btn btn-primary mt-3">Back to Dashboard</a>
    </div>
</body>
</html>
