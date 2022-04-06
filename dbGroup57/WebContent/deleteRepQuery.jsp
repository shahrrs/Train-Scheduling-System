<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Delete Representative Account</title>
</head>
<body>
	<%
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();
		String username = request.getParameter("username");
		String query = "DELETE FROM User WHERE username = ?";
		PreparedStatement ps = con.prepareStatement(query);
		ps.setString(1, username);
		ps.executeUpdate();
		out.print("Account Deleted.");
		boolean state = true;
		if(state){
		%>

		<br>
			<form method="get" action="customerReps.jsp">
				<input type="submit" value="Manage Representatives">
			</form>
		<br>
		<% 
		}
			
		
		
		con.close();
		
		
	} catch (Exception ex) {
		out.print(ex);

	}
%>

</body>
</html>