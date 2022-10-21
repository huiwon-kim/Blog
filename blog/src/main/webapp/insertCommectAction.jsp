<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%

	if(session.getAttribute("loginId") == null) {
 		response.sendRedirect("./boardOne.jsp"); // 로긴 안하면 댓글 입력 못행 		
 		return;
 	} 


	///////////////// 템플릿 -----------------------------------
	request.setCharacterEncoding("utf-8");


	// 1) 디비 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("db로딩!");
	
	
	// 2) 접속
	String url ="jdbc:mariadb://15.164.0.180/blog";
	String dbuser="root";
	String dbpw="xlavmf1012!";
	Connection	conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	
	
	////////////////////// comment -----------------------------------
		
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String commentContent = request.getParameter("commentContent");
	String id = (String)session.getAttribute("loginId");
	String commentpw = request.getParameter("commentPw");
	
	/*
	INSERT INTO 
	comment 
		(comment_no, 
			board_no, 
			comment_content, 
			create_date, 
			id) 
	VALUES (?, ?, ?, NOW(), ?)
	*/
	
	
	String commentCrSql = "INSERT INTO comment ( board_no, comment_content, create_date, id, comment_pw) VALUES ( ?, ?, NOW(), ?,?)";
	PreparedStatement commentCrstmt = conn.prepareStatement(commentCrSql);

	commentCrstmt.setInt(1, boardNo);
	commentCrstmt.setString(2, commentContent);
	commentCrstmt.setString(3, id);
	commentCrstmt.setString(4, commentpw);
	
	commentCrstmt.executeUpdate();	
	response.sendRedirect("./boardOne.jsp?boardNo="+boardNo);
	

%>