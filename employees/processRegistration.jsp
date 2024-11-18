<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*, java.util.*, java.io.*, java.security.*, java.nio.charset.*" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("username") == null || !userSession.getAttribute("role").equals("employee")) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String accountType = request.getParameter("accountType"); 
    String balance = request.getParameter("balance"); 

    String DB_URL = "jdbc:mysql://localhost:3306/bankingdb";
    String DB_USER = "root";
    String DB_PASSWORD = "";

    Connection conn = null;
    PreparedStatement pstmt = null;
    PreparedStatement accountPstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

        String hashedPassword = "";
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            hashedPassword = sb.toString();
        } catch (NoSuchAlgorithmException e) {
            out.println("<h3>Error: Unable to hash the password. " + e.getMessage() + "</h3>");
            return;
        }

        String sql = "INSERT INTO users (username, password, role, email, phone, created_at) VALUES (?, ?, 'customer', ?, ?, NOW())";
        pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

        pstmt.setString(1, username);
        pstmt.setString(2, hashedPassword); 
        pstmt.setString(3, email);
        pstmt.setString(4, phone);

        int rowsInserted = pstmt.executeUpdate();
        int userId = -1;
        if (rowsInserted > 0) {
            ResultSet generatedKeys = pstmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                userId = generatedKeys.getInt(1);
            }
        }

        if (userId != -1) {
            String accountSql = "INSERT INTO accounts (user_id, account_type, balance, status, created_at) VALUES (?, ?, ?, 'active', NOW())";
            accountPstmt = conn.prepareStatement(accountSql);

            accountPstmt.setInt(1, userId);
            accountPstmt.setString(2, accountType); 
            accountPstmt.setString(3, balance); 

            int accountRowsInserted = accountPstmt.executeUpdate();

            if (accountRowsInserted > 0) {
                out.println("<script type='text/javascript'>");
                out.println("alert('Registration and Account Creation Successful');");
                out.println("window.location.href = 'employeeDashboard.jsp';");
                out.println("</script>");
            } else {
                out.println("<h1>Error: Account creation failed.</h1>");
            }
        } else {
            out.println("<h1>Error: Registration failed. User ID not retrieved.</h1>");
        }
        
    } catch (Exception e) {
        out.println("<h3>Error: " + e.getMessage() + "</h3>");
    } finally {
        // Close resources
        if (accountPstmt != null) try { accountPstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
