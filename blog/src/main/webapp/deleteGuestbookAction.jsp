<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="java.sql.*" %>    
    
<%
	// 혹시 로긴 안한애가 주소 따서 들어올경우
	if(session.getAttribute("loginId")==null) {
		response.sendRedirect("./index.jsp"); // 완전 처음 인덱스로 ㄱ
		return;
	}


	if(request.getParameter("guestbookNo")==null) {
		response.sendRedirect("./guestbook.jsp");
		return;
		
	}

	// 이제 guest_no랑 그런거 받아온다음
	
	int guestbookNo = Integer.parseInt(request.getParameter("guestbookNo"));
	// 얘는 왜 인트로 받아줌? ... 약간... 뭐 스트링ㅇ읅 인티저로 받는거래 일단 선생님 말은 이래
		
	
	
	

	// 디비 접속할 때
	String url ="jdbc:mariadb://15.164.0.180/blog";
	String dbuser="root";
	String dbpw="xlavmf1012!";
	Connection	conn = DriverManager.getConnection(url, dbuser, dbpw);			
		

			
	/*
	DELETE
	form guestbook
	where guestbook_no=? 
		>>> 어차피 세션에서 아이디 같아야만 삭제 되니까 따로 확인할 필요 x
	*/		
			
	String guestbkdelSql = "DELETE FROM guestbook WHERE guestbook_no=? and id= ?";
	PreparedStatement guestbkdeStmt = conn.prepareStatement(guestbkdelSql);
	guestbkdeStmt.setInt(1, guestbookNo);
	guestbkdeStmt.setString(2,(String)session.getAttribute("loginId"));
	// Object , 다형성, 형변환, Map(콜렉션프레임워크에 있는 ArrrayList, Set, Map[순서는 X, 단 키와 벨류값 有])
	//		로그인 키값을 넣는다면 나중에 겟 어쩌구로 벨류값 가져ㅛ온대
	
	System.out.println( guestbkdelSql + "<-- guestbkdelSql"); // 디버깅
	
	int row = guestbkdeStmt.executeUpdate();
	
	/* 	
	>>. 쌤은 이거 안하시더라
		if(row ==0) { // 삭제 성공!
			System.out.println(guestbkdeStmt + "<-guestbkdeStmt success");
			response.sendRedirect("./guestbook.jsp?guestbookNo="+guestbookNo);
		
		} else { // 삭제 실패!		
			System.out.println(guestbkdeStmt + "<-guestbkdeStmt fail");
			response.sendRedirect("./boardOne.jsp");
		} 
	*/
	
	response.sendRedirect("./guestbook.jsp");
		
%>