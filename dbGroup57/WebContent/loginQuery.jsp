<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@page import="java.util.logging.Logger" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Login</title>
</head>
<body>
	<% Logger logger=Logger.getLogger(this.getClass().getName());
		%>
		
	<%
		List<String> list = new ArrayList<String>();

		try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			
			//Create a SQL statement
			Statement stmt = con.createStatement();
			String username = request.getParameter("username");
			String password = request.getParameter("password");
			String query1 = "SELECT * FROM User WHERE username =  '" + username + "'";
			
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(query1);
			
			
			
			if(!result.next()){
				System.out.println("empty");
				out.print("User Not Found.");
				request.getRequestDispatcher("login.jsp").include(request, response); 
				
			}else{
				if(result.getString("password").equals(password)){
					out.print("You have successfully logged in.");
				    session.setAttribute("username", username);
				    session.setAttribute("password", password);
				    int userType = result.getInt("userType");
				    session.setAttribute("userType", userType);
				    session.setAttribute("password", password);
				    if(userType == 1){
				    	%>
						<br>
							<form method="get" action = "createRes.jsp">
								<input type="submit" value="Create Reservation">
							</form>
							<form method="get" action="searchSchedules.jsp">
								<input type="submit" value="Search Train Schedules">
							</form>
							<form method="get" action = "viewReservationFromUser.jsp">
								<input type="submit" value="View Reservations">
							</form>
							<form method="get" action="customerQuestion.jsp">
								<input type = "submit" value="Questions">
							</form>
						<br>
					
						<% 	
				    }else if (userType == 2){
				    	%>
						<br>
							<form method="get" action="searchSchedules.jsp">
								<input type="submit" value="Search Train Schedules">
							</form>
							<form method="get" action = "showTransitLines.jsp">
								<input type="submit" value="Edit Train Schedules">
							</form>
							<form method="get" action="employeeQuestion.jsp">
								<input type="submit" value="Answer Questions">
							</form>
							<form method="get" action="viewSchedule.jsp">
								<input type="submit" value="View Train Schedules">
							</form>
							<form method="get" action="viewCustomers.jsp">
								<input type="submit" value="View Customers">
							</form>
						<br>
						<%
						
				    }else {
				    	%>
						<br>
							<form method="get" action="searchSchedules.jsp">
								<input type="submit" value="Search Train Schedules">
							</form>
							<form method="get" action="customerReps.jsp">
								<input type="submit" value="Customer Reps">
							</form>
							<form method="get" action="salesReport.jsp">
								<input type="submit" value="Sales Report">
							</form>
							<form method="get" action="viewReservations.jsp">
								<input type="submit" value="Reservations">
							</form>
							<form method="get" action="revenueReport.jsp">
								<input type="submit" value="Revenue">
							</form>
							<form method="get" action="bestCustomer.jsp">
								<input type="submit" value="Best Customer">
							</form>
							<form method="get" action="topTransitLines.jsp">
								<input type="submit" value="Top Active Transit Lines">
							</form>
						<br>
						<%
				    }
				   
				%>
				<br>
					<form method="get" action="logout.jsp">
						<input type="submit" value="Logout">
					</form>
				<br>
				<% 	
				}else{
					out.print("Password is incorrect.");
					request.getRequestDispatcher("login.jsp").include(request, response); 
				}
			}
			
			con.close();

		} catch (Exception e) {
		}
	%>
	

</body>
</html>