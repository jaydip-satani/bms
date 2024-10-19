<%@ page import="java.sql.*" %>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password"); 
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
       
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "");


        String query = "SELECT user_id, username, role FROM Users WHERE username = ? AND password = ?";
        ps = con.prepareStatement(query);
        ps.setString(1, username);
        ps.setString(2, password); 

        rs = ps.executeQuery();

        if (rs.next()) {
            String role = rs.getString("role");
            int userId = rs.getInt("user_id");
            session.setAttribute("username", username);
            session.setAttribute("role", role);
            session.setAttribute("user_id", userId);

            if ("admin".equals(role)) {
                response.sendRedirect("admin/adminDashboard.jsp");
            } else if ("customer".equals(role)) {
                response.sendRedirect("customer/customerDashboard.jsp");
            } else if ("employee".equals(role)) {
                response.sendRedirect("employees/employeeDashboard.jsp");
            }
        } else {
            request.setAttribute("errorMessage", "Invalid username or password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
