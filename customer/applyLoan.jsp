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
    <title>Apply for Loan</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container">
        <h1 class="mt-5">Apply for Loan</h1>
        <form action="processLoanApplication.jsp" method="post">
            <div class="mb-3">
                <label for="loanType" class="form-label">Loan Type</label>
                <select class="form-select" id="loanType" name="loanType" required>
                    <option selected>Select Loan Type</option>
                    <option value="personal">Personal Loan</option>
                    <option value="home">Home Loan</option>
                    <option value="car">Car Loan</option>
                </select>
            </div>
            <div class="mb-3">
                <label for="amount" class="form-label">Loan Amount</label>
                <input type="number" class="form-control" id="amount" name="amount" placeholder="Enter loan amount" required>
            </div>
            <button type="submit" class="btn btn-success">Submit Application</button>
        </form>
        <a href="customerDashboard.jsp" class="btn btn-primary mt-3">Back to Dashboard</a>
    </div>
</body>
</html>
