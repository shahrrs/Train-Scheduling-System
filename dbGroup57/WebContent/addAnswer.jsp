<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@page import="java.util.logging.Logger" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Questions</title>
</head>
<body>
		<%
		Logger logger=Logger.getLogger(this.getClass().getName());
		
		try{
		
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			
			//Create a SQL statement
			Statement stmt = con.createStatement();
			String answer = request.getParameter("answer");
			
			int questionID = Integer.parseInt(request.getParameter("questionID"));
			String query = "SELECT max(ansID) FROM Answers";
			ResultSet result = stmt.executeQuery(query);
			int id;
			if(!result.next()){
				id = 1;
			}else{
				id = result.getInt("max(ansID)") + 1;
			}
			long millis = System.currentTimeMillis();
			Timestamp date = new java.sql.Timestamp(millis);
			String insert = "INSERT INTO Answers(ansID, answer, responseTime, questionID)"
				+ "VALUES (?, ?, ?, ?)";
			
			PreparedStatement ps = con.prepareStatement(insert);
			ps.setInt(1, id);
			ps.setString(2, answer);
			ps.setTimestamp(3, date);
			ps.setInt(4, questionID);
			ps.executeUpdate();
			response.sendRedirect("employeeQuestion.jsp");
			con.close();
		}catch(Exception ex) {
			out.print(ex);
			out.print("insert failed");
		}
			
		%>
</body>
</html>