<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.util.Date, java.text.*, java.sql.Timestamp, java.time.*, java.util.Calendar"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@page import="java.util.logging.Logger" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Change Schedule</title>
</head>
<body>

	<h3> Edit Times </h3>
	  
	<%	
	
		Logger logger=Logger.getLogger(this.getClass().getName());
		String username = (String) session.getAttribute("username");
		String password = (String) session.getAttribute("password");
		int userType = (Integer) session.getAttribute("userType");
		
		try{
		
			
				ApplicationDB db = new ApplicationDB();	
				Connection con = db.getConnection();
				
				//Create a SQL statement
			
				Statement stmt = con.createStatement();
				String trainID = request.getParameter("trainID");
				String departureTime = request.getParameter("departureTime");
				String arrivalTime = request.getParameter("arrivalTime");
			
				String currentDate = request.getParameter("currentDate");
				String nextDate = request.getParameter("nextDate");
	
			
				
				
				PreparedStatement query1 = con.prepareStatement("SELECT * FROM Schedule WHERE trainID = ? AND departureTime = ?  AND  arrivalTime = ? ");
				query1.setString(1, trainID);
				query1.setString(2, departureTime);
				query1.setString(3, arrivalTime);
				ResultSet schedule = query1.executeQuery();
				schedule.next();
				
			
				Statement stm2= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
				
				String query2 = "SELECT * FROM Schedule WHERE trainID = '" + trainID + "' AND departureTime >= '" + currentDate + "'  AND departureTime < '" + nextDate + "' order by departureTime";
				
				ResultSet entireSet = stm2.executeQuery(query2);
				String previous = "";
				String next = "";
			//	entireSet.first();
				
				if(!entireSet.next()) {
					System.out.println("hi");
				}
				//Algorithm: Find regular full result set order by depart time and find location of this result, compare before and after rows to this updated thing
				else {
						entireSet.beforeFirst();
						while(entireSet.next()) 
						 {
							String compDepart = entireSet.getString("departureTime");
							String compArrival = entireSet.getString("arrivalTime");
							//System.out.println(compDepart + " " + departureTime);
							//System.out.println(compArrival + " " + arrivalTime);
							if (compDepart.equals(departureTime) && compArrival.equals(arrivalTime)) {
								//System.out.println("testing");
								if (entireSet.next()) {
									//System.out.println("testing3");
									next = entireSet.getString("departureTime");
									//System.out.println(next);
									
								}
								entireSet.previous();
								//System.out.println(entireSet.getInt("currentStop"));
								
								if (entireSet.previous()) {
									//System.out.println("testing2");
									previous = entireSet.getString("arrivalTime");
									//System.out.println(previous);
									entireSet.next();
									//System.out.println(entireSet.getInt("currentStop"));
								}
								break;
							}
						}
						
						
				
						%>
						<form method="get" action="editScheduleQuery.jsp">
						<input type = "hidden" value = "<% out.print(previous); %>" name = "previousArrival">
						<input type = "hidden" value = "<% out.print(next); %>" name = "nextDeparture">
						<input type = "hidden" value = "<% out.print(schedule.getString("departureTime"));%>" name = originalDeparture>
						<table style="width:100%; text-align:center">
						<tr>
							<th>Travel Date</th>
							<th>Departure Time</th>
							<th>Arrival Time</th>
							<th>From</th>
							<th>To</th>
							<th>TransitLine</th>
							<th>Train</th>
							
						</tr>
						
						
							<tr>
								<td>
								<input type = "text" value = "<% out.print(schedule.getString("departureTime").substring(0,10));%>" name = "travelDate" readonly = "readonly">
								</td>
								<td>
								  <input type = "text" value = "<% out.print(schedule.getString("departureTime").substring(11)); %>" name = "departureTime">
								</td>
								<td>
									<input type = "text" value = "<% out.print(schedule.getString("arrivalTime").substring(11)); %>" name = "arrivalTime">
								</td>
								<td>
								   <input type = "text" value = "<% out.print(schedule.getInt("currentStop"));%>" name = "currentStop" readonly="readonly">
								</td>
								<td>
									<input type = "text" value = "<%  out.print(schedule.getInt("nextStop")); %>" name = "nextStop" readonly = "readonly">
								</td>
								<td>
								   <input type = "text" value = "<%  out.print(schedule.getString("transitLine")); %>" name = "transitLine" readonly = "readonly">
								</td>
								<td>
								   <input type = "text" value = "<%  out.print(schedule.getString("trainID")); %>" name = "trainID" readonly = "readonly">
								</td>
								
							</tr>
					
						</table>
						<input type = "submit" name = "Submit" value = "Submit Edits">
				
						</form>
						
						
					<% 		
				
				}
					
					
			
				con.close();
			
			
		}catch(Exception ex) {
			out.print(ex);
			out.println("insert failed");
		}
		
			
		%>
		<br>
			<a href="loginQuery.jsp?username=<%out.print(username);%>&password=<%out.print(password);%>">
						<input type = "submit" name = "Home" value = "Home"> </a>
		<br>
			<form method="get" action="logout.jsp">
				<input type="submit" value="Logout">
			</form>
		<br>

</body>
</html>