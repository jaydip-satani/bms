<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("username") == null || !userSession.getAttribute("role").equals("admin")) {
        response.sendRedirect("../login.jsp"); 
        return; 
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Users</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .modal {
    display: none; 
    position: fixed;
    z-index: 1;
    left: 0;
    top: 0;
    width: 100px;
    height: 100px;
    background-color: rgba(0, 0, 0, 0.6); 
    backdrop-filter: blur(5px); 
    display: flex;
    align-items: center;
    justify-content: center;
}

.modal-content {
    background-color: #fff;
    padding: 15px; 
    border-radius: 8px;
    width: 150px; 
    max-width: 20%; 
    box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
    animation: fadeIn 0.3s ease;
}


@keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
}

    </style>
      <title>Manage Users</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <script>
        function deleteUser(userId) {
            if (confirm("Are you sure you want to delete this user?")) {
                var xhr = new XMLHttpRequest();
                xhr.open("POST", "deleteUser.jsp", true);
                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        alert(xhr.responseText);
                        location.reload();  
                    }
                };
                xhr.send("user_id=" + userId);  
            }
        }
    </script>
    <script>
        function openEditModal(userId, username, role) {
            document.getElementById('editUserId').value = userId;
            document.getElementById('editUsername').value = username;
            document.getElementById('editRole').value = role;
            document.getElementById('editModal').style.display = 'flex';
        }

        function closeEditModal() {
            document.getElementById('editModal').style.display = 'none';
        }

        function saveChanges() {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "updateUser.jsp", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

            var userId = document.getElementById('editUserId').value;
            var username = document.getElementById('editUsername').value;
            var role = document.getElementById('editRole').value;
            var data = "user_id=" + userId + "&username=" + username + "&role=" + role;

            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    alert("User updated successfully!");
                    closeEditModal();
                    location.reload();
                }
            };
            xhr.send(data);
        }
    </script>
</head>
<body class="bg-light">
    <div class="container">
        <h1 class="mt-5">Manage Users</h1>
        <table class="table table-bordered mt-4">
            <thead class="thead-light">
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Role</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection conn = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    
                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "");
                        
                        String query = "SELECT user_id, username, role FROM users";
                        ps = conn.prepareStatement(query);
                        rs = ps.executeQuery();

                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("user_id") %></td>
                    <td><%= rs.getString("username") %></td>
                    <td><%= rs.getString("role") %></td>
                    <td>
                        <button class="btn btn-sm btn-warning" 
                            onclick="openEditModal('<%= rs.getInt("user_id") %>', '<%= rs.getString("username") %>', '<%= rs.getString("role") %>')">
                            Edit
                        </button>
                        <button class="btn btn-sm btn-danger" onclick="deleteUser('<%= rs.getInt("user_id") %>')">Delete</button>
                    </td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                        if (conn != null) conn.close();
                    }
                %>
            </tbody>
        </table>
        <a href="adminDashboard.jsp" class="btn btn-primary mt-3">Back to Dashboard</a>
    </div>
    <div id="editModal" class="modal">
        <div class="modal-content">
            <span onclick="closeEditModal()" style="float: right; cursor: pointer;">&times;</span>
            <h3>Edit User</h3>
            <form onsubmit="saveChanges(); return false;">
                <input type="hidden" id="editUserId" name="user_id">
                Username: <input type="text" id="editUsername" name="username" required><br><br>
                Role:
                <select id="editRole" name="role" required>
                    <option value="admin">Admin</option>
                    <option value="customer">Customer</option>
                    <option value="employee">Employee</option>
                </select><br><br>
                <button type="button" class="btn btn-primary" onclick="saveChanges()">Save</button>
                <button type="button" class="btn btn-secondary" onclick="closeEditModal()">Cancel</button>
            </form>
        </div>
    </div>
</body>
</html>
