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
<h3>Here are the available times.</h3>
<form method="get" action="createResDisplayInfo.jsp">
<%
	try {// fare = (50*number of stops)/ total number of stops also, child = 25%, senior = 35%, disabled = 50%

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();
		String username = (String) session.getAttribute("username");
		String tripType = (String) session.getAttribute("tripType");
		String personType = (String) session.getAttribute("discountType");
		String transitLine = (String) session.getAttribute("transitline");
		String start = (String) session.getAttribute("startStop");
		String end = request.getParameter("endStop");
		String reservationDate = (String) session.getAttribute("resDate");
		session.setAttribute("endStop", end);

		%>
		<label for="startTime">Please select what time you are going:</label>
		<select name="startTime" id="startTime">
			<option selected disabled >Choose a time.</option>
			<%
			Statement stmt2 = con.createStatement();
			String query2 = "select stopID from TrainSystem.Station where transitLine = '" + transitLine+ "' and name = '" + start + "'";
			ResultSet names2 = stmt2.executeQuery(query2);
			names2.next();
			String startID = names2.getString("stopID");
			Statement stmt3 = con.createStatement();
			String query3 = "select stopID from TrainSystem.Station where transitLine = '" + transitLine+ "' and name = '" + end + "'";
			ResultSet names3 = stmt3.executeQuery(query3);
			names3.next();
			String endID = names3.getString("stopID");
			String query1 = "";
			if(Integer.parseInt(endID) > Integer.parseInt(startID)){
				query1 = "SELECT departureTime FROM TrainSystem.Schedule where departureTime > '" + reservationDate + "' and transitLine = '" + transitLine + "' and currentStop = '" + startID + "' and currentStop < nextStop";
			}
			else{
				query1 = "SELECT departureTime FROM TrainSystem.Schedule where departureTime > '" + reservationDate + "' and transitLine = '" + transitLine + "' and currentStop = '" + startID + "' and currentStop > nextStop";
			}
			ResultSet names = stmt.executeQuery(query1);
			while(names.next()){
				//String trainID = names.getString("trainID");
				//String arrivalTime = names2.getString("arrivalTime");
				//String startStopID = names.getString("currentStop");
				//String endStopID = names2.getString("nextStop");
				
				//session.setAttribute("arrivalTime", arrivalTime);
				//session.setAttribute("startStopID", startStopID );
				//session.setAttribute("endStopID", endStopID);
				%>
				<option value="<%out.print(names.getString("departureTime"));%>"><%out.print(names.getString("departureTime"));%></option>
				<%
			}
			%>
		</select>
		<input type="submit" name="t" value="Next">
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