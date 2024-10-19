<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("username") == null || !userSession.getAttribute("role").equals("admin")) {
        response.sendRedirect("../login.jsp"); 
        return; 
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>View Transactions</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container">
        <h1 class="mt-5">View Transactions</h1>
        <table class="table table-hover mt-4">
            <thead class="thead-light">
                <tr>
                    <th>Transaction ID</th>
                    <th>Account Holder</th>
                    <th>Type</th>
                    <th>Amount</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection con = null;
                    Statement stmt = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        
                        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "");

                        stmt = con.createStatement();
                        String query = "SELECT t.transaction_id, u.username, t.transaction_type, t.amount, t.transaction_date " +
                                       "FROM transactions t " +
                                       "JOIN accounts a ON t.account_id = a.account_id " +
                                       "JOIN users u ON a.user_id = u.user_id"; 

                        rs = stmt.executeQuery(query);
                        
                        if (rs.next()) {
                            do {
                %>
                <tr>
                    <td><%= rs.getString("transaction_id") %></td>
                    <td><%= rs.getString("username") %></td> 
                    <td><%= rs.getString("transaction_type") %></td>
                    <td>$<%= rs.getDouble("amount") %></td>
                    <td><%= rs.getDate("transaction_date") %></td>
                </tr>
                <%
                            } while (rs.next());
                        } else {
                %>
                <tr>
                    <td colspan="5" class="text-center">No transactions found.</td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        try {
                            if (rs != null) rs.close();
                            if (stmt != null) stmt.close();
                            if (con != null) con.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                %>
            </tbody>
        </table>
        <a href="adminDashboard.jsp" class="btn btn-primary mt-3">Back to Dashboard</a>
    </div>
</body>
</html>
