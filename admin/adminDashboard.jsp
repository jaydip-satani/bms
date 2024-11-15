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
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center" style="min-height: 100vh;">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-6">
                <div class="card shadow-sm mt-5">
                    <div class="card-header bg-primary text-white text-center">
                        <h1 class="h3 mb-0">Admin Dashboard</h1>
                    </div>
                    <div class="card-body">
                        <p class="text-center">Welcome, Admin. Choose an option below:</p>
                        <div class="list-group">
                            <a href="manageUsers.jsp" class="list-group-item list-group-item-action">Manage Users</a>
                            <a href="viewAccounts.jsp" class="list-group-item list-group-item-action">View All Accounts</a>
                            <a href="viewTransactions.jsp" class="list-group-item list-group-item-action">View Transactions</a>
                            <a href="manageLoans.jsp" class="list-group-item list-group-item-action">Manage Loans</a>
                            <a href="generateReports.jsp" class="list-group-item list-group-item-action">Generate Reports</a>
                        </div>
                    </div>
                    <div class="card-footer text-center">
                        <a href="../logout.jsp" class="btn btn-danger">Logout</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
