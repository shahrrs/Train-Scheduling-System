<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@page import="java.util.logging.Logger" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Manage Customer Representatives</title>
</head>
<body>
	<h3>Manage Customer Representatives</h3>
	
	<%
	Logger logger=Logger.getLogger(this.getClass().getName());
	String username = (String) session.getAttribute("username");
	String password = (String) session.getAttribute("password");
	int userType = (Integer) session.getAttribute("userType");
	
	try{
	
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		//Create a SQL statement
		Statement stmt = con.createStatement();
		String query1 = "SELECT * FROM User WHERE userType = 2;";
		ResultSet result = stmt.executeQuery(query1);
		%>

		<table>
		<tr>
			<th>Username</th>
			<th>SSN</th>
			<th>Name</th>
			<th>Email</th>
		</tr>
		<%
		while(result.next()){ %>
			<tr>
				<td>
					<% out.print(result.getString("username")); %>
				</td>
				<td>
					<% out.print(result.getString("ssn")); %>
				</td>
				<td>
					<% out.print(result.getString("firstName") + " " + result.getString("lastName")); %>
				</td>
				<td>
					<% out.print(result.getString("email")); %>
				</td>
				<td>
					<a href="editRep.jsp?username=<%out.print(result.getString("username")); %>">Edit</a>
				</td>
				<td>
					<a href="deleteRepQuery.jsp?username=<%out.print(result.getString("username")); %>">Delete</a>
				</td>
			</tr>

			
		<%
		
		
		}
		%>
		</table>
		<form method="get" action="createRep.jsp">
		<input type="submit" value="Add New Representative">
		</form>
		<br>
		<a href="loginQuery.jsp?username=<%out.print(username);%>&password=<%out.print(password);%>">
		<input type = "submit" name = "Home" value = "Home"> </a>
		<form method="get" action="logout.jsp">
		<input type="submit" value="Logout">
		</form>
		<%
		con.close();
	}catch(Exception ex) {
		out.print(ex);
	}
	%>


</body>
</html>