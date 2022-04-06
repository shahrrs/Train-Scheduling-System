<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
	<%@page import="java.util.logging.Logger" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Create Account</title>
	</head>
<body>

Don't have an account? Sign up here.
<br>
	<form method="get" action="createAccountQuery.jsp">
	<table>
	<tr>    
	<td>Username</td><td><input type="text" name="username"></td>
	</tr>
	<tr>
	<td>Password</td><td><input type="text" name="password"></td>
	</tr>
	<tr>
	<td> First Name </td> <td> <input type = "text" name = "firstName"> </td>
	</tr>
	<tr>
	<td> Last Name </td> <td> <input type = "text" name = "lastName"> </td>
	</tr>
	<tr>
	<td> Email </td> <td> <input type = "text" name = "email"> </td>
	</tr>
	<tr>
	</tr>
	</table>
	<input type="submit" value="Create Account">
	</form>
<br>