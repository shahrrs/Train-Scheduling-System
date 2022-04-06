<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
    <%@ page import="java.io.*,java.util.*,java.sql.*"%>
    <%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@page import="java.util.logging.Logger" %>
<%@page import = "java.text.SimpleDateFormat" %>
<%@page import = "java.util.Date" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Reservation confirmation page.</title>
</head>
<body>
<%
	String password = (String) session.getAttribute("password");
	int userType = (Integer) session.getAttribute("userType");
	try {// fare = (50*number of stops)/ total number of stops also, child = 25%, senior = 35%, disabled = 50%

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();
		String resID = (String) session.getAttribute("resID");
		String username = (String) session.getAttribute("username");
		String resDate = (String) session.getAttribute("resDate");
		String trainID = (String) session.getAttribute("trainID");
		String departTime = (String) session.getAttribute("departTime");
		int tripTypeID;
		String tripType = (String) session.getAttribute("tripType");
		if (tripType.equals("One-Way")) {
			tripTypeID = 1;
		}
		
		else {
			tripTypeID = 2;
		}
		String discountType = (String) session.getAttribute("discountType");
		int discountTypeID;
		if (discountType.equals("Child")) {
			discountTypeID = 1;
		}
		if (discountType.equals("Senior")) {
			discountTypeID = 2;
		}
		if (discountType.equals("Disabled")) {
			discountTypeID = 3;
		}
		else{
			discountTypeID = 4;
		}
		String transitLine = (String) session.getAttribute("transitline");
		String totalFare = (String) session.getAttribute("totalFare");
		String startStopID = (String) session.getAttribute("startStopID");
		//String endStopID = (String) session.getAttribute("endStopID");
		String end = (String) session.getAttribute("endStop");
		
		Statement stmt3 = con.createStatement();
		String query2 = "SELECT arrivalTime, trainID, nextStop FROM TrainSystem.Schedule where transitLine = '" + transitLine + "' and trainID = '" + trainID + "' and nextStop = (select stopID from TrainSystem.Station where transitLine = '" + transitLine+ "' and name = '" + end + "') ORDER BY arrivalTime";
		ResultSet names2 = stmt3.executeQuery(query2);
		if(names2.next()==false){
			out.print("An error occurred where this route is not possible.");
			%>
			<form method="get" action="createRes.jsp">
			<input type="submit" value="Create a different reservation.">
			</form>
			<% 
		}
		else{
			String arrivalTime = names2.getString("arrivalTime");
			
			String endStopID = names2.getString("nextStop");
			System.out.println(endStopID);
			session.setAttribute("arrivalTime", arrivalTime);
			session.setAttribute("endStopID", endStopID);
			
			String query = "SELECT * FROM Reservation WHERE reservationID = '" + resID + "'";
			
			ResultSet result = stmt.executeQuery(query);
			
			if(result.next()){
				request.getRequestDispatcher("createRes.jsp").include(request, response);
			}else{
				String insert = "INSERT INTO Reservation(reservationID, username, reservationDate, trainID, departureTime, tripType, discountType, totalFare, transitLine, startStopID, endStopID)"
						+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
				if(tripTypeID == 2){
					Float tempFare = Float.parseFloat(totalFare);
					tempFare = tempFare/2;
					totalFare = String.valueOf(tempFare);
				}
				float tfare = Float.parseFloat(totalFare);
				totalFare = String.format("%.2f", tfare);
				PreparedStatement ps = con.prepareStatement(insert);
				ps.setString(1, resID);
				ps.setString(2, username);
				ps.setString(3, resDate);
				ps.setString(4, trainID); 
				ps.setString(5, departTime);
				ps.setInt(6, tripTypeID);
				ps.setInt(7, discountTypeID);
				ps.setString(8, totalFare);
				ps.setString(9, transitLine); 
				ps.setString(10, startStopID);
				ps.setString(11, endStopID);
				
				ps.executeUpdate();
				
				if(tripTypeID == 2){
					int tempResID = Integer.parseInt(resID);
					tempResID = tempResID + 1;
					String resID2 = String.valueOf(tempResID);
					Statement stmt7 = con.createStatement();
					
					String query7 = "SELECT departureTime FROM TrainSystem.Schedule where trainID = '" + trainID + "' and nextStop = '" + startStopID + "' and departureTime > '" + arrivalTime + "'";
					
					ResultSet fetchRoundDepart = stmt7.executeQuery(query7);
	
					fetchRoundDepart.next();
					String departTime2 = fetchRoundDepart.getString("departureTime");
					
					PreparedStatement ps2 = con.prepareStatement(insert);
					ps2.setString(1, resID2);
					ps2.setString(2, username);
					ps2.setString(3, resDate);
					ps2.setString(4, trainID); 
					ps2.setString(5, departTime2);
					ps2.setInt(6, tripTypeID);
					ps2.setInt(7, discountTypeID);
					ps2.setString(8, totalFare);
					ps2.setString(9, transitLine); 
					ps2.setString(10, endStopID);
					ps2.setString(11, startStopID);
					
					ps2.executeUpdate();
				
				}
			
				out.print("Reservation has been booked.");
				boolean state = true;
				if(state){
					%>
			
					<br>
					<a href="loginQuery.jsp?username=<%out.print(username);%>&password=<%out.print(password);%>">
					<input type = "submit" name = "Home" value = "Home"> </a>
					<form method="get" action="logout.jsp">
					<input type="submit" value="Logout">
					</form>
					<% 
				}
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