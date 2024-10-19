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
    <title>Transaction Approval</title>
</head>
<body>
<%
    Connection conn = null;
    PreparedStatement ps = null;
    int transactionId = Integer.parseInt(request.getParameter("transactionId"));

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "");

        String sql = "UPDATE transactions SET status = 'approved' WHERE transaction_id = ?";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, transactionId);

        int rowsUpdated = ps.executeUpdate();
        if (rowsUpdated > 0) {
            out.println("<h3>Transaction approved successfully!</h3>");
        } else {
            out.println("<h3>Error approving transaction.</h3>");
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
        out.println("<h3>Error: " + e.getMessage() + "</h3>");
    } finally {
        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
<a href="processTransactions.jsp" class="btn btn-primary mt-3">Back to Transactions</a>
</body>
</html>
