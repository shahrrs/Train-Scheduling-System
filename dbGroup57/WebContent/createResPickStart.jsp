<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Create Reservation</title>
</head>
<body>
<h3>Please choose a start location.</h3>
	<form method="get" action="createResPickDest.jsp">
	<%
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();
		String username = request.getParameter("username");
		String tripType = request.getParameter("tripType");
		String personType = request.getParameter("discountType");
		String transitLine = request.getParameter("transitline");
		session.setAttribute("username", username);
		session.setAttribute("tripType", tripType);
		session.setAttribute("discountType", personType);
		session.setAttribute("transitline", transitLine);
		//String transitline = request.getParameter("transitline");
		//if(transitline == null){ %>
			
			<label for="startStop">Start location:</label>
			<select name="startStop" id="startStop">
				<option selected disabled >Choose start location.</option>
				<%
				String query1 = "SELECT state, city, name FROM TrainSystem.Station where transitLine ='" + transitLine + "'";
				ResultSet names = stmt.executeQuery(query1);
				while(names.next()){
					%>
					<option value="<%out.print(names.getString("name"));%>"><%out.print(names.getString("name"));%></option>
					<%
				}
				%>
			</select>
			<input type="submit" name="t" value="Next">
			<%
		//}
		
		
		
		
		con.close();
		
		
	} catch (Exception ex) {
		out.print(ex);
		out.print("insert failed");
	}
%>
</form>

</body>
</html>