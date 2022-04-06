<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.util.Date"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@page import="java.util.logging.Logger" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Transit Lines</title>
</head>
<body>

	<h3> Pick which transit line schedule you wish to edit. </h3>
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
			%>
			
			<% 
		
	
				String query1 = "SELECT * FROM Train";
				ResultSet result = stmt.executeQuery(query1);
		%>
				<table style="width:100%; text-align:center">
					<tr>
						<th text-align="left">Train</th>
						<th>TransitLine</th>
					</tr>
		<% 	
				while(result.next()){ 
					String trainID = result.getString("trainID");%>
					
					<form method="get" action = "changeSchedule.jsp">
					<tr>
						<td>
							<% out.print(trainID); 
							request.setAttribute("trainID", trainID); %>
						</td>
						<td>
							<% out.print(result.getString("name"));%>
						</td>
						<td>
						<input type="hidden" name="trainID" value="${trainID}">
					    <input type="submit" value="Change Schedule"> 
					    </td>
					</tr>
					</form>

				
			
				<%
				
				}
			%>
					</table>
			<% 
				
			
			con.close();
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