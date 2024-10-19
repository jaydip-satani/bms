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
    <title>Update Account</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container">
    <h1 class="mt-5">Update Account</h1>
<%
    Connection conn = null;
    PreparedStatement psAccount = null;
    PreparedStatement psUser = null;
    PreparedStatement psUserId = null;
    int accountId = Integer.parseInt(request.getParameter("accountId"));
    String username = request.getParameter("customerName");
    double balance = Double.parseDouble(request.getParameter("balance"));
    String status = request.getParameter("status");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "");

        String getUserIdSql = "SELECT user_id FROM accounts WHERE account_id = ?";
        psUserId = conn.prepareStatement(getUserIdSql);
        psUserId.setInt(1, accountId);
        ResultSet rsUserId = psUserId.executeQuery();
        
        int userId = 0;
        if (rsUserId.next()) {
            userId = rsUserId.getInt("user_id");
            out.println("<p>User ID: " + userId + "</p>"); 
        } else {
            out.println("<h3>Error: Account not found!</h3>");
            return;
        }

        String updateUserSql = "UPDATE users SET username = ? WHERE user_id = ?";
        psUser = conn.prepareStatement(updateUserSql);
        psUser.setString(1, username);
        psUser.setInt(2, userId);

        String updateAccountSql = "UPDATE accounts SET balance = ?, status = ? WHERE account_id = ?";
        psAccount = conn.prepareStatement(updateAccountSql);
        psAccount.setDouble(1, balance);
        psAccount.setString(2, status);
        psAccount.setInt(3, accountId);

        int rowsUpdatedUser = psUser.executeUpdate();
        int rowsUpdatedAccount = psAccount.executeUpdate();

        if (rowsUpdatedUser > 0) {
            out.println("<h3>Username updated successfully!</h3>");
        } else {
            out.println("<h3>Error: Username not updated!</h3>");
        }

        if (rowsUpdatedAccount > 0) {
            out.println("<h3>Account updated successfully!</h3>");
        } else {
            out.println("<h3>Error: Account not updated!</h3>");
        }

    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace(); 
        out.println("<h3>Error: " + e.getMessage() + "</h3>");
    } finally {
        if (psAccount != null) try { psAccount.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (psUser != null) try { psUser.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (psUserId != null) try { psUserId.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
    <a href="employeeDashboard.jsp" class="btn btn-primary mt-3">Back to Dashboard</a>
</div>
</body>
</html>
