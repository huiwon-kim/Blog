<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>
<%

	if(session.getAttribute("loginId") == null) {
		response.sendRedirect("./boardOne.jsp"); // 로긴 안하면 댓글 입력 못행 		
		return;
	} 

	if((Integer)session.getAttribute("loginLevel") <1) {
		response.sendRedirect("./boardList.jsp"); // 글목록으로 강제 ㄱ	
		return;
	}

	
	request.setCharacterEncoding("UTF-8");
	
	
	String diaryDate = request.getParameter("diaryDate");
	String diaryTodo = request.getParameter("diaryTodo");
	int diaryNo = Integer.parseInt(request.getParameter("diaryNo"));

	System.out.println(diaryDate +"<--diaryDate");
	System.out.println(diaryTodo +"<--diryTodo");

	
	
	// 1) 디비 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("db로딩!");		
	
	// 2) 접속
	String url ="jdbc:mariadb://15.164.0.180/blog";
	String dbuser="root";
	String dbpw="xlavmf1012!";
	Connection	conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	
	// 일정 수정 -----------------------------------------------
	/*
	UPDATE comment set
	diary_date=?
	diary_todo=?
	WHERE diary_no=?
	*/
	
	String diaryupsql ="UPDATE diary SET diary_date=?, diary_todo=? WHERE diary_no=?";
	PreparedStatement stmt = conn.prepareStatement(diaryupsql);
	stmt.setString(1, diaryDate);
	stmt.setString(2, diaryTodo);
	stmt.setInt(3, diaryNo);
	
	System.out.println(stmt +"<--stmt");
	
	int row = stmt.executeUpdate();
 	System.out.println(row +"<-row"); 
 	
 	if(row == 0) { // 수정실패
 		response.sendRedirect("./updateDiary.jsp?diaryNo="+diaryNo);
 	} else { // 수정성공 		
 		response.sendRedirect("./diaryOne.jsp?diaryNo="+diaryNo);
 	}
	
 
%>