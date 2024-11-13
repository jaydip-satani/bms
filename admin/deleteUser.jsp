<%@ page import="java.sql.*" %>
<%
    String userId = request.getParameter("user_id");

    Connection conn = null;
    PreparedStatement pst = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "");

        String query = "DELETE FROM users WHERE user_id = ?";
        pst = conn.prepareStatement(query);
        pst.setString(1, userId);

        int rowsDeleted = pst.executeUpdate();
        if (rowsDeleted > 0) {
            response.getWriter().write("User deleted successfully!");
        } else {
            response.getWriter().write("Error: User could not be deleted.");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (pst != null) pst.close();
        if (conn != null) conn.close();
    }
%>
