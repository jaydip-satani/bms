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
    <title>Review Loan Applications</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container">
        <h1 class="mt-5">Review Loan Applications</h1>
        <table class="table table-striped mt-4">
            <thead class="thead-light">
                <tr>
                    <th>Loan ID</th>
                    <th>Customer Name</th>
                    <th>Loan Amount</th>
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

        String sql = "SELECT l.loan_id, u.username, l.loan_amount, l.loan_status " +
                     "FROM loans l " +
                     "JOIN users u ON l.user_id = u.user_id " +
                     "WHERE l.loan_status = 'pending'";  

        ps = conn.prepareStatement(sql);
        rs = ps.executeQuery();

        while (rs.next()) {
            int loanId = rs.getInt("loan_id");
            String customerName = rs.getString("username");
            double loanAmount = rs.getDouble("loan_amount");
            String loanStatus = rs.getString("loan_status");

%>
                <tr>
                    <td><%= loanId %></td>
                    <td><%= customerName %></td>
                    <td>$<%= loanAmount %></td>
                    <td><%= loanStatus %></td>
                    <td>
                        <form method="post" action="processLoan.jsp">
                            <input type="hidden" name="loanId" value="<%= loanId %>">
                            <button type="submit" name="action" value="approve" class="btn btn-sm btn-success">Approve</button>
                            <button type="submit" name="action" value="reject" class="btn btn-sm btn-danger">Reject</button>
                        </form>
                    </td>
                </tr>
<%
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
        out.println("<h3>Error fetching loan applications: " + e.getMessage() + "</h3>");
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
