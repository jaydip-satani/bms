<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*, java.util.*" %>
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("username") == null || !userSession.getAttribute("role").equals("employee")) {
        response.sendRedirect("../login.jsp"); 
        return; 
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Process Transactions</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container">
        <h1 class="mt-5">Process Transactions</h1>
        <table class="table table-bordered mt-4">
            <thead class="thead-light">
                <tr>
                    <th>Transaction ID</th>
                    <th>Customer</th>
                    <th>Amount</th>
                    <th>Type</th>
                    <th>Date</th>
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

        String sql = "SELECT t.transaction_id, u.username, t.amount, t.transaction_type, t.transaction_date, t.status " +
                     "FROM transactions t " +
                     "JOIN accounts a ON t.account_id = a.account_id " +
                     "JOIN users u ON a.user_id = u.user_id";
        
        ps = conn.prepareStatement(sql);
        rs = ps.executeQuery();

        while (rs.next()) {
            int transactionId = rs.getInt("transaction_id");
            String customerName = rs.getString("username");
            double amount = rs.getDouble("amount");
            String transactionType = rs.getString("transaction_type");
            String transactionDate = rs.getString("transaction_date");

            String status = rs.getString("status");

%>
            <tr>
                <td><%= transactionId %></td>
                <td><%= customerName %></td>
                <td>$<%= amount %></td>
                <td><%= transactionType %></td>
                <td><%= transactionDate %></td>
                <td>
                    <form method="post" action="approveTransaction.jsp">
                        <input type="hidden" name="transactionId" value="<%= transactionId %>">
                        <button class="btn btn-sm btn-success" <% if("approved".equals(status)) { %> disabled <% } %>>Approve</button>
                    </form>
                </td>
            </tr>
<%
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
        out.println("<h3>Error fetching transactions: " + e.getMessage() + "</h3>");
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
