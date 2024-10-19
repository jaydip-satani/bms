<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
    <title>View Account Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container">
        <h1 class="mt-5">Account Details</h1>
        <table class="table table-striped mt-4">
            <thead class="thead-light">
                <tr>
                    <th>Account ID</th>
                    <th>Account Type</th>
                    <th>Balance</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection con = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    try {
                        int userId = (Integer) userSession.getAttribute("user_id");

                        Class.forName("com.mysql.cj.jdbc.Driver");
                        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "");

                        String query = "SELECT account_id, account_type, balance FROM accounts WHERE user_id = ?";
                        ps = con.prepareStatement(query);
                        ps.setInt(1, userId);
                        rs = ps.executeQuery();

                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("account_id") %></td>
                    <td><%= rs.getString("account_type") %></td>
                    <td>$<%= rs.getDouble("balance") %></td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                        if (con != null) con.close();
                    }
                %>
            </tbody>
        </table>
        <a href="customerDashboard.jsp" class="btn btn-primary mt-3">Back to Dashboard</a>
    </div>
</body>
</html>
