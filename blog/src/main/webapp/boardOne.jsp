<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%

	// index.jsp 나 loginAction 등에서 로그인 해야 보드원 들어올 수 있게
	if(session.getAttribute("loginId") == null) { // 널이 아니면 들어올 수 없다
		response.sendRedirect("./index.jsp?errorMsg=please do login"); 
		return;
	}


	
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));

	Class.forName("org.mariadb.jdbc.Driver");
	String url ="jdbc:mariadb://15.164.0.180/blog";
	String dbuser="root";
	String dbpw="xlavmf1012!";
	Connection	conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 메뉴 목록 (템플릿)
	String locationSql = "SELECT location_no locationNo, location_name locationName FROM location";
	PreparedStatement locationStmt = conn.prepareStatement(locationSql);
	ResultSet locationRs = locationStmt.executeQuery();
	
	/*
		SELECT 
			l.location_name locationName,  
			b.board_title boardTitle, 
			b.board_content boardContent, 
			b.create_date createDate
		FROM location l INNER JOIN board b
		ON l.location_no = b.location_no
		WHERE b.board_no = ?
	*/
	
	// 글 자세히 보기용
	String boardSql = "SELECT l.location_name locationName,b.board_title boardTitle,b.board_content boardContent,b.create_date createDate FROM location l INNER JOIN board b ON l.location_no = b.location_no WHERE b.board_no = ?";
	PreparedStatement boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1, boardNo);
	ResultSet boardRs = boardStmt.executeQuery();
	// db자원해제
	
	
	
	// comment 부분
	/*
	comment 보여주는 커리(특정 글 상세보기시 코멘트 있다면 보여주는)
	SELECT	
	comment_no commentNo,
	comment_content commentContent,
	id,
	create_date	
	FROM comment 
		
	*/
	

	
	
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <title>Huiwon's First Blog</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
  <style>

  ul{
   list-style:none;
   }
   
	ul.b {
	  list-style-type: square;
	}
   
  </style>
</head>

<body>

<!--  로케이션을 메뉴형태로 보여준다 >> 가져와야지 -->


<div class="p-5 bg-black text-white text-center">
<div class="container p-5 my-5 border"></div>
  <h1> My First Blog </h1>
  <p>gdj50_김희원!</p> 
</div>

<nav class="navbar navbar-expand-sm bg-dark navbar-dark">
  <div class="container-fluid">
    <ul class="navbar-nav">
      <li class="nav-item">
        <a class="nav-link active" href="./boardList.jsp">Home</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="./index.jsp">Index</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="./diary.jsp">Diary</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="./guestbook.jsp">Guest book</a>
      </li>
            <li class="nav-item">
        <a class="nav-link" href="./logout.jsp">Logout</a>
      </li>
    </ul>
  </div>
</nav>


	
	<hr>


