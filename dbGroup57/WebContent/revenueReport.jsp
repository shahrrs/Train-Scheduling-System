<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@page import="java.util.logging.Logger" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Revenue Report</title>
</head>
<body>
	<h3>Revenue Report</h3>
	
	<%
	//Has drop down menu for month and drop down for years
	String username = (String) session.getAttribute("username");
	String password = (String) session.getAttribute("password");
	int userType = (Integer) session.getAttribute("userType");
	Logger logger=Logger.getLogger(this.getClass().getName());
	try{
	
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		Statement stmt = con.createStatement();
		Statement stmt2 = con.createStatement();

		String transitline = request.getParameter("transitline");
		String customer = request.getParameter("customer");
		String t = request.getParameter("t");
		String c = request.getParameter("c");
		if(transitline == null && customer ==null){ 
			
			%>
			<form method="get">
			<label for="transitline">Transit Line:</label>
			<select name="transitline" id="transitline">
				<option selected disabled >Choose transit line</option>
				<%
				String query1 = "SELECT DISTINCT name AS name FROM TransitLine ORDER BY name;";
				ResultSet names = stmt.executeQuery(query1);
				while(names.next()){
					//System.out.print(names.getString("name"));
					%>
					<option value="<%out.print(names.getString("name"));%>"><%out.print(names.getString("name"));%></option>
					<% 
				}
				%>
			</select>
			<input type="submit" name="t" value="Search Transit Line">
			</form>
			<form>
			<label>Customer Name:</label>
			<input type="text" name="customer">
			<input type="submit" name="c" value="Search Customer">
			</form>
		<br>
		<a href="loginQuery.jsp?username=<%out.print(username);%>&password=<%out.print(password);%>">
		<input type = "submit" name = "Home" value = "Home"> </a>
		<form method="get" action="logout.jsp">
		<input type="submit" value="Logout">
		</form>
			<%
		}else if(t != null){//transit search clicked
			%>
			<form method="get">
			<label for="transitline">Transit Line:</label>
			<select name="transitline" id="transitline">
				<option selected disabled>Choose transit line</option>
				<%
				String query1 = "SELECT DISTINCT name AS name FROM TransitLine ORDER BY name;";
				ResultSet names = stmt.executeQuery(query1);
				while(names.next()){
					//System.out.print(names.getString("name"));
					%>
					<option value="<%out.print(names.getString("name"));%>"><%out.print(names.getString("name"));%></option>
					<% 
				}
				%>
			</select>
			<input type="submit" name="t" value="Search Transit Line">
			</form>
			<form>
			<label>Customer Name:</label>
			<input type="text" name="customer" value="">
			<input type="submit" name="c" value="Search Customer">
			</form>
			<%
			%>
			<br>
			<b>Transit line <%out.print(transitline);%> revenue report</b>
			
			<table>
			<%
			String query2 = "SELECT reservationID,reservationDate,username,totalFare FROM Reservation WHERE transitLine='"+transitline+"';";
			ResultSet transitresult = stmt.executeQuery(query2);
			%>
			<tr>
			<th style="text-align:left">Reservation #</th>
			<th style="text-align:left">Reservation Date</th>
			<th style="text-align:left">Username</th>
			<th style="text-align:left">Fare</th>
			</tr>
			<%
			float total=0;
			while(transitresult.next()){
				total += transitresult.getFloat("totalFare");
			%>
				<tr>
					<td>
						<% out.print(transitresult.getInt("reservationID")); %>
					</td>
					<td>
						<% out.print(transitresult.getString("reservationDate")); %>
					</td>
					<td>
						<% out.print(transitresult.getString("username")); %>
					</td>
					<td>
						$<% 
						float fare = transitresult.getFloat("totalFare");
						out.print(String.format("%.2f", fare)); 
						%>
					</td>
				</tr>
			<%
			}
			%>
			<tr>
				<td></td>
				<td></td>
				<td style="text-align:left"><b>Total Revenue</b></td>
				<td>$<% out.print(String.format("%.2f", total)); %></td>
			</tr>
			</table>
		<br>
		<a href="loginQuery.jsp?username=<%out.print(username);%>&password=<%out.print(password);%>">
		<input type = "submit" name = "Home" value = "Home"> </a>
		<form method="get" action="logout.jsp">
		<input type="submit" value="Logout">
		</form>
			<%
			
			
		}else if(c != null){//customer search is clicked
			%>
			<form method="get">
			<label for="transitline">Transit Line:</label>
			<select name="transitline" id="transitline">
				<option selected disabled>Choose transit line</option>
				<%
				String query1 = "SELECT DISTINCT name AS name FROM TransitLine ORDER BY name;";
				ResultSet names = stmt.executeQuery(query1);
				while(names.next()){
					//System.out.print(names.getString("name"));
					%>
					<option value="<%out.print(names.getString("name"));%>"><%out.print(names.getString("name"));%></option>
					<% 
				}
				%>
			</select>
			<input type="submit" name="t" value="Search Transit Line">
			</form>
			<form>
			<label>Customer Name:</label>
			<input type="text" name="customer" >
			<input type="submit" name="c" value="Search Customer">
			</form>
			<%
			
			String query2 = "SELECT username, SUM(totalFare) total FROM Reservation WHERE username LIKE '"+customer+"%' GROUP BY username;";
			ResultSet users = stmt2.executeQuery(query2);
			%>
			<br>
			<b>Customer revenue report</b>
			<table>
			<tr>
				<th style="text-align:left">Username</th>
				<th style="text-align:left">Total Revenue</th>
			</tr>
			<%
			while(users.next()){
				%>
				<tr>
					<td>
						<% out.print(users.getString("username")); %>
					</td>
					<td>
						$<% 
						float fare = users.getFloat("total");
						out.print(String.format("%.2f", fare)); 
						%>
					</td>
				</tr>
			<%
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
			<form method="get">
			<label for="transitline">Transit Line:</label>
			<select name="transitline" id="transitline">
				<option selected disabled >Choose transit line</option>
				<%
				String query1 = "SELECT DISTINCT name AS name FROM TransitLine ORDER BY name;";
				ResultSet names = stmt.executeQuery(query1);
				while(names.next()){
					//System.out.print(names.getString("name"));
					%>
					<option value="<%out.print(names.getString("name"));%>"><%out.print(names.getString("name"));%></option>
					<% 
				}
				%>
			</select>
			<input type="submit" name="t" value="Search Transit Line">
			</form>
			<form>
			<label>Customer Name:</label>
			<input type="text" name="customer">
			<input type="submit" name="c" value="Search Customer">
			</form>
		<br>
		<a href="loginQuery.jsp?username=<%out.print(username);%>&password=<%out.print(password);%>">
		<input type = "submit" name = "Home" value = "Home"> </a>
		<form method="get" action="logout.jsp">
		<input type="submit" value="Logout">
		</form>
			<%
		}
		con.close();
	}catch(Exception ex) {
		out.print(ex);
	}
	%>


</body>
</html>