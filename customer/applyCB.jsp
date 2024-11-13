<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("username") == null || !userSession.getAttribute("role").equals("customer")) {
        response.sendRedirect("../login.jsp"); 
        return; 
    }
    int userId = (Integer) userSession.getAttribute("user_id");
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    List<String> accountIds = new ArrayList<>();
    try {
        Class.forName("com.mysql.cj.jdbc.Driver"); 
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "");

        String sql = "SELECT account_id FROM accounts WHERE user_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, userId);
        rs = pstmt.executeQuery();
        
        while (rs.next()) {
            accountIds.add(rs.getString("account_id"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Apply for Cheque Book</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center" style="min-height: 100vh;">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-6">
                <div class="card shadow-sm mt-5">
                    <div class="card-header bg-primary text-white text-center">
                        <h1 class="h3 mb-0">Cheque Book Application</h1>
                    </div>
                    <div class="card-body">
                        <form action="submitCBApplication.jsp" method="post">
                            <div class="mb-3">
                                <label for="accountId" class="form-label">Account Number</label>
                                <select name="accountId" id="accountId" class="form-select" required>
                                    <option value="">Select Account</option>
                                    <% for (String accountId : accountIds) { %>
                                        <option value="<%= accountId %>"><%= accountId %></option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="contactNumber" class="form-label">Contact Number</label>
                                <input type="text" name="contactNumber" id="contactNumber" class="form-control" required>
                            </div>
                            <div class="text-center">
                                <button type="submit" class="btn btn-primary">Submit Application</button>
                            </div>
                        </form>
                    </div>
                    <div class="card-footer text-center">
                        <a href="customerDashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
