<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

 <%@ page import = "java.sql.*"%>
 
 
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
	




	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String boardpw = request.getParameter("pw");
	System.out.println(boardNo +"<--no");
	System.out.println(boardpw +"<--pw");

	
	
	String url ="jdbc:mariadb://15.164.0.180/blog";
	String dbuser="root";
	String dbpw="xlavmf1012!";
	Connection	conn = DriverManager.getConnection(url, dbuser, dbpw);
			

	// delete from board where board_no=? and board_pw=?;
	String deleteSql = "delete from board where board_no=? and board_pw=PASSWORD(?)";	
	PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
	deleteStmt.setInt(1,boardNo);
	deleteStmt.setString(2,boardpw);
	
	System.out.println(deleteStmt +"<-- stmt");
	
	
	int row = deleteStmt.executeUpdate(); // 1이면 삭제 성공, 0 이면 삭제 실패	
	
	if(row == 0) { // 삭제성공시
		response.sendRedirect("./boardOne.jsp?boardNo="+boardNo);
	} else { // 삭제실패시
		response.sendRedirect("./boardList.jsp");
		}
			
 
%>


<%
deleteStmt.close();
conn.close();
%>
