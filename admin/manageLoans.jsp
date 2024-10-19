<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("username") == null || !userSession.getAttribute("role").equals("admin")) {
        response.sendRedirect("../login.jsp"); 
        return; 
    }

    String action = request.getParameter("action");
    String loanId = request.getParameter("loanId");
    
    if (action != null && loanId != null) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "");

            if (action.equals("approve")) {
                String updateSql = "UPDATE loans SET loan_status = 'approved' WHERE loan_id = ?";
                ps = con.prepareStatement(updateSql);
                ps.setString(1, loanId);
                ps.executeUpdate();
            } else if (action.equals("reject")) {
                String updateSql = "UPDATE loans SET loan_status = 'rejected' WHERE loan_id = ?";
                ps = con.prepareStatement(updateSql);
                ps.setString(1, loanId);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Loans</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container">
        <h1 class="mt-5">Manage Loans</h1>
        <table class="table table-bordered mt-4">
            <thead class="thead-light">
                <tr>
                    <th>Loan ID</th>
                    <th>Customer Name</th>
                    <th>Amount</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection con = null;
                    Statement stmt = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "");

                        stmt = con.createStatement();
                        String query = "SELECT l.loan_id, u.username, l.loan_amount, l.loan_status " +
                                       "FROM loans l " +
                                       "JOIN users u ON l.user_id = u.user_id " +
                                       "WHERE l.loan_status = 'pending'"; 

                        rs = stmt.executeQuery(query);
                        
                        if (rs.next()) {
                            do {
                %>
                <tr>
                    <td><%= rs.getString("loan_id") %></td>
                    <td><%= rs.getString("username") %></td> 
                    <td><%= rs.getDouble("loan_amount") %></td>
                    <td><%= rs.getString("loan_status") %></td>
                    <td>
                        <!-- Approve Button -->
                        <form action="" method="post" style="display:inline;">
                            <input type="hidden" name="loanId" value="<%= rs.getString("loan_id") %>">
                            <input type="hidden" name="action" value="approve">
                            <button type="submit" class="btn btn-sm btn-success">Approve</button>
                        </form>
                        <!-- Reject Button -->
                        <form action="" method="post" style="display:inline;">
                            <input type="hidden" name="loanId" value="<%= rs.getString("loan_id") %>">
                            <input type="hidden" name="action" value="reject">
                            <button type="submit" class="btn btn-sm btn-danger">Reject</button>
                        </form>
                    </td>
                </tr>
                <%
                            } while (rs.next());
                        } else {
                %>
                <tr>
                    <td colspan="5" class="text-center">No pending loans found.</td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        try {
                            if (rs != null) rs.close();
                            if (stmt != null) stmt.close();
                            if (con != null) con.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                %>
            </tbody>
        </table>
        <a href="adminDashboard.jsp" class="btn btn-primary mt-3">Back to Dashboard</a>
    </div>
</body>
</html>
