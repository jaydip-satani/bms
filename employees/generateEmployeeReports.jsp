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
    <title>Generate Employee Reports</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container">
        <h1 class="mt-5">Generate Reports</h1>
        <form method="post" action="generateReport.jsp">
            <div class="mb-3">
                <label for="reportType" class="form-label">Select Report Type</label>
                <select class="form-select" id="reportType" name="reportType">
                    <option value="transactions">Transactions</option>
                    <option value="loans">Loans</option>
                    <option value="accounts">Accounts</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Generate Report</button>
        </form>
        <a href="employeeDashboard.jsp" class="btn btn-secondary mt-3">Back to Dashboard</a>
    </div>
</body>
</html>
