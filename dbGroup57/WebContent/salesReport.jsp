<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@page import="java.util.logging.Logger" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Monthly Sales Report</title>
</head>
<body>
	<h3>Monthly Sales Report</h3>
	
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
		String query2 = "SELECT DISTINCT DATE_FORMAT(reservationDate, '%m') AS Months FROM Reservation ORDER BY Months;";
		ResultSet months = stmt.executeQuery(query2);

		String month = request.getParameter("months");
		String year = request.getParameter("years");
		if(year == null | month ==null){ //get current month sales report
			
			%>
			<form method="get">
			<label for="months">Month:</label>
			<select name="months" id="months">
				<option selected disabled>Choose month</option>
				<%
				while(months.next()){
					String m = months.getString("Months");
					String temp = "";
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
				String query1 = "SELECT DISTINCT DATE_FORMAT(reservationDate, '%Y') AS Years FROM Reservation ORDER BY Years;";
				ResultSet years = stmt.executeQuery(query1);
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
			
			String query3 = "SELECT * FROM Reservation WHERE YEAR(reservationDate) = YEAR(CURRENT_DATE()) AND MONTH(reservationDate) = MONTH(CURRENT_DATE());";
			ResultSet reservations = stmt.executeQuery(query3);
			float total= 0;
			%>
			<br>
			<table>
			<tr>
			<th>Current Month</th>
			</tr>
			<tr>
				<th style="text-align:left">Reservation #</th>
				<th style="text-align:left">Date</th>
				<th style="text-align:left">Total Fare</th>
			</tr>
			<%
			while(reservations.next()){ 
				total+= reservations.getFloat("totalFare");
				%>
				<tr>
					<td>
						<% out.print(reservations.getInt("reservationID")); %>
					</td>
					<td>
						<% out.print(reservations.getString("reservationDate")); %>
					</td>
					<td>
						$<% 
						float fare = reservations.getFloat("totalFare");
						out.print(String.format("%.2f", fare)); 
						%>
					</td>
				</tr>

				
			<%
			
			
			}
			%>
			<tr>
				<td>
				</td>
				<td style="text-align:right">
				<b>Monthly Total</b>
				</td>
				<td>
				$<% out.print(String.format("%.2f", total)); %>
				</td>
			</tr>
			</table>
		<br>
		<a href="loginQuery.jsp?username=<%out.print(username);%>&password=<%out.print(password);%>">
		<input type = "submit" name = "Home" value = "Home"> </a>
		<form method="get" action="logout.jsp">
		<input type="submit" value="Logout">
		</form>
<%
		}else{ //SEARCH FOR MONTH AND YEAR
			%>
			<form method="get">
			<label for="months">Month:</label>
			<select name="months" id="months">
				<option selected disabled>Choose month</option>
				<%
				while(months.next()){
					String m = months.getString("Months");
					String temp = "";
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
				String query1 = "SELECT DISTINCT DATE_FORMAT(reservationDate, '%Y') AS Years FROM Reservation ORDER BY Years;";
				ResultSet years = stmt.executeQuery(query1);
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
			
			String query3 = "SELECT * FROM Reservation WHERE YEAR(reservationDate) = '"+ year +"' AND MONTH(reservationDate) = '"+ month +"';";
			ResultSet reservations = stmt.executeQuery(query3);
			float total= 0;
			
			String temp = "";
			if(month.equals("01")){
				temp = "January";
			}else if(month.equals("02")){
				temp = "February";
			}else if(month.equals("03")){
				temp = "March";
			}else if(month.equals("04")){
				temp = "April";
			}else if(month.equals("05")){
				temp = "May";
			}else if(month.equals("06")){
				temp = "June";
			}else if(month.equals("07")){
				temp = "July";
			}else if(month.equals("08")){
				temp = "August";
			}else if(month.equals("09")){
				temp = "September";
			}else if(month.equals("10")){
				temp = "October";
			}else if(month.equals("11")){
				temp = "November";
			}else if(month.equals("12")){
				temp = "December";
			}
			%>
			<br>
			<table>
			<tr>
			<th><%out.print(temp);%> <%out.print(year);%></th>
			</tr>
			<tr>
				<th style="text-align:left">Reservation #</th>
				<th style="text-align:left">Date</th>
				<th style="text-align:left">Total Fare</th>
			</tr>
			<%
			while(reservations.next()){ 
				total+= reservations.getFloat("totalFare");
				%>
				<tr>
					<td>
						<% out.print(reservations.getInt("reservationID")); %>
					</td>
					<td>
						<% out.print(reservations.getString("reservationDate")); %>
					</td>
					<td>
						$<% 
						float fare = reservations.getFloat("totalFare");
						out.print(String.format("%.2f", fare)); 
						%>
					</td>
				</tr>

				
			<%
			
			
			}
			%>
			<tr>
				<td>
				</td>
				<td style="text-align:right">
				<b>Monthly Total</b>
				</td>
				<td>
				$<% out.print(String.format("%.2f", total)); %>
				</td>
			</tr>
			</table>
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