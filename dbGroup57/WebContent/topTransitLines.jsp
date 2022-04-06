<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@page import="java.util.logging.Logger" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Most Active Transit Lines</title>
</head>
<body>
	<h3>Most Active Transit Lines</h3>
	
	<%
	String username = (String) session.getAttribute("username");
	String password = (String) session.getAttribute("password");
	int userType = (Integer) session.getAttribute("userType");
	Logger logger=Logger.getLogger(this.getClass().getName());
	
	try{
	
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		Statement stmt = con.createStatement();
		Statement stmt2 = con.createStatement();
		
		String query3 = "SELECT DISTINCT DATE_FORMAT(reservationDate, '%m') AS Months FROM Reservation ORDER BY Months;";
		ResultSet months = stmt2.executeQuery(query3);

		String month = request.getParameter("months");
		String year = request.getParameter("years");
		String temp = "";
		%>
		<form method="get">
		<label for="months">Month:</label>
		<select name="months" id="months">
			<option selected disabled>Choose month</option>
			<%
			while(months.next()){
				String m = months.getString("Months");
				
				if(m.equals("01")){
					temp = "January";
				}else if(m.equals("02")){
					temp = "February";
				}else if(m.equals("03")){
					temp = "March";
				}else if(m.equals("04")){
					temp = "April";
				}else if(m.equals("05")){
					temp = "May";
				}else if(m.equals("06")){
					temp = "June";
				}else if(m.equals("07")){
					temp = "July";
				}else if(m.equals("08")){
					temp = "August";
				}else if(m.equals("09")){
					temp = "September";
				}else if(m.equals("10")){
					temp = "October";
				}else if(m.equals("11")){
					temp = "November";
				}else if(m.equals("12")){
					temp = "December";
				}
				%>
				<option value="<%out.print(m);%>"> <% out.print(temp);%></option>
				<%
			}
			%>
		</select>
		<label for="years">Year:</label>
		<select name="years" id="years">
			<option selected disabled>Choose year</option>
			<%
			String query2 = "SELECT DISTINCT DATE_FORMAT(reservationDate, '%Y') AS Years FROM Reservation ORDER BY Years;";
			ResultSet years = stmt2.executeQuery(query2);
			while(years.next()){
				%>
				<option value="<%out.print(years.getString("Years"));%>"> <% out.print(years.getString("Years"));%></option>
				<% 
			}
			%>
		</select>
		<input type="submit" value="Search">
		</form>
		
		<%
		
		if(month==null || year==null){
			String query1 = "SELECT transitLine, count(*) count FROM Reservation WHERE YEAR(reservationDate) = YEAR(CURRENT_DATE()) AND MONTH(reservationDate) = MONTH(CURRENT_DATE()) GROUP BY transitLine ORDER BY count DESC;";
			ResultSet transit = stmt.executeQuery(query1);
			if(transit.next()){
				%>
				<br>
				<b>Current Month</b>
				<table>
				<tr>
					<th></th>
					<th>Transit Line</th>
					<th># Reservations</th>
				</tr>
				<%
				for(int i=0; i < 5; i++){
					if(!(transit.getString("transitLine").isEmpty())){
					 %>
					 <tr>
					 	<td><%out.print((i+1)+".");%></td>
					 	<td><%out.print(transit.getString("transitLine"));%></td>
					 	<td><%out.print(transit.getInt("count"));%></td>
					 </tr>
					 <%
					 if(transit.isLast()){
						 break;
					 }else{
						 transit.next();
					 }
					}else{
						break;
					}
					
				}
				%>
				</table>
			<br>
			<a href="loginQuery.jsp?username=<%out.print(username);%>&password=<%out.print(password);%>">
			<input type = "submit" name = "Home" value = "Home"> </a>
			<form method="get" action="logout.jsp">
			<input type="submit" value="Logout">
			</form>
				<%
			}else{
				%>
				<br>
				<b>Current Month</b>
				<h4>No transit lines have reservations associated with them...</h4>
			<br>
			<a href="loginQuery.jsp?username=<%out.print(username);%>&password=<%out.print(password);%>">
			<input type = "submit" name = "Home" value = "Home"> </a>
			<form method="get" action="logout.jsp">
			<input type="submit" value="Logout">
			</form>
				<%
			}
		}else{
			String query1 = "SELECT transitLine, count(*) count FROM Reservation WHERE YEAR(reservationDate) = '"+ year +"' AND MONTH(reservationDate) = '"+ month +"' GROUP BY transitLine ORDER BY count DESC;";
			ResultSet transit = stmt.executeQuery(query1);
			if(transit.next()){
				
				String m = month;
				
				if(m.equals("01")){
					temp = "January";
				}else if(m.equals("02")){
					temp = "February";
				}else if(m.equals("03")){
					temp = "March";
				}else if(m.equals("04")){
					temp = "April";
				}else if(m.equals("05")){
					temp = "May";
				}else if(m.equals("06")){
					temp = "June";
				}else if(m.equals("07")){
					temp = "July";
				}else if(m.equals("08")){
					temp = "August";
				}else if(m.equals("09")){
					temp = "September";
				}else if(m.equals("10")){
					temp = "October";
				}else if(m.equals("11")){
					temp = "November";
				}else if(m.equals("12")){
					temp = "December";
				}
				
				%>
				<br>
				<b><%out.print(temp); %> <%out.print(year); %></b>
				<table>
				<tr>
					<th></th>
					<th>Transit Line</th>
					<th># Reservations</th>
				</tr>
				<%
				for(int i=0; i < 5; i++){
					if(!(transit.getString("transitLine").isEmpty())){
					 %>
					 <tr>
					 	<td><%out.print((i+1)+".");%></td>
					 	<td><%out.print(transit.getString("transitLine"));%></td>
					 	<td><%out.print(transit.getInt("count"));%></td>
					 </tr>
					 <%
					 if(transit.isLast()){
						 break;
					 }else{
						 transit.next();
					 }
					}else{
						break;
					}
					
				}
				%>
				</table>
			<br>
			<a href="loginQuery.jsp?username=<%out.print(username);%>&password=<%out.print(password);%>">
			<input type = "submit" name = "Home" value = "Home"> </a>
			<form method="get" action="logout.jsp">
			<input type="submit" value="Logout">
			</form>
				<%
			}else{
				%>
				<h4>No transit lines have reservations associated with them...</h4>
			<br>
			<a href="loginQuery.jsp?username=<%out.print(username);%>&password=<%out.print(password);%>">
			<input type = "submit" name = "Home" value = "Home"> </a>
			<form method="get" action="logout.jsp">
			<input type="submit" value="Logout">
			</form>
				<%
			}
		}
		
		
		
		
		con.close();
	}catch(Exception ex) {
		out.print(ex);
	}
	%>


</body>
</html>