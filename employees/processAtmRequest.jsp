<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*, java.util.*" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("username") == null || !userSession.getAttribute("role").equals("employee")) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String requestIdStr = request.getParameter("requestId");
    String action = request.getParameter("action");

    if (requestIdStr == null || action == null) {
        response.sendRedirect("reviewAtmRequests.jsp");
        return;
    }

    int requestId = Integer.parseInt(requestIdStr);

    Connection conn = null;
    PreparedStatement ps = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "");

        String sql = "UPDATE atm_card_requests SET status = ? WHERE request_id = ?";

        ps = conn.prepareStatement(sql);
        ps.setString(1, action); 
        ps.setInt(2, requestId); 

        int rowsUpdated = ps.executeUpdate();
        if (rowsUpdated > 0) {
            out.println("<h3>ATM Card Request " + action + "d successfully!</h3>");
        } else {
            out.println("<h3>Error: ATM Card Request not found or could not be updated.</h3>");
        }

        response.setHeader("Refresh", "1; URL=reviewATMApplications.jsp");

    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
        out.println("<h3>Error processing ATM card request: " + e.getMessage() + "</h3>");
    } finally {
        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
