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
    <title>Edit Account</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container">
        <h1 class="mt-5">Edit Account</h1>
        <form method="post" action="updateAccount.jsp">
            <%
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                int accountId = Integer.parseInt(request.getParameter("accountId"));

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "");

                    String sql = "SELECT a.account_id, u.username, a.balance, a.status " +
                                 "FROM accounts a " +
                                 "JOIN users u ON a.user_id = u.user_id " +
                                 "WHERE a.account_id = ?";
                    ps = conn.prepareStatement(sql);
                    ps.setInt(1, accountId);
                    rs = ps.executeQuery();

                    if (rs.next()) {
                        String customerName = rs.getString("username");
                        double balance = rs.getDouble("balance");
                        String status = rs.getString("status");
            %>
            <div class="mb-3">
                <label for="accountId" class="form-label">Account ID</label>
                <input type="text" class="form-control" id="accountId" name="accountId" value="<%= accountId %>" readonly>
            </div>
            <div class="mb-3">
                <label for="customerName" class="form-label">Customer Name</label>
                <input type="text" class="form-control" id="customerName" name="customerName" value="<%= customerName %>" required>
            </div>
            <div class="mb-3">
                <label for="balance" class="form-label">Balance</label>
                <input type="number" class="form-control" id="balance" name="balance" value="<%= balance %>" required>
            </div>
            <div class="mb-3">
                <label for="status" class="form-label">Status</label>
                <select class="form-select" id="status" name="status" required>
                    <option value="Active" <%= status.equals("Active") ? "selected" : "" %>>Active</option>
                    <option value="Inactive" <%= status.equals("Inactive") ? "selected" : "" %>>Inactive</option>
                </select>
            </div>
            <button type="submit" class="btn btn-success">Update Account</button>
            <%
                    } else {
                        out.println("<p class='text-danger'>Account not found.</p>");
                    }
                } catch (SQLException | ClassNotFoundException e) {
                    e.printStackTrace(); 
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            %>
        </form>
        <a href="employeeDashboard.jsp" class="btn btn-primary mt-3">Back to Dashboard</a>
    </div>
</body>
</html>
