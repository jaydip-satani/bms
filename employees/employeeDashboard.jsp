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
<body class="bg-light d-flex align-items-center" style="min-height: 100vh;">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-6">
                <div class="card shadow-sm mt-5">
                    <div class="card-header bg-primary text-white text-center">
                        <h1 class="h3 mb-0">Employee Dashboard</h1>
                    </div>
                    <div class="card-body">
                        <p class="text-center">Welcome, Employee. Choose an option below:</p>
                        <div class="list-group">
                          <a href="customerRegistration.jsp" class="list-group-item list-group-item-action">Add New Customer</a>
                            <a href="manageCustomerAccounts.jsp" class="list-group-item list-group-item-action">Manage Customer Accounts</a>
                            <a href="processTransactions.jsp" class="list-group-item list-group-item-action">Process Transactions</a>
                            <a href="reviewLoanApplications.jsp" class="list-group-item list-group-item-action">Review Loan Applications</a>
                            <a href="reviewCBApplications.jsp" class="list-group-item list-group-item-action">Review Cheque Book Applications</a>
                            <a href="reviewATMApplications.jsp" class="list-group-item list-group-item-action">Review ATM Card Applications</a>
                            <a href="generateEmployeeReports.jsp" class="list-group-item list-group-item-action">Generate Reports</a>
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
