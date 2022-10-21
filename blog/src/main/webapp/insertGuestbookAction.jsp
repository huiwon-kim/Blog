<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

    
 <%
 	if(session.getAttribute("loginId") == null) {
 		response.sendRedirect("./index.jsp");
 		
 		return;
 	} 
 
 	request.setCharacterEncoding("utf-8");
 	String guestbookContent = request.getParameter("guestbookContent");
 	
 	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("db로딩!");
	
	
	// 2) 접속
	String url ="jdbc:mariadb://15.164.0.180/blog";
	String dbuser="root";
	String dbpw="xlavmf1012!";;
	Connection	conn = DriverManager.getConnection(url, dbuser, dbpw);
			

	String sql = "insert into guestbook(guestbook_content, id, create_date) VALUES (?,?,now())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, guestbookContent);
	stmt.setString(2, (String)session.getAttribute("loginId"));
			
	stmt.executeUpdate();
	response.sendRedirect("./guestbook.jsp");
 
 %>