<%@ page import="java.sql.*" %>

<%
    Connection con = null;
    PreparedStatement ps = null;

    try {
        // Retrieve the user_id from the session before invalidating it
        Integer userId = (Integer) session.getAttribute("user_id");

        if (userId != null) {
            // Update the most recent active session for this user
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "");

            String updateLogQuery = "UPDATE session_logs SET logout_time = NOW(), status = 'logged_out' WHERE user_id = ? AND status = 'active' ORDER BY login_time DESC LIMIT 1";
            ps = con.prepareStatement(updateLogQuery);
            ps.setInt(1, userId);
            ps.executeUpdate();
        }

        // Invalidate the current session
        session.invalidate();
        
        // Redirect to the login page
        response.sendRedirect("login.jsp");

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
