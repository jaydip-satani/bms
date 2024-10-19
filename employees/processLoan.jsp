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
    <title>Process Loan</title>
</head>
<body>
<%
    Connection conn = null;
    PreparedStatement ps = null;
    int loanId = Integer.parseInt(request.getParameter("loanId"));
    String action = request.getParameter("action");
    String newStatus = "pending";

    if ("approve".equals(action)) {
        newStatus = "approved";
    } else if ("reject".equals(action)) {
        newStatus = "rejected";
    }

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "");

        String sql = "UPDATE loans SET loan_status = ? WHERE loan_id = ?";
        ps = conn.prepareStatement(sql);
        ps.setString(1, newStatus);
        ps.setInt(2, loanId);

        int rowsUpdated = ps.executeUpdate();
        if (rowsUpdated > 0) {
            out.println("<h3>Loan application " + action + "d successfully!</h3>");
        } else {
            out.println("<h3>Error processing loan application.</h3>");
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
        out.println("<h3>Error: " + e.getMessage() + "</h3>");
    } finally {
        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
<a href="reviewLoanApplications.jsp" class="btn btn-primary mt-3">Back to Loan Applications</a>
</body>
</html>
