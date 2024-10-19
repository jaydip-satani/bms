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
    <title>Employee Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container">
        <div class="row mt-5">
            <div class="col-12">
                <h1>Employee Dashboard</h1>
                <p>Welcome, Employee. Choose an option below:</p>
                <div class="list-group">
                    <a href="manageCustomerAccounts.jsp" class="list-group-item list-group-item-action">Manage Customer Accounts</a>
                    <a href="processTransactions.jsp" class="list-group-item list-group-item-action">Process Transactions</a>
                    <a href="reviewLoanApplications.jsp" class="list-group-item list-group-item-action">Review Loan Applications</a>
                    <a href="generateEmployeeReports.jsp" class="list-group-item list-group-item-action">Generate Reports</a>
                </div>
                <a href="../logout.jsp" class="btn btn-danger mt-3">Logout</a>
            </div>
        </div>
    </div>
</body>
</html>
