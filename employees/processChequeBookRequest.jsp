<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*, java.util.*" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("username") == null || !userSession.getAttribute("role").equals("employee")) {
        response.sendRedirect("../login.jsp"); 
        return; 
    }

    Connection conn = null;
    PreparedStatement ps = null;

    String requestId = request.getParameter("requestId");
    String action = request.getParameter("action");
    String status = "pending";

    if ("approve".equals(action)) {
        status = "approved";
    } else if ("reject".equals(action)) {
        status = "rejected";
    }

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "");

        String sql = "UPDATE cheque_book_requests SET status = ? WHERE request_id = ?";
        ps = conn.prepareStatement(sql);
        ps.setString(1, status);
        ps.setInt(2, Integer.parseInt(requestId));

        int updatedRows = ps.executeUpdate();

        if (updatedRows > 0) {
            out.println("<h3>Cheque Book Request successfully " + (status.equals("approved") ? "approved" : "rejected") + ".</h3>");
        } else {
            out.println("<h3>Error: Unable to update the status. Please try again.</h3>");
        }

    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
        out.println("<h3>Error processing cheque book request: " + e.getMessage() + "</h3>");
    } finally {
        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Process Cheque Book Request</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <a href="reviewCBApplications.jsp" class="btn btn-primary">Back to Review Page</a>
    </div>
</body>
</html>
