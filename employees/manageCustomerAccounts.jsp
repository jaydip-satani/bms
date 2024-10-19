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
    <title>Manage Customer Accounts</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container">
        <h1 class="mt-5">Manage Customer Accounts</h1>
        <table class="table table-hover mt-4">
            <thead class="thead-light">
                <tr>
                    <th>Account ID</th>
                    <th>Customer Name</th>
                    <th>Balance</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection conn = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", ""); 

                        String sql = "SELECT a.account_id, u.username, a.balance , a.status " +
                                     "FROM accounts a " +
                                     "JOIN users u ON a.user_id = u.user_id";
                        ps = conn.prepareStatement(sql);
                        rs = ps.executeQuery();

                        while (rs.next()) {
                            int accountId = rs.getInt("account_id");
                            String customerName = rs.getString("username");
                            double balance = rs.getDouble("balance");
                            String status = rs.getString("status");
                %>
                            <tr>
                                <td><%= accountId %></td>
                                <td><%= customerName %></td>
                                <td>₹<%= String.format("%.2f", balance) %></td>
                                <td><%= status %></td>
                                <td>
                                    <button class="btn btn-sm btn-warning" onclick="editAccount(<%= accountId %>)">Edit</button>
                                    <button class="btn btn-sm btn-danger" onclick="closeAccount(<%= accountId %>)">Close Account</button>
                                </td>
                            </tr>
                <%
                        }
                    } catch (SQLException | ClassNotFoundException e) {
                        e.printStackTrace(); 
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                %>
            </tbody>
        </table>
        <a href="employeeDashboard.jsp" class="btn btn-primary mt-3">Back to Dashboard</a>
    </div>

    <script>
        function editAccount(accountId) {
            window.location.href = "editAccount.jsp?accountId=" + accountId;
        }

        function closeAccount(accountId) {
            if (confirm("Are you sure you want to close this account?")) {
                window.location.href = "closeAccount.jsp?accountId=" + accountId;
            }
        }
    </script>
</body>
</html>
