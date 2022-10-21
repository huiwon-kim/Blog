<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="java.sql.*"%>  

<%   

		// 인코딩
		request.setCharacterEncoding("utf-8");

		if(session.getAttribute("loginId")==null ) {
			response.sendRedirect("./index.jsp"); // 완전 처음 인덱스로 ㄱ
			return;
		}
		
		
		
		//위에서 로그인 성공햇지만 레벨값이 1보다 작으면 (어드민=관리자가 아니면)
		if((Integer)session.getAttribute("loginLevel") <1) {
			response.sendRedirect("./diary.jsp"); // 다이어리로 강제 ㄱ	
			return;
		}



	 	// 1) 디비 로딩
		Class.forName("org.mariadb.jdbc.Driver");
		System.out.println("db로딩!");
		
		
		// 2) 접속
		String url ="jdbc:mariadb://15.164.0.180/blog";
		String dbuser="root";
		String dbpw="xlavmf1012!";
		Connection	conn = DriverManager.getConnection(url, dbuser, dbpw);
				

		// 템플릿용------------------------ 
		String locationNo = request.getParameter("locationNo");
		System.out.println(locationNo +"<-locationNo"); 
					//	└같은 페이지지만 로케이션 넘버가변경중, 디버깅
					
					
		// 메뉴 목록
		String locationSql = "SELECT location_no locationNo, location_name locationName FROM location"; //알리언스래 
		PreparedStatement locationStmt = conn.prepareStatement(locationSql);
		ResultSet locationRs = locationStmt.executeQuery();    
    
    
		// 다이어리용------------------------
		
		/*
		DELETE
		FROM diary
		WHERE diary_no=?
		*/
		
		int diaryNo = Integer.parseInt(request.getParameter("diaryNo"));
		
		String sql = "DELETE FROM diary WHERE diary_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, diaryNo);
		
		stmt.executeUpdate();
		
		System.out.println(stmt +"<-stmt, 다이어리 일정 삭제 완료");
		
		response.sendRedirect("./diary.jsp");
		
		
%>      
