<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.sql.Timestamp, java.time.*, java.util.Calendar, java.util.Date, java.text.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@page import="java.util.logging.Logger" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Transit Line Reservations</title>
</head>
<body>

	<%try{
		Logger logger=Logger.getLogger(this.getClass().getName());
     	String transitLine = request.getParameter("transitLine");
     	if(transitLine == null || transitLine.equals("")){
     		out.print("Enter valid transit line.");
     	}else{
     		ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			
			//Create a SQL statement
			Statement stmt1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			Statement stmt2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			Statement stmt3 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			Statement stmt4 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			Statement stmt5 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			Statement stmt6 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			
			String query1 = "select * from Reservation r where LOWER(r.transitLine) LIKE LOWER('" + transitLine + "')";
			ResultSet result = stmt1.executeQuery(query1);
			if(!result.next()){
				%> 
				<p>No Reservations.</p>
				<% 
			}else{
				%>
				<table style="width:100%; text-align:left">
				<tr>
					<th>Name</th>
					<th>Reservation Date</th>
					<th>Transit Line</th>
					<th>Departure Time</th>
					<th>From</th>
					<th>To</th>
					<th>Trip Type</th>
					<th>Discount</th>
					<th>Fare</th>
				</tr>
				<% 
				do{
					String username = result.getString("username");
					int origin = result.getInt("startStopID");
					int destination = result.getInt("endStopID");
					int tripType = result.getInt("tripType");
					int discount = result.getInt("discountType");
					String tLine = result.getString("transitLine");
					String query2 = "select * from User where username = '" + username + "'";
					ResultSet user = stmt2.executeQuery(query2);
					user.beforeFirst();
					String name = "";
					String email = "";
					if(user.next()){
						name = user.getString("firstName") + " " + user.getString("lastName");
						email = user.getString("email");
						
					}
					%>
					<tr>
					<td>
						<% out.print(user.getString("firstName") + " " + user.getString("lastName")); %>
					</td>
					<td>
						<% out.print(result.getString("reservationDate")); %>
					</td>
					<td>
						<% out.print(tLine); %>
					</td>
					<td>
						<% out.print(result.getString("departureTime")); %>
					</td>
					<td>
						<%  String query3 = "select * from Station where transitLine = '" + tLine + "' and stopID = " + Integer.toString(origin);
							ResultSet originStations = stmt3.executeQuery(query3);
							if(originStations.next()){
								out.print(originStations.getString("name"));
							
							}
						 
						%>
					</td>
					<td>
						<%  String query4 = "select * from Station where transitLine = '" + tLine + "' and stopID = " + Integer.toString(destination);
							ResultSet destStations = stmt4.executeQuery(query4);
							if(destStations.next()){
								out.print(destStations.getString("name"));
							
							}
						 
						%>
					</td>
					<td>
						<%  String query5 = "select * from TripType where typeID =" + Integer.toString(tripType);
							ResultSet trips = stmt5.executeQuery(query5);
							if(trips.next()){
								out.print(trips.getString("trip"));
							
							}
						 
						%>
					</td>
					<td>
						<%  String query6 = "select * from DiscountType where discountID =" + Integer.toString(discount);
							ResultSet discountType = stmt6.executeQuery(query6);
							if(discountType.next()){
								out.print(discountType.getString("person"));
							
							}
						 
						%>
					</td>
					<td>
						<% out.print(result.getFloat("totalFare"));%>
					</td>
					
				</tr>
			
				<%
				}while(result.next());
				
				%>
				</table>
				<a href="viewReservations.jsp">
				<input type = "submit" name = "Back" value = "Back">
				</a>
				<%
			}
			con.close();
			
     	}
		
	}catch(Exception ex) {
		out.print(ex);
		out.print("failed");
 	}
	%>

</body>
</html>