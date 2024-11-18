<%@ page import="java.sql.*, java.security.*, java.nio.charset.*" %>
<%@ page language="java" %>

<%
    String username = request.getParameter("username");
    String newPassword = request.getParameter("password"); 
    String phone = request.getParameter("phone"); 
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "");

        String query = "SELECT user_id, username, role, phone FROM Users WHERE username = ? AND phone = ?";
        ps = con.prepareStatement(query);
        ps.setString(1, username);
        ps.setString(2, phone);

        rs = ps.executeQuery();

        if (rs.next()) {
            String role = rs.getString("role");
            int userId = rs.getInt("user_id");

            String hashedPassword = "";
            try {
                MessageDigest md = MessageDigest.getInstance("SHA-256");
                byte[] hashedBytes = md.digest(newPassword.getBytes(StandardCharsets.UTF_8));
                StringBuilder sb = new StringBuilder();
                for (byte b : hashedBytes) {
                    sb.append(String.format("%02x", b));
                }
                hashedPassword = sb.toString();
            } catch (NoSuchAlgorithmException e) {
                out.println("<h3>Error: Unable to hash the password. " + e.getMessage() + "</h3>");
                return;
            }

            String qry = "UPDATE users SET password = ? WHERE user_id = ?";
            ps = con.prepareStatement(qry);
            ps.setString(1, hashedPassword); 
            ps.setInt(2, userId);         

            int rowsUpdated = ps.executeUpdate(); 

            if (rowsUpdated > 0) {
                out.println("<script type='text/javascript'>");
                out.println("alert('Password Change Successfully');");
                out.println("window.location.href = 'login.jsp';");
                out.println("</script>");
            } else {
                out.println("<h1>Error: Password Not Changed.</h1>");
            }
        } else {
            request.setAttribute("errorMessage", "Invalid username or phone number");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
