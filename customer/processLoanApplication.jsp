<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("username") == null || !userSession.getAttribute("role").equals("customer")) {
        response.sendRedirect("../login.jsp"); 
        return; 
    }
%>
<%
    String loanType = request.getParameter("loanType");
    String amountStr = request.getParameter("amount");
    int userId = (Integer) session.getAttribute("user_id"); // Assuming user ID is stored in session
    double loanAmount = Double.parseDouble(amountStr);
    double interestRate = 5.0; // Set a default interest rate or calculate based on type

    boolean applicationSuccess = false;

    // Database connection parameters
    String dbURL = "jdbc:mysql://localhost:3306/bankingdb";
    String dbUser = "root"; // Change as per your DB user
    String dbPassword = ""; // As per your note

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        // Load the JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Establish connection
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // SQL query to insert loan application
        String sql = "INSERT INTO loans (user_id, loan_amount, interest_rate, loan_status, loan_type) VALUES (?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, userId);
        pstmt.setDouble(2, loanAmount);
        pstmt.setDouble(3, interestRate);
        pstmt.setString(4, "pending");
        pstmt.setString(5, loanType);

        // Execute the query
        int rowsInserted = pstmt.executeUpdate();
        if (rowsInserted > 0) {
            applicationSuccess = true;
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // Clean up resources
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Loan Application Status</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container">
        <h1 class="mt-5">Loan Application Status</h1>
        <%
            if (applicationSuccess) {
        %>
            <div class="alert alert-success" role="alert">
                Your loan application for Rs.<%= amountStr %> has been submitted successfully and is currently pending approval.
            </div>
        <%
            } else {
        %>
            <div class="alert alert-danger" role="alert">
                There was an error submitting your loan application. Please try again.
            </div>
        <%
            }
        %>
        <a href="customerDashboard.jsp" class="btn btn-primary mt-3">Back to Dashboard</a>
    </div>
</body>
</html>
