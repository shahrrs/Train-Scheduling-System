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

	<h3> Edit/Delete Schedule </h3>
	  <form method = "post"> 
	  <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	  <link rel="stylesheet" href="/resources/demos/style.css">
	  <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
	  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	  <script>
		  $( function() {
		    $( "#datepicker" ).datepicker();
		  } );
  	  </script>
  
  
  <p>Date: <input type="text" name = "scheduleDate" id="datepicker">
   		   <input type="submit" value="Search"></p>
  		</form>
	<%	
	
		Logger logger=Logger.getLogger(this.getClass().getName());
		String username = (String) session.getAttribute("username");
		String password = (String) session.getAttribute("password");
		int userType = (Integer) session.getAttribute("userType");
		
		try{
			
			if (request.getParameter("scheduleDate")==null) {
				out.print("Pick a date.");
			}
			
			else {
			
				ApplicationDB db = new ApplicationDB();	
				Connection con = db.getConnection();
				
				//Create a SQL statement
				
			
			
				Statement stmt = con.createStatement();
				String trainID = request.getParameter("trainID");
				String date = request.getParameter("scheduleDate") + " 00:00:00";
				//System.out.println(date);
				
				 
				DateFormat d1 = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
			
				Date stringDate = d1.parse(date);
				Calendar c = Calendar.getInstance(); 
				c.setTime(stringDate); 
				c.add(Calendar.DATE, 1);
				Date dt = c.getTime();
				
				DateFormat d2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				String currentDate = d2.format(stringDate);
				String afterDate = d2.format(dt);
				//System.out.println(currentDate);
				//System.out.println(afterDate);
				 
				
				
			
				
					
				%>
				
				<% 
			
					PreparedStatement query1 = con.prepareStatement("SELECT * FROM Schedule WHERE trainID = ? AND departureTime >= ?  AND departureTime < ? ");
					query1.setString(1, trainID);
					query1.setString(2, currentDate);
					query1.setString(3, afterDate);
					
					ResultSet schedule = query1.executeQuery();
	
					
					if (!schedule.next()) {
						out.print("No schedules available for this train on this date.");
					}
					
					else {
						%>
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
						
						<% 
						do{ 
							//String name2 = result.getString("name");%>
							
						
							<tr>
								<td>
								<% out.print(schedule.getString("departureTime").substring(0,10)); %>
								</td>
								<td>
								  <% out.print(schedule.getString("departureTime").substring(11)); %>
								</td>
								<td>
								  <% out.print(schedule.getString("arrivalTime").substring(11)); %>
								</td>
								<td>
								   <% out.print(schedule.getString("currentStop")); %>
								</td>
								<td>
									<%  out.print(schedule.getString("nextStop")); %>
								</td>
								<td>
								   <% out.print(schedule.getString("transitLine")); %>
								</td>
								<td>
								   <% out.print(schedule.getString("trainID")); %>
								</td>
								<td>	
									<a href="editSchedule.jsp?trainID=<%out.print(trainID); %>&departureTime=<%out.print(schedule.getString("departureTime"));%>
									&arrivalTime=<%out.print(schedule.getString("arrivalTime"));%>&currentDate=<%out.print(currentDate);%>
									&nextDate=<%out.print(afterDate);%>">
									<input type = "submit" name = "Edit" value = "Edit Times"> </a>
								</td>
								
					
			
							</tr>
					
						<%
							
							}while(schedule.next());
						%>
						</table>
						<a href="deleteSchedule.jsp?trainID=<%out.print(trainID);%>&departureTime=<%out.print(currentDate);%>&nextDate=<%out.print(afterDate);%>
						&userType=<%out.print(userType);%>">
						<input type = "submit" name = "Delete" value = "Delete Today's Schedule"> </a>
						
						
						<% 
					}
				
				
				
				
				con.close();
			
			}
		}catch(Exception ex) {
			out.print(ex);
			out.print("insert failed");
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