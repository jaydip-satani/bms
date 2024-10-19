<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("username") == null || !userSession.getAttribute("role").equals("employee")) {
        response.sendRedirect("../login.jsp"); 
        return; 
    }

    String accountId = request.getParameter("accountId");
    if (accountId != null) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "");
            
            String updateSql = "UPDATE accounts SET status = 'closed' WHERE account_id = ?";
            ps = con.prepareStatement(updateSql);
            ps.setString(1, accountId);
            int rowsUpdated = ps.executeUpdate();
            
            if (rowsUpdated > 0) {
                request.setAttribute("message", "Account closed successfully!");
            } else {
                request.setAttribute("message", "Error closing account. Account may not exist.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "An error occurred: " + e.getMessage());
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Close Account</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container">
        <h1 class="mt-5">Close Account</h1>
        <% 
            String message = (String) request.getAttribute("message");
            if (message != null) {
        %>
        <div class="alert alert-info"><%= message %></div>
        <% 
            } 
        %>
        <a href="employeeDashboard.jsp" class="btn btn-secondary mt-3">Back to Dashboard</a>
    </div>
</body>
</html>
