<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.sql.Timestamp, java.time.*, java.util.Calendar, java.util.Date, java.text.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@page import="java.util.logging.Logger" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Search Train Schedules</title>
</head>
<body>
<h3>Search Train Schedules</h3>
	<form action="">
		<label for="start">Date:</label>
		<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	  	<link rel="stylesheet" href="/resources/demos/style.css">
	 	<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
	  	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	  	<script>
		  	$( function() {
		    	$( "#datepicker" ).datepicker();
		  	} );
  	  	</script>
  	  	<input type="text" name = "scheduleDate" id="datepicker">
		<label for="origin">Origin:</label>
		<input type="text" name="origin">
		<label for="destination">Destination:</label>
		<input type="text" name="destination">
      	
      	<label for="sort">Sort By:</label>
      	<select name="sortBy" id="sortBy">
			<option value="Departure Time">Departure Time</option>
			<option value="Arrival Time">Arrival Time</option>
		</select>
		<input type="submit" value="Search">
				
	</form>
	<button onclick="sortTable(6)">Lowest Price</button>

	
	
	<%
		String username = (String) session.getAttribute("username");
		String password = (String) session.getAttribute("password");
		int userType = (Integer) session.getAttribute("userType");
		
		try{
			Logger logger=Logger.getLogger(this.getClass().getName());
			String scheduleDate = request.getParameter("scheduleDate");
			
			
	     	String origin = request.getParameter("origin");
	     	String destination = request.getParameter("destination");
	     	
			if(scheduleDate == null || origin == null ||  destination == null || origin.equals("") || scheduleDate.equals("") || destination.equals("")){
	    	 	out.print("Input date, origin, and destination");
	     	}else{
	     		scheduleDate = scheduleDate + " 00:00:00";
	     		DateFormat d1 = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
				Date stringDate = d1.parse(scheduleDate);
				Calendar c = Calendar.getInstance(); 
				c.setTime(stringDate); 
				c.add(Calendar.DATE, 1);
				Date dt = c.getTime();
			
				DateFormat d2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				String currentDate = d2.format(stringDate);
				String afterDate = d2.format(dt);
				
	     		ApplicationDB db = new ApplicationDB();	
				Connection con = db.getConnection();
				
				//Create a SQL statement
				Statement stmt1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
				Statement stmt2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
				Statement stmt3 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
				Statement stmt4 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
				Statement stmt5 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
				Statement stmt6 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
				Statement stmt7 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
				
				//Queries
				String query1= "select * from Station where name = '" + origin + "' and transitLine in (select transitLine from Station where name = '" + destination + "') order by transitLine";
				//logger.info("query1 is" + query1);
				ResultSet stops = stmt1.executeQuery(query1);
				if(!stops.next()){
					%>
					<p>No Schedules Available.</p>
					<% 
				}else{
					stops.beforeFirst();
					while(stops.next()){
						String transitLine = stops.getString("transitLine");
						//logger.info(transitLine);
						String query2 = "select * from Station where name = '" + origin + "' and transitLine = '" + transitLine + "'";
						String query3 = "select * from Station where name = '" + destination + "' and transitLine = '" + transitLine + "'";
						//logger.info(query2);
						//logger.info(query3);
						ResultSet current = stmt2.executeQuery(query2);
						ResultSet next = stmt3.executeQuery(query3);
						int currentStopID = 0;
						int nextStopID = 0;
						String currentName = "";
						String nextName = "";
						String query4 = "";
						String query5 = "";
						current.beforeFirst();
						next.beforeFirst();
						if(current.next() && next.next()){
							currentStopID = current.getInt("stopID");
							nextStopID = next.getInt("stopID");
							currentName = current.getString("name");
							nextName = next.getString("name");
							//logger.info(Integer.toString(currentStopID));
							//logger.info(Integer.toString(nextStopID));
						}
						ResultSet currentStops = null;
						ResultSet nextStops = null;
						String sort="";
						if(request.getParameter("sortBy").equals("Arrival Time")){
							sort = "arrivalTime";
						}else{
							sort = "departureTime";
						}
						
						if(currentStopID > nextStopID){
							query4 = "select * from Schedule where transitLine = '"+ transitLine + "' and currentStop = " + Integer.toString(currentStopID) + " and currentStop > nextStop and departureTime >= '" + currentDate + "' AND departureTime < '" + afterDate + "' order by " + sort;
							currentStops = stmt4.executeQuery(query4);
							if(currentStops.next()){
								String trainID = currentStops.getString("trainID");
								query5 = "select * from Schedule where transitLine = '"+ transitLine + "' and nextStop = " + Integer.toString(nextStopID) + " and currentStop > nextStop and trainID = '" + currentStops.getString("trainID") + "' and departureTime >= '" + currentDate + "' AND departureTime < '" + afterDate + "' order by " + sort;
								nextStops = stmt5.executeQuery(query5);
							}
						}else{
							query4 = "select * from Schedule where transitLine = '"+ transitLine + "' and currentStop = " + Integer.toString(currentStopID) + " and currentStop < nextStop and departureTime >= '" + currentDate + "' AND departureTime < '" + afterDate + "' order by " + sort;
							currentStops = stmt4.executeQuery(query4);
							if(currentStops.next()){
								String trainID = currentStops.getString("trainID");
								query5 = "select * from Schedule where transitLine = '"+ transitLine + "' and nextStop = " + Integer.toString(nextStopID) + " and currentStop < nextStop and trainID = '" + currentStops.getString("trainID") + "' and departureTime >= '" + currentDate + "' AND departureTime < '" + afterDate + "' order by " + sort;
								nextStops = stmt5.executeQuery(query5);
							}
						}
							//logger.info(query4);
							//logger.info(query5);
						currentStops = stmt4.executeQuery(query4);
						
						//nextStops = stmt5.executeQuery(query5);
						if(!query5.equals("")){
							nextStops = stmt5.executeQuery(query5);
						}
						if(!currentStops.next() || !nextStops.next()){
							%>
							<p>No schedules available for transit line <%out.print(transitLine); %> </p>
							<%
						}else{
							%>
							
							<table id="scheduleTable" style="width:100%; text-align:left">
								<tr>
									<th>Depart Time</th>
									<th>Arrival Time</th>
									<th>From</th>
									<th>To</th>
									<th>TransitLine</th>
									<th>Train</th>
									<th>Regular Fare</th>
									<th>Stops</th>
								</tr>
							<%
							//int check = 10;
							currentStops.beforeFirst();
							nextStops.beforeFirst();
							%>
							<br>
							<%
							out.print("For transit line: " + transitLine);
							while(currentStops.next() && nextStops.next()){
								%>
								<tr>
									<td>
										<% out.print(currentStops.getString("departureTime")); %>
									</td>
									<td>
										<% out.print(nextStops.getString("arrivalTime")); %>
									</td>
									<td>
										<% out.print(currentName); %>
									</td>
									<td>
										<% out.print(nextName); %>
									</td>
									<td>
										<% out.print(transitLine); %>
									</td>
									<td>
										<% out.print(currentStops.getString("trainID")); %>
									</td>
									<td>
										<%
										
										String query6 = "select * from TransitLine where name = '" + transitLine + "'";
										ResultSet tLine = stmt6.executeQuery(query6);
										float fare = 0;
										int max = 0;
										if(tLine.next()){
											fare = tLine.getFloat("fixedFare");
										}
										String query7 = "select max(stopID) from Station where transitLine = '" + transitLine + "'";
										ResultSet maxStop = stmt7.executeQuery(query7);
										if(maxStop.next()){
											max = maxStop.getInt("max(stopID)");
										}
										float regFare = (fare/(max-1)) * Math.abs(nextStopID - currentStopID);
										out.print(String.format("%.2f", regFare)); 
										
										//check--;
										//out.print(Integer.toString(check));
										%>
									</td>
									<td>
										<a href="viewStops.jsp?depart=<%out.print(currentStops.getString("departureTime"));%>&origin=<%out.print(currentStopID);%>&destination=<%out.print(nextStopID);%>&transitLine=<%out.print(transitLine);%>&originName=<%out.print(currentName);%>&destName=<%out.print(nextName);%>&arrival=<%out.print(nextStops.getString("arrivalTime"));%>">
										<input type = "submit" name = "View" value = "View"> </a>									
									</td>
									
								</tr>
								
								<%
							}
						}
					}
				}
				
	     	
				
				%>
				
				
				<%
				con.close();
			
			}
			%>
			</table>
			<script>
								function sortTable(n) {
									  var table, rows, switching, i, x, y, shouldSwitch;
									  table = document.getElementById("scheduleTable");
									  switching = true;
									 console.log("in number");
									  /*Make a loop that will continue until
									  no switching has been done:*/
									  while (switching) {
									    //start by saying: no switching is done:
									    switching = false;
									    rows = table.rows;
									    /*Loop through all table rows (except the
									    first, which contains table headers):*/
									    for (i = 1; i < (rows.length - 1); i++) {
									      //start by saying there should be no switching:
									      shouldSwitch = false;
									      /*Get the two elements you want to compare,
									      one from current row and one from the next:*/
									      x = rows[i].getElementsByTagName("TD")[n];
									      y = rows[i + 1].getElementsByTagName("TD")[n];
									      //check if the two rows should switch place:
									      if (Number(x.innerHTML) > Number(y.innerHTML)) {
									        //if so, mark as a switch and break the loop:
									        shouldSwitch = true;
									        break;
									      }
									    }
									    if (shouldSwitch) {
									      /*If a switch has been marked, make the switch
									      and mark that a switch has been done:*/
									      rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
									      switching = true;
									    }
									  }
									}
	
			</script>
			 
			<br>
			<a href="loginQuery.jsp?username=<%out.print(username);%>&password=<%out.print(password);%>">
				<input type = "submit" name = "Home" value = "Home"> </a>
				<form method="get" action="logout.jsp">
				<input type="submit" value="Logout">
				</form>
			<% 
		}catch(Exception ex) {
			out.print(ex);
			out.print("failed");
	 	}
	%>

</body>
</html>