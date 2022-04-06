<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
</head>
<body>
	<%
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();
		String trainID = request.getParameter("trainID");
		String currentDate = request.getParameter("departureTime");
		String nextDate = request.getParameter("nextDate");
		
		String query = "DELETE FROM Schedule WHERE trainID = ? AND departureTime >= ?  AND departureTime < ? ";
		PreparedStatement ps = con.prepareStatement(query);
		ps.setString(1, trainID);
		ps.setString(2,currentDate);
		ps.setString(3,nextDate);
		
		
		PreparedStatement query2 = con.prepareStatement("Delete FROM Reservation WHERE trainID = ? AND departureTime >= ?  AND departureTime < ? ");
		query2.setString(1, trainID);
		query2.setString(2, currentDate);
		query2.setString(3, nextDate);
		
		query2.executeUpdate();
		ps.executeUpdate();
		//System.out.println("done");
		response.sendRedirect("showTransitLines.jsp");
		
		
	
		
	
		con.close();
		
		
	} catch (Exception ex) {
		out.print(ex);

	}
%>

</body>
</html>