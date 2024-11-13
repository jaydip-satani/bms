<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("username") == null || !userSession.getAttribute("role").equals("customer")) {
        response.sendRedirect("../login.jsp"); 
        return; 
    }

    // Retrieve session data and request parameters
    int userId = (Integer) userSession.getAttribute("user_id");
    String accountId = request.getParameter("accountId");
    String cardType = request.getParameter("cardType");
    String contactNumber = request.getParameter("contactNumber");

    // Debug output to check if values are retrieved correctly
    out.println("Debug Info: <br>");
    out.println("User ID: " + userId + "<br>");
    out.println("Account ID: " + accountId + "<br>");
    out.println("Card Type: " + cardType + "<br>");
    out.println("Contact Number: " + contactNumber + "<br>");
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver"); // Updated driver class for MySQL
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "");
        
        // Insert query for atm_card_requests with the new structure
        String sql = "INSERT INTO atm_card_requests (user_id, account_id, card_type, contact_number, status) VALUES (?, ?, ?, ?, 'pending')";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, userId);
        pstmt.setString(2, accountId);
        pstmt.setString(3, cardType);
        pstmt.setString(4, contactNumber);
        
        int rowsInserted = pstmt.executeUpdate();
        if (rowsInserted > 0) {
            out.println("<script>alert('ATM Card Application Submitted Successfully!'); window.location.href='customerDashboard.jsp';</script>");
        } else {
            out.println("<script>alert('Failed to submit application. Please try again.'); window.history.back();</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<br><b>Error:</b> " + e.getMessage() + "<br>");
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
