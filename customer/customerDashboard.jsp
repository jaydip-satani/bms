<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
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
    <title>Customer Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center" style="min-height: 100vh;">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-6">
                <div class="card shadow-sm mt-5">
                    <div class="card-header bg-primary text-white text-center">
                        <h1 class="h3 mb-0">Customer Dashboard</h1>
                    </div>
                    <div class="card-body">
                        <p class="text-center">Welcome, Customer. Choose an option below:</p>
                        <div class="list-group">
                            <a href="viewAccountDetails.jsp" class="list-group-item list-group-item-action">View Account Details</a>
                            <a href="transferFunds.jsp" class="list-group-item list-group-item-action">Transfer Funds</a>
                            <a href="applyLoan.jsp" class="list-group-item list-group-item-action">Apply for Loan</a>
                            <a href="applyATM.jsp" class="list-group-item list-group-item-action">Apply for ATM card</a>
                            <a href="applyCB.jsp" class="list-group-item list-group-item-action">Apply for Cheque Book</a>
                            <a href="viewStatements.jsp" class="list-group-item list-group-item-action">View Statements</a>
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
