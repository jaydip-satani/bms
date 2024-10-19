<%@ page import="java.sql.*, java.util.*" %>
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
    <title>Generate Reports</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container">
        <h1 class="mt-5">Generate Reports</h1>
        <form method="get" action="generateReports.jsp">
            <div class="mb-3">
                <label for="reportType" class="form-label">Select Report Type</label>
                <select class="form-select" id="reportType" name="reportType">
                    <option value="transactions">Transactions</option>
                    <option value="loans">Loans</option>
                    <option value="accounts">Accounts</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Generate Report</button>
        <a href="adminDashboard.jsp" class="btn btn-secondary m-5">Back to Dashboard</a>
        </form>

        <%
            String reportType = request.getParameter("reportType");
            if (reportType != null) {
                Connection con = null;
                Statement stmt = null;
                ResultSet rs = null;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "");
                    stmt = con.createStatement();
                    
                    String query = "";
                    if (reportType.equals("transactions")) {
                        query = "SELECT t.transaction_id, u.username, t.transaction_type,t.amount, t.transaction_date " +
                                "FROM transactions t " +
                                "JOIN accounts a ON t.account_id = a.account_id " +
                                "JOIN users u ON a.user_id = u.user_id";
                    } else if (reportType.equals("loans")) {
                        query = "SELECT l.loan_id, u.username, l.loan_amount, l.loan_status " +
                                "FROM loans l " +
                                "JOIN users u ON l.user_id = u.user_id";
                    } else if (reportType.equals("accounts")) {
                        query = "SELECT a.account_id, u.username, a.balance " +
                                "FROM accounts a " +
                                "JOIN users u ON a.user_id = u.user_id";
                    }
                    
                    rs = stmt.executeQuery(query);
                    
                    if (reportType.equals("transactions")) {
        %>
        <h2 class="mt-5">Transaction Report</h2>
        <table class="table table-striped mt-4">
            <thead>
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
                    while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("transaction_id") %></td>
                    <td><%= rs.getString("username") %></td>
                    <td><%= rs.getString("transaction_type") %></td>
                    <td>$<%= rs.getDouble("amount") %></td>
                    <td><%= rs.getDate("transaction_date") %></td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
        <%
                    } else if (reportType.equals("loans")) {
        %>
        <h2 class="mt-5">Loan Report</h2>
        <table class="table table-striped mt-4">
            <thead>
                <tr>
                    <th>Loan ID</th>
                    <th>Customer Name</th>
                    <th>Amount</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("loan_id") %></td>
                    <td><%= rs.getString("username") %></td>
                    <td>$<%= rs.getDouble("loan_amount") %></td>
                    <td><%= rs.getString("loan_status") %></td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
        <%
                    } else if (reportType.equals("accounts")) {
        %>
        <h2 class="mt-5">Account Report</h2>
        <table class="table table-striped mt-4">
            <thead>
                <tr>
                    <th>Account ID</th>
                    <th>Account Holder</th>
                    <th>Balance</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("account_id") %></td>
                    <td><%= rs.getString("username") %></td>
                    <td>$<%= rs.getDouble("balance") %></td>
                    <td><%= rs.getString("status") %></td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
        <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (con != null) con.close();
                }
            }
        %>
    </div>
</body>
</html>
