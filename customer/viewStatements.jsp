<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*, java.util.*" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("username") == null || !userSession.getAttribute("role").equals("customer")) {
        response.sendRedirect("../login.jsp"); 
        return; 
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>View Statements</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container">
        <h1 class="mt-5">Account Statements</h1>
        <table class="table table-bordered mt-4">
            <thead class="thead-light">
                <tr>
                    <th>Date</th>
                    <th>Description</th>
                    <th>Amount</th>
                    <th>Balance</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection conn = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    Integer userId = (Integer) userSession.getAttribute("user_id");

                  
                    out.println("User ID: " + userId);

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb","root",""); 

                         String sql = "SELECT t.transaction_date, t.transaction_type, t.amount, a.balance " +
                                     "FROM transactions t " +
                                     "JOIN accounts a ON t.account_id = a.account_id " + 
                                     "WHERE a.user_id = ?";
                        ps = conn.prepareStatement(sql);
                        ps.setInt(1, userId);
                        rs = ps.executeQuery();

                        if (!rs.isBeforeFirst()) { 
                            out.println("<tr><td colspan='4'>No transactions found.</td></tr>");
                        } else {
                            while (rs.next()) {
                                String transactionDate = rs.getString("transaction_date");
                                String transactionType = rs.getString("transaction_type");
                                double amount = rs.getDouble("amount");
                                double balance = rs.getDouble("balance");
                                %>
                                <tr>
                                    <td><%= transactionDate %></td>
                                    <td><%= transactionType %></td>
                                    <td><%= (transactionType.equals("withdrawal") ? "-" : "") + "₹" + String.format("%.2f", amount) %></td>
                                    <td>₹<%= String.format("%.2f", balance) %></td>
                                </tr>
                                <%
                            }
                        }
                    } catch (SQLException | ClassNotFoundException e) {
                        e.printStackTrace(); 
                        out.println("Error: " + e.getMessage()); 
                    } finally {
                       
                        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                %>
            </tbody>
        </table>
        <a href="customerDashboard.jsp" class="btn btn-primary mt-3">Back to Dashboard</a>
    </div>
</body>
</html>
