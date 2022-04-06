<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Update Representative Account</title>
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
		String password = request.getParameter("password");
		String firstName = request.getParameter("firstName");
		String lastName = request.getParameter("lastName");
		String email = request.getParameter("email");
		String ssn = request.getParameter("ssn");
		
		if(password.isEmpty() || firstName.isEmpty() || lastName.isEmpty() || email.isEmpty() || ssn.isEmpty()){
			out.print("Account not updated: A field was left blank.");
			%>
			<br>
				<form method="get" action="customerReps.jsp">
					<input type="submit" value="Manage Representatives">
				</form>
			<br>
			<% 
		}else{
			int userType = 2; 
			String update = "UPDATE User SET username=?, password=?, lastName=?, firstName=?, email=?, userType=?, ssn=? WHERE username='" + username + "'";
			PreparedStatement ps = con.prepareStatement(update);
			ps.setString(1, username);
			ps.setString(2, password);
			ps.setString(3, lastName);
			ps.setString(4, firstName); 
			ps.setString(5, email);
			ps.setInt(6, userType);
			ps.setString(7, ssn);
			
			ps.executeUpdate();
			out.print("Account Updated.");
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
			
		
		}
		con.close();
		
		
	} catch (Exception ex) {
		out.print(ex);

	}
%>

</body>
</html>