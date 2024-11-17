<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*, java.util.*, java.io.*" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("username") == null || !userSession.getAttribute("role").equals("admin")) {
        response.sendRedirect("../login.jsp"); 
        return; 
    }
%>

<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");

    String DB_URL = "jdbc:mysql://localhost:3306/bankingdb";
    String DB_USER = "root";
    String DB_PASSWORD = "";

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        
        Class.forName("com.mysql.cj.jdbc.Driver");

        
        conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

        
        String sql = "INSERT INTO users (username, password, role, email, phone, created_at) VALUES (?, ?, 'employee', ?, ?, NOW())";
        pstmt = conn.prepareStatement(sql);
        
        
        pstmt.setString(1, username);
        pstmt.setString(2, password); 
        pstmt.setString(3, email);
        pstmt.setString(4, phone);

        
        int rowsInserted = pstmt.executeUpdate();

        if (rowsInserted > 0) {
            out.println("<script type='text/javascript'>");
            out.println("alert('Registration Successful');");
            out.println("window.location.href = 'adminDashboard.jsp';");
            out.println("</script>");
        } else {
            out.println("<h1>Error: Registration failed.</h1>");
        }
    } catch (Exception e) {
        out.println("<h3>Error: " + e.getMessage() + "</h3>");
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>