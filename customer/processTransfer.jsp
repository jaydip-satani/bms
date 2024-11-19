<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="javax.servlet.*" %>

<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("username") == null || !userSession.getAttribute("role").equals("customer")) {
        response.sendRedirect("../login.jsp"); 
        return; 
    }
%>
<%
    String fromAccountId = request.getParameter("fromAccount");
    String toAccountId = request.getParameter("toAccount");
    String amountStr = request.getParameter("amount");
    int userId = (Integer) userSession.getAttribute("user_id");

    boolean validInput = fromAccountId != null && toAccountId != null && amountStr != null 
                         && !fromAccountId.isEmpty() && !toAccountId.isEmpty() && !amountStr.isEmpty();

    boolean transferSuccessful = false;
    boolean insufficientBalance = false;
    boolean invalidAccount = false;

    if (validInput) {
        double amount = Double.parseDouble(amountStr); 

        Connection con = null;
        PreparedStatement checkFromAccountStmt = null;
        PreparedStatement checkToAccountStmt = null;
        PreparedStatement checkBalanceStmt = null;
        PreparedStatement debitStmt = null;
        PreparedStatement creditStmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "");
            con.setAutoCommit(false); 

            String checkAccountQuery = "SELECT * FROM accounts WHERE account_id = ? AND user_id = ?";
            checkFromAccountStmt = con.prepareStatement(checkAccountQuery);
            checkFromAccountStmt.setInt(1, Integer.parseInt(fromAccountId));
            checkFromAccountStmt.setInt(2, userId); 
            rs = checkFromAccountStmt.executeQuery();

            if (!rs.next()) {
                invalidAccount = true;
            } else {
                checkToAccountStmt = con.prepareStatement("SELECT * FROM accounts WHERE account_id = ?");
                checkToAccountStmt.setInt(1, Integer.parseInt(toAccountId));
                rs = checkToAccountStmt.executeQuery();

                if (!rs.next()) {
                    invalidAccount = true;
                } else {
                    String checkBalanceQuery = "SELECT balance FROM accounts WHERE account_id = ?";
                    checkBalanceStmt = con.prepareStatement(checkBalanceQuery);
                    checkBalanceStmt.setInt(1, Integer.parseInt(fromAccountId));
                    rs = checkBalanceStmt.executeQuery();

                    double balance = 0;
                    if (rs.next()) {
                        balance = rs.getDouble("balance");
                    }

                    if (balance >= amount) {
                        String debitQuery = "UPDATE accounts SET balance = balance - ? WHERE account_id = ?";
                        debitStmt = con.prepareStatement(debitQuery);
                        debitStmt.setDouble(1, amount);
                        debitStmt.setInt(2, Integer.parseInt(fromAccountId));
                        debitStmt.executeUpdate();

                        String creditQuery = "UPDATE accounts SET balance = balance + ? WHERE account_id = ?";
                        creditStmt = con.prepareStatement(creditQuery);
                        creditStmt.setDouble(1, amount);
                        creditStmt.setInt(2, Integer.parseInt(toAccountId));
                        creditStmt.executeUpdate();

                        String transQuery = "INSERT INTO transactions (account_id, transaction_type, amount, transaction_date, status) VALUES (?, ?, ?, NOW(), 'pending')";
                        PreparedStatement transactionPstmt = con.prepareStatement(transQuery);  // Use transQuery here
                        String type = "withdrawal";  // This is for the 'from' account transaction type
                        transactionPstmt.setInt(1, Integer.parseInt(fromAccountId));  // Set from account_id
                        transactionPstmt.setString(2, type);  // Set transaction type (withdrawal)
                        transactionPstmt.setDouble(3, amount);  // Set the transfer amount
                        transactionPstmt.executeUpdate();


                        con.commit(); 
                        transferSuccessful = true;
                    } else {
                        insufficientBalance = true;
                    }
                }
            }
        } catch (Exception e) {
            if (con != null) con.rollback(); 
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (checkFromAccountStmt != null) checkFromAccountStmt.close();
            if (checkToAccountStmt != null) checkToAccountStmt.close();
            if (checkBalanceStmt != null) checkBalanceStmt.close();
            if (debitStmt != null) debitStmt.close();
            if (creditStmt != null) creditStmt.close();
            if (con != null) con.close();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Transfer Funds Result</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container">
        <h1 class="mt-5">Transfer Funds Result</h1>
        <%
            if (!validInput) {
        %>
            <div class="alert alert-danger" role="alert">
                Invalid input! Please ensure all fields are filled correctly.
            </div>
        <%
            } else if (transferSuccessful) {
        %>
            <div class="alert alert-success" role="alert">
                Transfer successful!
            </div>
        <%
            } else if (insufficientBalance) {
        %>
            <div class="alert alert-danger" role="alert">
                Insufficient balance!
            </div>
        <%
            } else if (invalidAccount) {
        %>
            <div class="alert alert-danger" role="alert">
                Invalid account information!
            </div>
        <%
            } else {
        %>
            <div class="alert alert-danger" role="alert">
                An error occurred. Please try again.
            </div>
        <%
            }
        %>
        <a href="customerDashboard.jsp" class="btn btn-primary mt-3">Back to Dashboard</a>
    </div>
</body>
</html>