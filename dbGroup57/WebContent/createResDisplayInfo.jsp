<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
        <%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@page import="java.util.logging.Logger" %>

  
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Here is the final reservation information.</title>
</head>
<body>
<h3>Here are the final details on your reservation.</h3>
<%
	try {// fare = (50*number of stops)/ total number of stops also, child = 25%, senior = 35%, disabled = 50%

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();
		//String query = "SELECT arrivalTime FROM TrainSystem.Schedule where transitLine = '" + transitLine + "' and currentStop = (select stopID from TrainSystem.Station where transitLine = '" + transitLine+ "' and name = '" + start + "')";
		//ResultSet arrival = stmt.executeQuery(query);
		//String arrivalTime = "";
		//String trainID = "";
		//String currentStop = "";
		//String nextStop = "";
		//while(arrival.next()){
			//arrivalTime = arrival.getString("arrivalTime");
			//trainID = arrival.getString("trainID");
			//currentStop = arrival.getString("currentStop");	
		//}
		String reservationDate = (String) session.getAttribute("resDate");
		String username = (String) session.getAttribute("username");

		//String trainID = (String) session.getAttribute("trainID");
		String departTime = request.getParameter("startTime");
		
		String tripType = (String) session.getAttribute("tripType");
		String personType = (String) session.getAttribute("discountType");
		String transitLine = (String) session.getAttribute("transitline");
		String start = (String) session.getAttribute("startStop");
		String end = (String) session.getAttribute("endStop");
		String startID = "";
		String endID = "";
		Statement stmt6 = con.createStatement();
		String query6 = "SELECT trainID, currentStop FROM TrainSystem.Schedule where transitLine = '" + transitLine + "' and departureTime = '"+ departTime + "' and currentStop = (select stopID from TrainSystem.Station where transitLine = '" + transitLine+ "' and name = '" + start + "')";
		ResultSet names = stmt.executeQuery(query6);
		names.next();
		String trainID = names.getString("trainID");
		startID = names.getString("currentStop");
		session.setAttribute("startStopID", startID);
		session.setAttribute("trainID", trainID);
		Statement stmt1 = con.createStatement();
		String query1 = "SELECT fixedFare FROM TrainSystem.TransitLine where name = '" + transitLine+ "'";
		ResultSet farefetch = stmt1.executeQuery(query1);
		Statement stmt2 = con.createStatement();
		String query2 = "select stopID from TrainSystem.Station where transitLine = '" + transitLine+ "' and name = '" + start + "'";
		ResultSet startFetch = stmt2.executeQuery(query2);
		Statement stmt3 = con.createStatement();
		String query3 = "select stopID from TrainSystem.Station where transitLine = '" + transitLine+ "' and name = '" + end + "'";
		ResultSet endFetch = stmt3.executeQuery(query3);
		Statement stmt4 = con.createStatement();
		String query4 = "SELECT COUNT(stopID) FROM TrainSystem.Station Where transitLine = '" + transitLine+ "'";
		ResultSet numberOfStopsFetch = stmt4.executeQuery(query4);
		String totalFare = "";
		while(farefetch.next() && startFetch.next() && endFetch.next() && numberOfStopsFetch.next()){
			float fixedFare = farefetch.getFloat("fixedFare");
			float numberOfStops = Math.abs(endFetch.getFloat("stopID") - startFetch.getFloat("stopID"));
			float maxNumberOfStops = numberOfStopsFetch.getFloat("COUNT(stopID)") - 1;
			if(personType.equals("Child")){
				totalFare = String.valueOf(((fixedFare*numberOfStops)/maxNumberOfStops)*0.25);
			}
			else if(personType.equals("Senior")){
				totalFare = String.valueOf(((fixedFare*numberOfStops)/maxNumberOfStops)*0.35);
			}
			else if(personType.equals("Disabled")){
				totalFare = String.valueOf(((fixedFare*numberOfStops)/maxNumberOfStops)*0.50);
			}
			else{
				totalFare = String.valueOf(((fixedFare*numberOfStops)/maxNumberOfStops));
			}
			if(tripType.equals("One-Way")==false){
				float temp = Float.parseFloat(totalFare);
				temp = temp*2;
				totalFare = String.valueOf(temp);
			}
		}
		Statement stmt5 = con.createStatement();
		String query5 = "SELECT MAX(reservationID) FROM TrainSystem.Reservation";
		ResultSet findResID = stmt4.executeQuery(query5);
		String reservationID = "";
		while(findResID.next()){
			int ID = (int)findResID.getFloat("MAX(reservationID)");
			reservationID = String.valueOf(ID+1);
		}
		if(tripType.equals("Round Trip")){
			end = "You will end back where you started at " + start + " with a middle stop being " + end;
		}
		session.setAttribute("resID", reservationID);
		session.setAttribute("totalFare", totalFare);
		session.setAttribute("departTime", departTime);
		float tfare = Float.parseFloat(totalFare);
		//out.print(tfare);
		totalFare = String.format("%.2f", tfare);
		%>
		<p>Your reservation identification is: <% out.print(reservationID); %>
		<br>Your username is: <% out.print(username); %>
		<br>Today's date is: <% out.print(reservationDate); %>
		<br>The train identification is: <% out.print(trainID); %>
		<br>Your departure time is: <% out.print(departTime); %>
		<br>Your trip type is: <% out.print(tripType); %>
		<br>Your discount type is for: <% out.print(personType); %>
		<br>Your total fare is: $<% out.print(totalFare); %>
		<br>Your transit line is: <% out.print(transitLine); %>
		<br>Your start location is: <% out.print(start); %>
		<br>Your end location is: <% out.print(end); %>
		</p>
		
		<form method="get" action="createResConfirm.jsp">
		<input type="submit" value="Book reservation.">
	</form>
		<%
		//String transitline = request.getParameter("transitline");
		//if(transitline == null){ 

		//}
		
		
		
		
		con.close();
		
		
	} catch (Exception ex) {
		out.print(ex);
	}
%>
</body>
</html>