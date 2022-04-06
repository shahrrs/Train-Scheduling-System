<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@page import="java.util.logging.Logger" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Best Customer</title>
</head>
<body>
	<h3>Most Valued Customer</h3>
	
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
		
		if(year==null || month== null){
			String query1 = "SELECT username, SUM(totalFare) total FROM Reservation WHERE YEAR(reservationDate) = YEAR(CURRENT_DATE()) AND MONTH(reservationDate) = MONTH(CURRENT_DATE()) GROUP BY username ORDER BY total DESC;";
			ResultSet customer = stmt.executeQuery(query1);
			if(customer.next()){
				String user = customer.getString("username");
				String query4 = "SELECT firstName,lastName FROM User WHERE username='"+user+"';";
				ResultSet name = stmt2.executeQuery(query4);
				name.next();
				%>
					<br>
					<b>For the current month</b><br><br>
					<b><%out.print(name.getString("firstName")+ " " + name.getString("lastName"));%></b><br>
					<p>Total spent: $<%out.print(String.format("%.2f",customer.getFloat("total"))); %></p>
			<br>
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
				<b>For the current month</b><br>
				<h4>No best customer exists...</h4>
			<br>
			<a href="loginQuery.jsp?username=<%out.print(username);%>&password=<%out.print(password);%>">
			<input type = "submit" name = "Home" value = "Home"> </a>
			<form method="get" action="logout.jsp">
			<input type="submit" value="Logout">
			</form>
				<%
			}
		}else{
			String query1 = "SELECT username, SUM(totalFare) total FROM Reservation WHERE YEAR(reservationDate) = '"+ year +"' AND MONTH(reservationDate) = '"+ month +"' GROUP BY username ORDER BY total DESC;";
			ResultSet customer = stmt.executeQuery(query1);
			if(customer.next()){
				String user = customer.getString("username");
				String query4 = "SELECT firstName,lastName FROM User WHERE username='"+user+"';";
				ResultSet name = stmt2.executeQuery(query4);
				name.next();
				
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
					<b>For <%out.print(temp); %> <%out.print(year); %></b><br><br>
					<b><%out.print(name.getString("firstName")+ " " + name.getString("lastName"));%></b><br>
					<p>Total spent: $<%out.print(String.format("%.2f",customer.getFloat("total"))); %></p>
			<br>
			<br>
			<a href="loginQuery.jsp?username=<%out.print(username);%>&password=<%out.print(password);%>">
			<input type = "submit" name = "Home" value = "Home"> </a>
			<form method="get" action="logout.jsp">
			<input type="submit" value="Logout">
			</form>
				<%
			}else{
				
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
				<b>For <%out.print(temp); %> <%out.print(year); %></b><br><br>
				<h4>No best customer exists...</h4>
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