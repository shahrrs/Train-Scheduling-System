<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.sql.Timestamp, java.time.*, java.util.Calendar, java.util.Date, java.text.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@page import="java.util.logging.Logger" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Customers</title>
</head>
<body>
	
	<% 
		String username = (String) session.getAttribute("username");
		String password = (String) session.getAttribute("password");
		int userType = (Integer) session.getAttribute("userType");%>
	
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
		
		<input type="text" name = "reserveDate" id="datepicker">
		<label for="transitLine">Transit Line:</label>
		<input type="text" name="transitLine">
      	<input type="submit" value="Search">
      
  	</form>
	<%	
    
     try{
    	Logger logger=Logger.getLogger(this.getClass().getName());
     	String reserveDate = request.getParameter("reserveDate") + " 00:00:00";
     	String transitLine = request.getParameter("transitLine");
     	if(reserveDate == null || transitLine == null || reserveDate.equals("") || transitLine.equals("")){
    	 	out.print("Input reservation date and transit line.");
     	}else{
     		%>
     		<p>Customers with reservations on <b> <%out.print(request.getParameter("reserveDate")); %></b> with <b> <%out.print(transitLine); %></b></p>
     		<%
     	
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			
			//Create a SQL statement
			Statement stmt1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			Statement stmt2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			
			//Date formatting
			
			
		//String query1 = "select * from Reservation r where LOWER(r.transitLine) LIKE LOWER('" + transitLine + "') and departureTime = '" + resDate + "'";
			DateFormat d1 = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		
			Date stringDate = d1.parse(reserveDate);
			Calendar c = Calendar.getInstance(); 
			c.setTime(stringDate); 
			c.add(Calendar.DATE, 1);
			Date dt = c.getTime();
		
			DateFormat d2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String currentDate = d2.format(stringDate);
			String afterDate = d2.format(dt);
			
			String query1 = "select *  from Reservation r where LOWER(r.transitLine) LIKE LOWER('" + transitLine + "') AND departureTime >= '" + currentDate + "' AND departureTime < '" + afterDate + "'";
			ResultSet result = stmt1.executeQuery(query1);
			if(!result.next()){
				%> 
				<p>No Customers.</p>
				<% 
			}else{
				%>
				<table style="width:100%; text-align:left">
				<tr>
					<th>Name</th>
					<th>Username</th>
					<th>Email</th>
				</tr>
				<% 
				do{
					String query2 = "select * from User where username = '" + result.getString("username") + "'";
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
						<% out.print(result.getString("username")); %>
					</td>
					<td>
						<% out.print(email); %>
					</td>
					
				</tr>
				
				<%
				}while(result.next());
			}
			con.close();
			
			
     	}
     	
     }catch(Exception ex) {
			out.print(ex);
			out.print("failed");
	 }
     %>
	
		</table>
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