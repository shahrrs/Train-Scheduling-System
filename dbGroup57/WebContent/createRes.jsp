<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
	<%@page import="java.util.logging.Logger" %>
	<%@page import = "java.text.SimpleDateFormat" %>
<%@page import = "java.util.Date" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Create Reservation</title>
	</head>
<body>

<h3>Create Reservation</h3>
	<form method="get" action="createResPickStart.jsp">
	<table>
	<tr>
	<td>Username</td><td><input type="text" readonly = "readonly" name="username" value = "<%= session.getAttribute("username") %>"></td>
	</tr>
	<tr>
	<td>Trip Type</td> <td> <select name = "tripType">  
									<option value="One-Way">One-Way Trip</option>
								    <option value="Round Trip">Round Trip</option>
								    </select> 
						</td>
	</tr>
	<tr>
	<td>Person Type</td> <td> <select name = "discountType">  
									<option value="Child">Child</option>
								    <option value="Senior">Senior</option>
								    <option value="Disabled">Disabled</option>
								    <option selected = "selected" value="Adult">Adult</option>
								    </select> 
						</td>
	</tr>
	</table>
	<%
	String username = (String) session.getAttribute("username");
	String password = (String) session.getAttribute("password");
	int userType = (Integer) session.getAttribute("userType");
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		//Create a SQL statement
		Statement stmt = con.createStatement();
		SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = new Date(System.currentTimeMillis());
		String reservationDate = formatter.format(date);
		session.setAttribute("resDate", reservationDate);
		//String username = request.getParameter("username");
		//String tripType = request.getParameter("tripType");
		//String personType = request.getParameter("discountType");
		//session.setAttribute("username", username);
		//session.setAttribute("tripType", tripType);
		//session.setAttribute("discountType", personType);
		//String transitline = request.getParameter("transitline");
		//if(transitline == null){ %>
			
			<label for="transitline">Transit Line:</label>
			<select required name="transitline" id="transitline">
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
			<%
		//}
		
		
		
		
		con.close();
		
		
	} catch (Exception ex) {
		out.print(ex);
		out.print("insert failed");
	}
%>
	<input type="submit" value="Next">
	</form>
			<br>
			<a href="loginQuery.jsp?username=<%out.print(username);%>&password=<%out.print(password);%>">
						<input type = "submit" name = "Home" value = "Home"> </a>
		<br>
				<form method="get" action="logout.jsp">
					<input type="submit" value="Logout">
				</form>
		<br>
<br>