<%@ page import="java.sql.*, java.security.*, java.nio.charset.*, java.net.*" %>
<%@ page language="java" %>

<%!

    public String hashPassword(String passwordToHash) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hashedBytes = md.digest(passwordToHash.getBytes(StandardCharsets.UTF_8));
        StringBuilder sb = new StringBuilder();
        for (byte b : hashedBytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }

    public String getClientIp(HttpServletRequest request) {
        String ipAddress = request.getHeader("X-Forwarded-For");
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getHeader("Proxy-Client-IP");
        }
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getRemoteAddr();
        }
        return ipAddress;
    }

%>

<%
    String username = request.getParameter("username");
    String password = request.getParameter("password"); 
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        String hashedPassword = hashPassword(password);

        String clientIp = getClientIp(request);

        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "");

        String query = "SELECT user_id, username, role FROM Users WHERE username = ? AND password = ?";
        ps = con.prepareStatement(query);
        ps.setString(1, username);
        ps.setString(2, hashedPassword);

        rs = ps.executeQuery();

        if (rs.next()) {
            String role = rs.getString("role");
            int userId = rs.getInt("user_id");

            String sessionId = session.getId();

            String insertLogQuery = "INSERT INTO session_logs (user_id, session_id, ip_address, status) VALUES (?, ?, ?, 'active')";
            PreparedStatement logPs = con.prepareStatement(insertLogQuery);
            logPs.setInt(1, userId);
            logPs.setString(2, sessionId);
            logPs.setString(3, clientIp);
            logPs.executeUpdate();
            logPs.close();

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
    } catch (NoSuchAlgorithmException e) {
        out.println("<h3>Error: Unable to hash the password. " + e.getMessage() + "</h3>");
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
