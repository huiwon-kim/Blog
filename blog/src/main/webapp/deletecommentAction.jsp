<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="java.sql.*" %>    

<%
	if(session.getAttribute("loginId")==null) {
		response.sendRedirect("./index.jsp"); // 완전 처음 인덱스로 ㄱ
		return;
	}
	


	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String commentPw = request.getParameter("commentpw");
	
	
	System.out.print("commentNo : " + commentNo);
	System.out.print("boardNo : " + boardNo);
	
	// 디비 접속
	String url ="jdbc:mariadb://15.164.0.180/blog";
	String dbuser="root";
	String dbpw="xlavmf1012!";
	Connection	conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	
	/*
	DELETE
	from comment
	WHERE comment_no=?
	
	*/
	
	String commentdesql = "DELETE from comment WHERE comment_no=? AND comment_pw=?";
	PreparedStatement commentdestmt = conn.prepareStatement(commentdesql);
	commentdestmt.setInt(1, commentNo);
	commentdestmt.setString(2, commentPw);
	
	commentdestmt.executeUpdate();

	
	System.out.println(commentdestmt +"<-commentdestmt");
	
	response.sendRedirect("./boardOne.jsp?boardNo="+boardNo);
	
%>