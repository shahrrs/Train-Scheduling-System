<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.sql.Timestamp, java.time.*, java.util.Calendar, java.util.Date, java.text.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@page import="java.util.logging.Logger" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Stops</title>
</head>
<body>
<h3>View Stops</h3>

		<%
		Logger logger=Logger.getLogger(this.getClass().getName());
		try{
			%>
			<p>Origin: <%out.print(request.getParameter("originName"));%></p>
			<p>Destination: <%out.print(request.getParameter("destName"));%></p>
			<%
			String currentStopID = request.getParameter("origin");
			String nextStopID = request.getParameter("destination");
			String transitLine = request.getParameter("transitLine");
			String trainID = request.getParameter("trainID");
			String departureTime = request.getParameter("depart");
			String arrivalTime = request.getParameter("arrival");
			
			String query1="";
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			Statement stmt1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			Statement stmt2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			Statement stmt3 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			
			if(Integer.parseInt(request.getParameter("origin")) > Integer.parseInt(request.getParameter("destination"))){
				query1="select * from Schedule where transitLine = '" + transitLine + "' and (currentStop =" + currentStopID + " or nextStop = " + nextStopID + ") and currentStop > nextStop and departureTime >= '" + departureTime + "' and arrivalTime <= '" + arrivalTime + "' order by departureTime";
			}else{
				query1="select * from Schedule where transitLine = '" + transitLine + "' and (currentStop =" + currentStopID + " or nextStop = " + nextStopID + ") and currentStop < nextStop and departureTime >= '" + departureTime + "' and arrivalTime <= '" + arrivalTime + "' order by departureTime";
			}
			ResultSet schedules = stmt1.executeQuery(query1);
			schedules.beforeFirst();
			%>
			<table style="width:100%; text-align:left">
				<tr>
					<th>Depart Time</th>
					<th>Arrival Time</th>
					<th>From</th>
					<th>To</th>
				</tr>
			<%
			while(schedules.next()){
				%>
				<tr>
					<td>
						<% out.print(schedules.getString("departureTime")); %>
					</td>
					<td>
						<% out.print(schedules.getString("arrivalTime")); %>
					</td>
					<td>
						<% 
						int startID = schedules.getInt("currentStop");
						String query2 = "select * from Station where stopID = " + Integer.toString(startID) + " and transitLine = '" + transitLine + "'";
						ResultSet startStation = stmt2.executeQuery(query2);
						String startName="";
						if(startStation.next()){
							startName = startStation.getString("name");
						}
						out.print(startName); 
						%>
					</td>
					<td>
						<%
						int endID = schedules.getInt("nextStop");
						String query3 = "select * from Station where stopID = " + Integer.toString(endID) + " and transitLine = '" + transitLine + "'";
						ResultSet endStation = stmt3.executeQuery(query3);
						String endName="";
						if(endStation.next()){
							endName = endStation.getString("name");
						}
						out.print(endName);
					 	%>
					</td>
				</tr>
				
				<%
			}
			con.close();
		}catch(Exception ex) {
			out.print(ex);
			out.print("failed");
	 	}
		%>
		</table>
		<a href="searchSchedules.jsp">
			<input type = "submit" name = "Back" value = "Back">
		</a>

</body>
</html>