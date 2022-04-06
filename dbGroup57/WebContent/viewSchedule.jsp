<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.util.Date"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@page import="java.util.logging.Logger" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Train Schedules</title>
</head>
<body>
	<% 
		String username = (String) session.getAttribute("username");
		String password = (String) session.getAttribute("password");
		int userType = (Integer) session.getAttribute("userType");%>

		<h3>Search By Station</h3>
		<form method="post">
			<input type="text" name="station">
			<select name = "stationType">  
				<option value="Origin">Origin</option>
				<option value="Destination">Destination</option>
			</select> 
			<input type="submit" value="Search">
		</form> 
		<%
		try{
			if(request.getParameter("stationType")==null){
				%>
				<p>No Schedules Available.</p>
				<%
			}else{
				%>
				<p>Searching for:
				<%
				out.print(request.getParameter("station"));
				%></p>
				<%
			Logger logger=Logger.getLogger(this.getClass().getName());
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			
			//Create a SQL statement
			Statement stmt1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			Statement stmt2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			String station = request.getParameter("station");
			logger.info(request.getParameter("stationType"));
			String query1;
			if(request.getParameter("stationType").equals("Origin")){
				query1 = "select * from Schedule s, Station st where s.transitLine=st.TransitLine and st.stopID = s.currentStop and LOWER(st.name) like LOWER('" + station + "')";
			}else{
				query1 = "select * from Schedule s, Station st where s.transitLine=st.TransitLine and st.stopID = s.nextStop and LOWER(st.name) like LOWER('" + station + "')";
			}
			ResultSet result = stmt1.executeQuery(query1);
			
			
			if(!result.next()){
				%> 
				<p>No Schedules Available.</p>
				<% 
			}else{
				%>
				<table style="width:100%; text-align:left">
				<tr>
					<th text-align="left">Depart Time</th>
					<th>Arrival Time</th>
					<th>From</th>
					<th>To</th>
					<th>TransitLine</th>
					<th>Train</th>
				</tr>
				<% 
				String name="";
				do{
					String transitLine = result.getString("transitLine");
					if(request.getParameter("stationType").equals("Origin")){
						String nextStop = Integer.toString(result.getInt("nextStop"));
						String query2 = "select * from Station st where st.transitLine='" + transitLine + "' and st.stopID =" + nextStop;
						ResultSet stations = stmt2.executeQuery(query2);
						stations.beforeFirst();
						if(stations.next()){
							name = stations.getString("name");
							
						}
						%>
						
						<tr>
							<td>
								<% out.print(result.getString("departureTime")); %>
							</td>
							<td>
								<% out.print(result.getString("arrivalTime")); %>
							</td>
							<td>
								<% out.print(result.getString("name")); %>
							</td>
							<td>
								<% out.print(stations.getString("name")); %>
							</td>
							<td>
								<% out.print(transitLine); %>
							</td>
							<td>
								<% out.print(result.getString("trainID")); %>
							</td>
							
						</tr>

			
		
						<%
					}else{
						String prevStop = Integer.toString(result.getInt("currentStop"));
						String query2 = "select * from Station st where st.transitLine='" + transitLine + "' and st.stopID =" + prevStop;
						ResultSet stations = stmt2.executeQuery(query2);
						stations.beforeFirst();
						if(stations.next()){
							name = stations.getString("name");
							
						}
						%>
						
						<tr>
							<td>
								<% out.print(result.getString("departureTime")); %>
							</td>
							<td>
								<% out.print(result.getString("arrivalTime")); %>
							</td>
							<td>
								<% out.print(stations.getString("name")); %>
							</td>
							<td>
								<% out.print(result.getString("name")); %>
							</td>
							<td>
								<% out.print(transitLine); %>
							</td>
							<td>
								<% out.print(result.getString("trainID")); %>
							</td>
							
						</tr>
						<%
					}
				}while(result.next());
			}
			con.close();
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
			<% 
		}catch(Exception ex) {
			out.print(ex);
			out.print("failed");
		}
		%>
		
</body>
</html>