<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
	request.setCharacterEncoding("utf-8");
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	
	// 유효성검사	
	if ( id==null || pw==null || id.length()<5 || pw.length()<4) {		
		response.sendRedirect("./insertMember.jsp?errorMsg=error");		
		return;	// return 대신 else 블록 사용해도 좋다
	}
	
	
	
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url ="jdbc:mariadb://15.164.0.180/blog";
	String dbuser="root";
	String dbpw="xlavmf1012!";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 메뉴 목록
	String Sql = "INSERT INTO member(id,pw,level) VALUES(?,PASSWORD(?),0)";
	PreparedStatement stmt = conn.prepareStatement(Sql);
	stmt.setString(1, id);
	stmt.setString(2, pw);
	System.out.println(stmt+"<-- stmt");	
	stmt.executeUpdate();
	
	
	response.sendRedirect("./index.jsp");
	
	stmt.close();
	conn.close();
	
%>