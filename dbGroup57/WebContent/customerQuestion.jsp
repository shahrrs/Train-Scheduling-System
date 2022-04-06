<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.util.Date"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@page import="java.util.logging.Logger" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Questions</title>
</head>
<body>

	<h3>Frequently Asked Questions</h3>
	
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
			Search by Keyword
			<form method="get">
				<input type="text" name="keyword">
				<input type="submit" value="Search">
			</form>
			<br>
			<% 
			String keyword = request.getParameter("keyword");
			if(keyword== null){
				String query1 = "SELECT * FROM Questions order by time desc";
				ResultSet result = stmt.executeQuery(query1);
				String id;
				while(result.next()){ %>
					
					<table style="width:100%; text-align:left">
					<tr>
						<td>
							<b>Question: </b><% out.print(result.getString("question")); %>
						</td>
					</tr>
					<tr>
						<td> 
							<b>Responses:</b>
							<% 
							Statement stmt1 = con.createStatement();
							id = Integer.toString(result.getInt("questionID"));
							String query2 = "SELECT * FROM Answers WHERE questionID = " + id;
							ResultSet answers = stmt1.executeQuery(query2);
						
							if(!answers.next()){
							%>
								<p> No responses available. </p>
							<%}else{
								//logger.info(answers.getString("answer"));
								Date date = new Date(answers.getTimestamp("responseTime").getTime());
								
								do{
									%>
									<p> 
									<% 
									out.print(answers.getString("answer"));
									
								}while(answers.next());
								}
							%> </p>
						</td>
					</tr>
					</table>
				<%
				
				}
			}else{
				String query1 = "SELECT * FROM Questions WHERE question like '%" + keyword + "%' order by time desc";
				ResultSet result = stmt.executeQuery(query1);
				String id;
				while(result.next()){ %>
					<table>
					<tr>
						<td>
							<b>Question: </b> <% out.print(result.getString("question")); %>
						</td>
					</tr>
					<tr>
						<td> 
							<b>Responses:</b>
							<% 
							Statement stmt1 = con.createStatement();
							id = Integer.toString(result.getInt("questionID"));
							String query2 = "SELECT * FROM Answers WHERE questionID = " + id;
							ResultSet answers = stmt1.executeQuery(query2);
						
							if(!answers.next()){
							%>
								<p> No responses available.
							<%}else{
								//logger.info(answers.getString("answer"));
								do{
									%>
									<p> 
									<% 
									out.print(answers.getString("answer"));
								
								}while(answers.next());
								}
							%>
						</td>
					</tr>
					</table>
				<%
				
				
				}
			}
			con.close();
		}catch(Exception ex) {
			out.print(ex);
			out.print("insert failed");
		}
			
		%>
		Ask a Question Here
		<form method="post" action="addQuestion.jsp">
			<input type="text" name="question">
			<input type="submit" value="Send">
		</form>
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