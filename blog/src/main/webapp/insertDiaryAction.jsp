<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
    
<%

	request.setCharacterEncoding("utf-8");

	// 다이어리 기입자체는 관리자 (admin만 가능하게!)
	// 로긴 자체를 안한 애가 수정하려고 하면
	if(session.getAttribute("loginId")==null ) {
		response.sendRedirect("./index.jsp"); // 완전 처음 인덱스로 ㄱ
		return;
	}
	
	
	
	//위에서 로그인 성공햇지만 레벨값이 1보다 작으면 (어드민=관리자가 아니면)
	if((Integer)session.getAttribute("loginLevel") <1) {
		response.sendRedirect("./diary.jsp"); // 다이어리로 강제 ㄱ	
		return;
	}
	

	// 앞에서 또 년월일 받아오기

	
	String diaryTodo = request.getParameter("diaryTodo");
	int y = Integer.parseInt(request.getParameter("y"));
	int m = Integer.parseInt(request.getParameter("m"));
		int d = Integer.parseInt(request.getParameter("d"));
	
	// 인코딩 및 DB

	
	// 1) 디비 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("db로딩!");
	
	
	// 2) 접속
	String url ="jdbc:mariadb://15.164.0.180/blog";
	String dbuser="root";
	String dbpw="xlavmf1012!";
	Connection	conn = DriverManager.getConnection(url, dbuser, dbpw);


	////// 다이어리 스케쥴 업데이트 ------


	/*
		Insert INTO diary
		(diary_no, diary_date, diary_todo, create_date)
		VALUES
		(?, ? , ?, NOW())
		
	*/
	
	String diarysql = "	INSERT INTO diary ( diary_date, diary_todo, create_date) VALUES ( ? , ?, NOW()) ";
	PreparedStatement diarystmt = conn.prepareStatement(diarysql);
	

	diarystmt.setString(1, y+"-"+m+"-"+d);
	diarystmt.setString(2, diaryTodo);	
	diarystmt.executeUpdate();
	
	response.sendRedirect("./diary.jsp");

%>