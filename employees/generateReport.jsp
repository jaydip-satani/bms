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
    <title>Report</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container">
        <h1 class="mt-5">Report</h1>
        <table class="table table-striped mt-4">
            <thead class="thead-light">
                <tr>
<%
    String reportType = request.getParameter("reportType");

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "");

        String sql = "";
        if ("transactions".equals(reportType)) {
            out.println("<th>Transaction ID</th><th>Account ID</th><th>Amount</th><th>Type</th><th>Date</th>");
            sql = "SELECT transaction_id, account_id, amount, transaction_type, transaction_date FROM transactions";
        } else if ("loans".equals(reportType)) {
            out.println("<th>Loan ID</th><th>User ID</th><th>Loan Amount</th><th>Status</th><th>Loan Type</th>");
            sql = "SELECT loan_id, user_id, loan_amount, loan_status, loan_type FROM loans";
        } else if ("accounts".equals(reportType)) {
            out.println("<th>Account ID</th><th>Customer Name</th><th>Balance</th><th>Status</th>");
            sql = "SELECT a.account_id, u.username, a.balance, a.status FROM accounts a JOIN users u ON a.user_id = u.user_id;";
        }

        ps = conn.prepareStatement(sql);
        rs = ps.executeQuery();

        out.println("</tr></thead><tbody>");

        while (rs.next()) {
            out.println("<tr>");
            if ("transactions".equals(reportType)) {
                out.println("<td>" + rs.getInt("transaction_id") + "</td>");
                out.println("<td>" + rs.getInt("account_id") + "</td>");
                out.println("<td>$" + rs.getDouble("amount") + "</td>");
                out.println("<td>" + rs.getString("transaction_type") + "</td>");
                out.println("<td>" + rs.getTimestamp("transaction_date") + "</td>");
            } else if ("loans".equals(reportType)) {
                out.println("<td>" + rs.getInt("loan_id") + "</td>");
                out.println("<td>" + rs.getInt("user_id") + "</td>");
                out.println("<td>$" + rs.getDouble("loan_amount") + "</td>");
                out.println("<td>" + rs.getString("loan_status") + "</td>");
                out.println("<td>" + rs.getString("loan_type") + "</td>");
            } else if ("accounts".equals(reportType)) {
                out.println("<td>" + rs.getInt("account_id") + "</td>");
                out.println("<td>" + rs.getString("username") + "</td>");
                out.println("<td>$" + rs.getDouble("balance") + "</td>");
                out.println("<td>" + rs.getString("status") + "</td>");
            }
            out.println("</tr>");
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
        out.println("<h3>Error generating report: " + e.getMessage() + "</h3>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
            </tbody>
        </table>
        <a href="generateEmployeeReports.jsp" class="btn btn-secondary mt-3">Back to Report Selection</a>
    </div>
</body>
</html>
