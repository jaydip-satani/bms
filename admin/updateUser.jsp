<%@ page import="java.sql.*" %>
<%
    String userId = request.getParameter("user_id");
    String username = request.getParameter("username");
    String role = request.getParameter("role");

    Connection conn = null;
    PreparedStatement pst = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "");

        String query = "UPDATE users SET username = ?, role = ? WHERE user_id = ?";
        pst = conn.prepareStatement(query);
        pst.setString(1, username);
        pst.setString(2, role);
        pst.setString(3, userId);

        int rowsUpdated = pst.executeUpdate();
        if(rowsUpdated > 0) {
            response.getWriter().write("User updated successfully!");
        } else {
            response.getWriter().write("Error updating user.");
        }
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        if(pst != null) pst.close();
        if(conn != null) conn.close();
    }
%>
