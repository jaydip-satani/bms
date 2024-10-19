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
<body class="bg-light">
    <div class="container">
        <div class="row mt-5">
            <div class="col-12">
                <h1>Customer Dashboard</h1>
                <p>Welcome, Customer. Choose an option below:</p>
                <div class="list-group">
                    <a href="viewAccountDetails.jsp" class="list-group-item list-group-item-action">View Account Details</a>
                    <a href="transferFunds.jsp" class="list-group-item list-group-item-action">Transfer Funds</a>
                    <a href="applyLoan.jsp" class="list-group-item list-group-item-action">Apply for Loan</a>
                    <a href="viewStatements.jsp" class="list-group-item list-group-item-action">View Statements</a>
                </div>
                <a href="../logout.jsp" class="btn btn-danger mt-3">Logout</a>
            </div>
        </div>
    </div>
</body>
</html>
