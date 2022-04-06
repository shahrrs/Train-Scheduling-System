<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
    <%@ page import="java.io.*,java.util.*,java.sql.*, java.sql.Timestamp, java.time.*, java.util.Calendar, java.util.Date, java.text.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@page import="java.util.logging.Logger" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Here are all of your reservations.</title>
</head>
<body>
<h3>Here are reservations.</h3>
<%
	String username = (String) session.getAttribute("username");
	String password = (String) session.getAttribute("password");
	int userType = (Integer) session.getAttribute("userType");
	try{
	
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		//Create a SQL statement
		Statement stmt = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		String query1 = "SELECT * FROM TrainSystem.Reservation WHERE username = '" + username + "'";
		ResultSet result = stmt.executeQuery(query1);
		String resID = "";
		%>

		<table>
		<tr>
			<th>ID</th>
			<th>Date of Reservation</th>
			<th>Train ID</th>
			<th>Depart Time</th>
			<th>Trip Type</th>
			<th>Discount Type</th>
			<th>Total Fare</th>
			<th>Transit Line</th>
			<th>Begin Location</th>
			<th>End Location</th>
		</tr>
		<%
		while(result.next()){ %>
			<tr>
				<td>
					<% 
					out.print(result.getString("reservationID")); 
					resID = result.getString("reservationID");
					%>
				</td>
				<td>
					<% out.print(result.getString("reservationDate")); %>
				</td>
				<td>
					<% out.print(result.getString("trainID")); %>
				</td>
				<td>
					<% out.print(result.getString("departureTime")); %>
				</td>
				<td>
					<% 
					int tripTypeID = result.getInt("tripType");
					String tripType = "";
					if(tripTypeID == 1){
						tripType = "One-Way";
					}
					else{
						tripType = "Round Trip";
					}

					out.print(tripType); %>
				</td>
				<td>
					<% 
					int discountID = result.getInt("discountType");
					String discountType = "";
					if(discountID == 1){
						discountType = "Child";
					}
					else if(discountID == 2){
						discountType = "Senior";
					}
					else if(discountID == 3){
						discountType = "Disabled";
					}
					else{
						discountType = "Adult";
					}
					out.print(discountType); %>
				</td>
				<td>
					<% out.print(result.getString("totalFare")); %>
				</td>
				<td>
					<% out.print(result.getString("transitLine")); %>
				</td>
				<td>
					<% 
					String transitLine = result.getString("transitLine");
					String startStopID = result.getString("startStopID");
					Statement stmt2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
					String query2 = "SELECT name FROM TrainSystem.Station WHERE stopID = '" + startStopID + "' and transitLine = '" + transitLine + "'";
					ResultSet fetchStartID = stmt2.executeQuery(query2);
					fetchStartID.next();
					out.print(fetchStartID.getString("name")); %>
				</td>
				<td>
					<% 
					String endStopID = result.getString("endStopID");
					Statement stmt3 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
					String query3 = "SELECT name FROM TrainSystem.Station WHERE stopID = '" + endStopID + "' and transitLine = '" + transitLine + "'";
					ResultSet fetchEndID = stmt3.executeQuery(query3);
					fetchEndID.next();
					out.print(fetchEndID.getString("name")); 
					%>
				</td>
				<td>
					<a href="deleteResQuery.jsp?resID=<%out.print(result.getString("reservationID")); %>">Delete</a>
				</td>
			</tr>


		<%
		}
		%>
		</table>
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