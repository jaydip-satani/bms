<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%
    if (session.getAttribute("username") != null) {
        String role = (String) session.getAttribute("role");
        if ("admin".equals(role)) {
            response.sendRedirect("adminDashboard.jsp");
        } else if ("customer".equals(role)) {
            response.sendRedirect("customerDashboard.jsp");
        } else if ("employee".equals(role)) {
            response.sendRedirect("employeeDashboard.jsp");
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Banking System Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
        <center>
    <h1 class="container  m-5 p-3 "> Welcome to bank management system </h1>
        </center>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-4 mt-5">
                <div class="card">
                    <div class="card-header text-center">
                        <h3>Login</h3>
                    </div>
                    <div class="card-body">
                        <form method="POST" action="loginProcess.jsp">
                            <div class="mb-3">
                                <label for="username" class="form-label">Username</label>
                                <input type="text" class="form-control" id="username" name="username" required>
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Login</button>
                        </form>
                        <% if (request.getAttribute("errorMessage") != null) { %>
                            <div class="alert alert-danger mt-3"><%= request.getAttribute("errorMessage") %></div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
