<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Create Account</title>
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
		
		int userType = 1; 
		//System.out.println(request.getParameter("userType"));
		
		//query for db
		String query = "SELECT * FROM User WHERE username = '" + username + "'";
		ResultSet result = stmt.executeQuery(query);
		
		if(result.next()){
			out.print("Username is not available.");
			request.getRequestDispatcher("createAccount.jsp").include(request, response);
			
		}else{
			String insert = "INSERT INTO User(username, password, lastName, firstName, email, userType)"
				+ "VALUES (?, ?, ?, ?, ?, ?)";
			
			PreparedStatement ps = con.prepareStatement(insert);
			ps.setString(1, username);
			ps.setString(2, password);
			ps.setString(3, lastName);
			ps.setString(4, firstName); 
			ps.setString(5, email);
			ps.setInt(6, userType);
			
			ps.executeUpdate();
			out.print("Account Created.");
			boolean state = true;
			if(state){
			%>

			<br>
				<form method="get" action="login.jsp">
					<input type="submit" value="Login Here">
				</form>
			<br>
			<% 
			}
			
		}
		
		con.close();
		
		
	} catch (Exception ex) {
		out.print(ex);
		out.print("insert failed");
	}
%>

</body>
</html>