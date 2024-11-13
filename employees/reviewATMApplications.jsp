<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%-- <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> --%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cheque Book Requests</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<div class="container mt-5">
    <h2>Cheque Book Requests</h2>

    <!-- Table displaying all requests -->
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>Request ID</th>
                <th>Customer Name</th>
                <th>Account ID</th>
                <th>Contact Number</th>
                <th>Request Date</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="request" items="${chequeBookRequests}">
                <tr>
                    <td>${request.request_id}</td>
                    <td>${request.customer_name}</td>
                    <td>${request.account_id}</td>
                    <td>${request.contact_number}</td>
                    <td>${request.request_date}</td>
                    <td>${request.status}</td>
                    <td>
                        <a href="approveRequest.jsp?id=${request.request_id}" class="btn btn-success btn-sm">Approve</a>
                        <a href="rejectRequest.jsp?id=${request.request_id}" class="btn btn-danger btn-sm">Reject</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

</div>

<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js"></script>
</body>
</html>
