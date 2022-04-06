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
<h3>Here are the available destinations.</h3>
<form method="get" action="createResPickTime.jsp">
<%
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();
		String username = (String) session.getAttribute("username");
		String tripType = (String) session.getAttribute("tripType");
		String personType = (String) session.getAttribute("discountType");
		String transitLine = (String) session.getAttribute("transitline");
		String start = request.getParameter("startStop");
		session.setAttribute("startStop", start);
		%>
		<label for="endStop">Please select where you are going:</label>
		<select name="endStop" id="endStop">
			<option selected disabled >Choose location.</option>
			<%
			String query1 = "SELECT name FROM TrainSystem.Station where transitLine ='" + transitLine + "' and name <> '" + start + "'";
			ResultSet names = stmt.executeQuery(query1);
			while(names.next()){
				%>
				<option value="<%out.print(names.getString("name"));%>"><%out.print(names.getString("name"));%></option>
				<%
			}
			%>
		</select>
		<input type="submit" name="t" value="Pick a time.">
		<%
		//String transitline = request.getParameter("transitline");
		//if(transitline == null){ 

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