<div class="container mt-5">
  <div class="row">
    <div class="col-sm-2">
      <h2>List</h2>
      <hr>
      <div class="fakeimg">
      <img src="./image/sea.jpg" style="width: 10vw; min-width: 100px;"></div>
		<br>
      <ul class="nav nav-pills flex-column">
        <li class="nav-item">
          <a class="nav-link active" href="./boardList.jsp"> All </a>
        </li>
        <%
				 while(locationRs.next()) {
		 %>
				        
        <li class="nav-item">
          <a class="nav-link" href="./boardList.jsp?locationNo=<%=locationRs.getString("locationNo")%>">
				                         <%=locationRs.getString("locationName")%>
			</a>
        </li>
     	<%
								}						
			%>		
       </ul>
      <hr class="d-sm-none">
      </div>
      
    
    <div class="col-sm-10">

			<%
				if(boardRs.next()) {
			%>
					<h1> View post details </h1>
					<br>
					<table class="table table-bordered">
						<tr>
							<td><span style="  font-weight: bold;"> Location Name  </span></td>
							<td><%=boardRs.getString("locationName")%></td>
						</tr>
						<tr>
							<td><span style="  font-weight: bold;"> Board Title  </span></td>
							<td><%=boardRs.getString("boardTitle")%></td>
						</tr>
						<tr>
							<td><span style="  font-weight: bold;"> Board Content  </span></td>
							<td><%=boardRs.getString("boardContent")%></td>
						</tr>
						<tr>
							<td><span style="  font-weight: bold;"> Create Date  </span></td>
							<td><%=boardRs.getString("createDate")%></td>
						</tr>
					</table>
			<%
				}
			
				if((Integer)session.getAttribute("loginLevel") > 0) {			
				// 로긴레벨이 0보다 클 때만 수정삭제만 나와			
			%>
				
					<a href="./updateBoardForm.jsp?boardNo=<%=boardNo%>" class="text-decoration-none">수정</a>
					<a href="./deleteBoardForm.jsp?boardNo=<%=boardNo%>" class="text-decoration-none">삭제</a>
				
			<%
				}			
			%>	
					
					
		 	
		 	
		 	<%
		 	
		 		if(session.getAttribute("loginId") !=null) { // 아이디 로그인 했을 때만 코멘 쓰게
		 	
		 	%>
		 	
		 	<br>
		 	<br>
		 	<hr/>
			<form action="./insertCommectAction.jsp" method="post">	
			
				<h3> Comments </h3>
					<table class="table table-hover">						 												
							<tr>
								
								<td> Comment Content </td>
								<td><textarea rows="5" cols="30" name="commentContent"></textarea></td>			
								<td><input type="hidden" value=<%=boardNo%> name="boardNo"></td>								
								<td> Password </td>
								<td><input type="password" name="commentPw" value="commentPw"></td>
							</tr>									
							  
						</table>	
							<button type="submit" class="btn btn-link" > 댓글입력 </button>
							<button type="reset" class="btn btn-link"> 초기화 </button>
					</form>	
			<%
		 		}
				
			%>	
			
			
			<%
						
			
			
			// 	if(request.getParameter("commentNo") != null) {	
			//	int commentNo = Integer.parseInt(request.getParameter("commentNo"));	
			//} 
			
			String id = (String)session.getAttribute("loginId");
			String commentSql = "SELECT comment_no commentNo, comment_content commentContent, id, create_date FROM comment ORDER BY create_date DESC";
			PreparedStatement commentStmt = conn.prepareStatement(commentSql);
			
			ResultSet commentRs = commentStmt.executeQuery();	
			System.out.println(commentStmt +"<--commentStmt"); // 디버깅
			
			%>
			<br>
			<br>			
			
			<hr/>
			<h3> More Comments </h3>
			
			<%
				while(commentRs.next()) {
			%>
							
					<table class="table table-hover">
						<tr>
						
							<td><input type="hidden" value=<%=boardNo%> name="boardNo"></td>
							<td><%=commentRs.getString("id") %></td> 
							<td><%=commentRs.getString("commentContent") %></td> 							
							<td><%=commentRs.getString("create_date")%></td>
						</tr>
					</table>
			
			
			<%
					String loginId = (String)session.getAttribute("loginId");
					if(loginId !=null && loginId.equals(commentRs.getString("id")))	{
			%>
			
					<a href="./deletecommentForm.jsp?commentNo=<%=commentRs.getInt("commentNo")%>&boardNo=<%=boardNo%>"> 댓글삭제 </a>
				
					
			<%
				}
			}
			
			%>		
					 	
		</div><!-- end main -->
	</div>
</div>
<div class="mt-5 p-4 bg-dark text-white text-center">
  <p>ⓒ 2022. 김희원 all rights reserved. (C) 2022. 김희원 all rights reserved</p>
</div>
</body>
</html> 

<%
boardRs.close();
boardStmt.close();
locationRs.close();
locationStmt.close();
conn.close();
%>


%>
