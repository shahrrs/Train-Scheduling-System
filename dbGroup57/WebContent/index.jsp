<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
	<%@page import="java.util.logging.Logger" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Train System</title>
	</head>
<body>


Login or Create Account:
<br>
	<form method="get" action="login.jsp">
		<input type="submit" value="Login">
	</form>
	<form method="get" action="pickUserType.jsp">
		<input type="submit" value="Create Account">
	</form>
<br>



</body>
</html>