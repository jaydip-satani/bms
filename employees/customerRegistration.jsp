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
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <a href="../logout.jsp" class="btn btn-danger mt-3">Logout</a>
        <a href="employeeDashboard.jsp" class="btn btn-primary mt-3">Back to Dashboard</a>
        <div class="row justify-content-center">
            <div class="col-md-8">
                <h3 class="text-center mb-4">Customer Registration & Account Opening</h3>
                <form action="processRegistration.jsp" method="post">
                    <div class="form-group">
                        <label for="username">Username</label>
                        <input type="text" class="form-control" id="username" name="username" placeholder="Enter username" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" class="form-control" id="password" name="password" placeholder="Enter password" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" class="form-control" id="email" name="email" placeholder="Enter email" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="text" maxlength="10" class="form-control" id="phone" name="phone" placeholder="Enter phone number" required oninput="validatePhoneNumber(event)">
                    </div>

                    <div class="form-group">
                        <label for="accountType">Account Type</label>
                        <select class="form-control" id="accountType" name="accountType" required>
                            <option value="savings">Savings</option>
                            <option value="checking">Checking</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="initial_balance">Initial Balance</label>
                        <input type="number" step="0.01" class="form-control" id="initial_balance" name="initial_balance" placeholder="Enter initial balance" required>
                    </div>
                    
                    <button type="submit" class="btn btn-primary btn-block">Register & Open Account</button>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        function validatePhoneNumber(event) {
            // Get the current value of the input field
            var input = event.target;
            // Remove any non-numeric characters
            input.value = input.value.replace(/[^0-9]/g, '');
        }
    </script>   

    <!-- Bootstrap JS, Popper.js, and jQuery -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.0.7/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
