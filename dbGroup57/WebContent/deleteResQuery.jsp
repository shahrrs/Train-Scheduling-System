<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Delete Reservation</title>
</head>
<body>
<%
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();
		String resID = request.getParameter("resID");
		String query = "DELETE FROM Reservation WHERE reservationID = ?";
		PreparedStatement ps = con.prepareStatement(query);
		ps.setString(1, resID);
		ps.executeUpdate();
		out.print("Reservation Deleted.");
		boolean state = true;
		if(state){
		%>

		<br>
			<form method="get" action="viewReservationFromUser.jsp">
				<input type="submit" value="View Reservations">
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