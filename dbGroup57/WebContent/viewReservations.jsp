<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.sql.Timestamp, java.time.*, java.util.Calendar, java.util.Date, java.text.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@page import="java.util.logging.Logger" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Reservations</title>
</head>
<body>
	<h3>View Reservations</h3>
	<% 
		String username = (String) session.getAttribute("username");
		String password = (String) session.getAttribute("password");
		int userType = (Integer) session.getAttribute("userType");%>
		
	<p>Insert transit line or customer username.</p>
	<form action="adminViewTransitLineQuery.jsp">
		<label for="transitLine">Transit Line:</label>
		<input type="text" name="transitLine">
      	<input type="submit" value="Search">
      
  	</form>
  	<form action="adminViewCustomerQuery.jsp">
  		<label for="name">Username:</label>
		<input type="text" name="customerName">
		<input type="submit" value="Search">
  	</form>
  	<br>
			<a href="loginQuery.jsp?username=<%out.print(username);%>&password=<%out.print(password);%>">
						<input type = "submit" name = "Home" value = "Home"> </a>
  	<br>
		<form method="get" action="logout.jsp">
			<input type="submit" value="Logout">
		</form>

</body>
</html>