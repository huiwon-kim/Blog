<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>   
<%@ page import = "java.sql.*" %>

<%

	// 애는 insertBoard와 다름. 경우의 수 두개를 합쳣지만 대신 리턴값이 index.jsp로 통일이야
	if(session.getAttribute("loginId")==null || (Integer)session.getAttribute("loginLevel") <1 ) {
		response.sendRedirect("./index.jsp"); // 완전 처음 인덱스로 ㄱ
		return;
	}
	
	
	/*
	// 위에서 로그인 성공햇지만 레벨값이 1보다 작으면 (어드민=관리자가 아니면)
	if((Integer)session.getAttribute("loginLevel") <1) {
		response.sendRedirect("./boardList.jsp"); // 글목록으로 강제 ㄱ	
		return;
	}
	*/	

	
	request.setCharacterEncoding("utf-8");
	int locationNo = Integer.parseInt(request.getParameter("locationNo"));
	String boardTitle =request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardPw = request.getParameter("BoardPw");


	// 1) 디비 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("db로딩!");
	
	
	// 2) 접속
	String url ="jdbc:mariadb://15.164.0.180/blog";
	String dbuser="root";
	String dbpw="xlavmf1012!";
	Connection	conn = DriverManager.getConnection(url, dbuser, dbpw);
			
	
	// 메뉴 목록																											// 이래야 비번 암호화됨
	String sql = "INSERT INTO board(location_no, board_title, board_content, board_pw, create_date) VALUES (?, ?, ?, PASSWORD(?), NOW())"; //알리언스래 
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, locationNo);
	stmt.setString(2, boardTitle);
	stmt.setString(3, boardContent);
	stmt.setString(4, boardPw);
	int row = stmt.executeUpdate();
	
	
	// 쿼리 실행경로가 디버깅 하단 이프엘스가 디버깅
		if (row==1) {
		//System.out.println(stmt.executeUpdate()+"<-- 디버깅");
	} else {
		//
	}
	
	
	// 재요청 >>> 내 일이 다 끝나고 나 집에가게 너가 명령해줘! 이러는게 리다이렉트 (이동 아님)
	response.sendRedirect("./boardList.jsp");
	
%>
