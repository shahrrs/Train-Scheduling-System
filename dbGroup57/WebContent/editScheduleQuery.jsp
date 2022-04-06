<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.util.Date, java.text.*, java.sql.Timestamp, java.time.*, java.util.Calendar"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@page import="java.util.logging.Logger" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

</head>
<body>

	  
	<%	
	
		Logger logger=Logger.getLogger(this.getClass().getName());
		
		try{
		
			
				ApplicationDB db = new ApplicationDB();	
				Connection con = db.getConnection();
				
				String departureTime = request.getParameter("travelDate") + " " + request.getParameter("departureTime");
				String arrivalTime = request.getParameter("travelDate") + " " + request.getParameter("arrivalTime");
				
				boolean valid = true; 
				
				if (!request.getParameter("previousArrival").equals("")) {
					String previousArrival = request.getParameter("previousArrival");
					if (Timestamp.valueOf(departureTime).before(Timestamp.valueOf(previousArrival))) {
						out.print("Invalid Schedule: Make sure departure time is after the previous arrival time ("+previousArrival+")");
						valid = false;
					}
				}
				
				if (!request.getParameter("nextDeparture").equals("")) {
					String nextDeparture = request.getParameter("nextDeparture");
					if (Timestamp.valueOf(arrivalTime).after(Timestamp.valueOf(nextDeparture))) {
						out.print("Invalid Schedule: Make sure arrival time is before the next stop's departure time ("+nextDeparture+")");
						valid = false; 
					}
				}
					
				if (Timestamp.valueOf(departureTime).after(Timestamp.valueOf(arrivalTime))){
					out.print("Invalid Schedule: Make sure arrival time is after departure time.");
					valid = false;
					
				}
				
				if (departureTime.equals("") || arrivalTime.equals(""))  {
					out.print("Invalid Schedule: Don't leave time slot blank.");
					valid = false;
				}
				
			   
			
			if (valid == true) {
					String trainID = request.getParameter("trainID");
					System.out.println(trainID);
					int currentStop = Integer.parseInt(request.getParameter("currentStop"));
					int nextStop = Integer.parseInt(request.getParameter("nextStop"));
					String transitLine = request.getParameter("transitLine");
					String originalDeparture = request.getParameter("originalDeparture");
					System.out.println(originalDeparture);
					
					String update = "UPDATE Schedule SET departureTime = ?, arrivalTime = ? WHERE trainID = ? and currentStop = ? and nextStop = ? and transitLine = ? and departureTime = ?";
					PreparedStatement ps = con.prepareStatement(update);
					ps.setString(1,departureTime);
					ps.setString(2,arrivalTime);
					ps.setString(3,trainID);
					ps.setInt(4,currentStop);
					ps.setInt(5,nextStop);
					ps.setString(6,transitLine);
					ps.setString(7,originalDeparture);
					ps.executeUpdate();
					
					out.print("Schedule edited.");
					response.sendRedirect("showTransitLines.jsp");
				
			}
				con.close();
			
			
		}catch(Exception ex) {
			out.print(ex);
			out.println("insert failed");
		}
		
			
		%>
		<br>
			<form method="get" action="logout.jsp">
				<input type="submit" value="Logout">
			</form>
		<br>

</body>
</html>