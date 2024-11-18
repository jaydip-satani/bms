<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<!DOCTYPE html>
<html>
<head>
    <title>Banking System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<style>
    .card-body a{
        text-decoration: none;
    }

    .card-body a:hover{
        color: black;
    }
   .bg-light {
  background-image: url('https://images.pexels.com/photos/351264/pexels-photo-351264.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1');
  background-size: cover;
  background-position: center center;
  background-repeat: no-repeat; 
  background-attachment: fixed; 
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  opacity: 1.9;
  z-index: -1;
}</style>
<body class="bg-light">
        <center>
    <h1 class="container  m-5 p-3 "> Verification Process</h1>
        </center>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-4 mt-5">
                <div class="card">
                    <div class="card-header text-center">
                        <h3>User Details</h3>
                    </div>
                    <div class="card-body">
                        <form method="POST" action="verify.jsp">
                            <div class="form-group">
                                <label for="username">Username</label>
                                <input type="text" class="form-control" id="username" name="username" placeholder="Enter username" required>
                            </div>
                            <br>
                            <div class="form-group">
                                <label for="phone">Phone Number</label>
                                <input type="text" maxlength="10" class="form-control" id="phone" name="phone" placeholder="Enter phone number">
                            </div>
                            <br>
                            <div class="form-group">
                                <label for="password">New Password</label>
                                <input type="password" class="form-control" id="password" name="password" placeholder="Enter new password">
                            </div>
                            <br>
                            <button type="submit" class="btn btn-primary w-100">Verify</button>
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
