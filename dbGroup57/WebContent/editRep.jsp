<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
	<%@page import="java.util.logging.Logger" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Edit Representative Account</title>
	</head>
<body>
<%
	Logger logger=Logger.getLogger(this.getClass().getName());
	try{
		
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		String username = request.getParameter("username");
		//Create a SQL statement
		Statement stmt = con.createStatement();
		String query = "SELECT * FROM User WHERE username = '" + username + "'";
		ResultSet result = stmt.executeQuery(query);
		result.next();
		String password = result.getString("password");
		String firstName = result.getString("firstName");
		String lastName = result.getString("lastName");
		String email = result.getString("email");
		String ssn = result.getString("ssn");
%>
<br>
	<form method="get" action="editRepQuery.jsp">
	<table>
	<tr>    
	<td>Username</td><td><input type="text" readonly="readonly" value="<%out.print(username); %>" name="username"></td>
	</tr>
	<tr>
	<td>Password</td><td><input type="text" value="<%out.print(password); %>" name="password"></td>
	</tr>
	<tr>
	<td> First Name </td> <td> <input type = "text" value="<%out.print(firstName); %>" name = "firstName"> </td>
	</tr>
	<tr>
	<td> Last Name </td> <td> <input type = "text" value="<%out.print(lastName); %>" name = "lastName"> </td>
	</tr>
	<tr>
	<td> Email </td> <td> <input type = "text" value="<%out.print(email); %>" name = "email"> </td>
	</tr>
	<tr>
	<td> SSN </td> <td> <input type = "text" value="<%out.print(ssn); %>" name = "ssn">
						</td>
	</tr>
	</table>
	<input type="submit" value="Update Account">
	</form>
<br>

<%
		con.close();
		}catch(Exception ex) {
			out.print(ex);
		}
%>