<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.*"%>

<%
		if(session.getAttribute("loginId")==null) {
			response.sendRedirect("./index.jsp"); // 완전 처음 인덱스로 ㄱ
			return;
		}
		
		
		// 위에서 로그인 성공햇지만 레벨값이 1보다 작으면 (어드민=관리자가 아니면)
		if((Integer)session.getAttribute("loginLevel") <1) {
			response.sendRedirect("./boardList.jsp"); // 글목록으로 강제 ㄱ	
			return;
		}
		
		
		
		request.setCharacterEncoding("UTF-8");
 		
		//////////////// 이전 db받아오기
		int boardNo = Integer.parseInt(request.getParameter("boardNo"));
		String boardTitle= request.getParameter("boardTitle");
		String boardContent= request.getParameter("boardContent");
		String boardPw= request.getParameter("BoardPw");
		
		
		////// 디버깅
		System.out.println(boardNo +"<--boardNo");
		System.out.println(boardTitle +"<--boardTitle");
		System.out.println(boardContent +"<--boardContent");
		System.out.println(boardPw +"<--boardPw");
		
		
		//////////////// 템플릿

		// 1) 디비 로딩
		Class.forName("org.mariadb.jdbc.Driver");
		System.out.println("db로딩!");		
		
		// 2) 접속
		String url ="jdbc:mariadb://15.164.0.180/blog";
		String dbuser="root";
		String dbpw="xlavmf1012!";
		Connection	conn = DriverManager.getConnection(url, dbuser, dbpw);
				

		String locationNo = request.getParameter("locationNo");
		System.out.println(locationNo +"<-locationNo"); 
		
		// 메뉴 목록
		String locationSql = "SELECT location_no locationNo, location_name locationName FROM location"; //알리언스래 
		PreparedStatement locationStmt = conn.prepareStatement(locationSql);
		ResultSet locationRs = locationStmt.executeQuery();
		
		
		
		///////////////// 글수정
		String updateSql = "UPDATE board set board_title=?, board_content=? where board_no=? and board_pw=PASSWORD(?)";
		PreparedStatement updateStmt = conn.prepareStatement(updateSql);
		updateStmt.setString(1, boardTitle);
		updateStmt.setString(2, boardContent);
		updateStmt.setInt(3, boardNo);
		updateStmt.setString(4,boardPw);
		System.out.println(updateStmt +"<--updateStmt");
		
	 	int row = updateStmt.executeUpdate();
	 	
	 	System.out.println(row +"<-row"); 
	 	
	 	if(row == 0) { // 수정실패
	 		response.sendRedirect("./updateBoardForm.jsp?boardNo="+boardNo);
	 	} else { // 수정성공 		
	 		response.sendRedirect("./boardOne.jsp?boardNo="+boardNo);
	 	}
		
%>
				
