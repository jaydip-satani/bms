<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("username") == null || !userSession.getAttribute("role").equals("customer")) {
        response.sendRedirect("../login.jsp"); 
        return; 
    }
%>
<%
    
    int userId = (Integer) userSession.getAttribute("user_id");
    
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String fromAccountOptions = "";  

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "");

        String query = "SELECT account_id, account_type FROM accounts WHERE user_id = ?";
        ps = con.prepareStatement(query);
        ps.setInt(1, userId);
        rs = ps.executeQuery();

       while (rs.next()) {
            int accountId = rs.getInt("account_id");
            String accountType = rs.getString("account_type");
            fromAccountOptions += "<option value='" + accountId + "'>Account " + accountId + " (" + accountType + ")</option>";
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Transfer Funds</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container">
        <h1 class="mt-5">Transfer Funds</h1>
        <form action="processTransfer.jsp" method="post">
            <div class="mb-3">
                <label for="fromAccount" class="form-label">From Account</label>
                <select class="form-select" id="fromAccount" name="fromAccount" required>
                    <option selected>Select Account</option>
                    <%= fromAccountOptions %> 
                </select>
            </div>
            <div class="mb-3">
                <label for="toAccount" class="form-label">To Account</label>
                <input type="text" class="form-control" id="toAccount" name="toAccount" placeholder="Enter beneficiary account ID" required>
            </div>
            <div class="mb-3">
                <label for="amount" class="form-label">Amount</label>
                <input type="number" class="form-control" id="amount" name="amount" placeholder="Enter amount" required>
            </div>
            <button type="submit" class="btn btn-success">Transfer</button>
        </form>
        <a href="customerDashboard.jsp" class="btn btn-primary mt-3">Back to Dashboard</a>
    </div>
</body>
</html>
