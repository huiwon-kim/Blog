<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.*"%>

<%
 // https://beaniejoy.tistory.com/25  >>> 이 티스토리 참고



		// 1) 디비 로딩
		Class.forName("org.mariadb.jdbc.Driver");
		System.out.println("db로딩!");
		
		
		// 2) 접속
		String url ="jdbc:mariadb://15.164.0.180/blog";
		String dbuser="root";
		String dbpw="xlavmf1012!";
		Connection	conn = DriverManager.getConnection(url, dbuser, dbpw);
				


		String locationNo = request.getParameter("locationNo"); // ★★★★★ 
		System.out.println(locationNo +"<-locationNo"); 
					//	└같은 페이지지만 로케이션 넘버가변경중, 디버깅
		
					
		// 0) 변수 받기			
		String word = request.getParameter("word");
		System.out.println(word+"<--word");// 디버깅
					
					
		int currentPage=1;
		if(request.getParameter("currentPage")!=null) {
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
			// 여기서 null을 여기서
		}
			
		final int ROW_PER_PAGE = 10;
		int beginRow=(currentPage -1) * ROW_PER_PAGE;
		
		
		int totalRow = 0;
		
		//		count(*) cnt 써도 ㅇㅋ							
		PreparedStatement stmt2 = conn.prepareStatement("select count(*) from board"); 
						//└이게 컬럼명이래	
		ResultSet rs2 = stmt2.executeQuery();														
		//	┌rs2가 있다면 마리아db에서 행을 내려갈 수 있다.
		if(rs2.next()){
		totalRow = rs2.getInt("count(*)");	// rs2.getInt(1); 이라고 해도되나봐	
		}														
					
						
		int lastPage = totalRow / ROW_PER_PAGE;
		//>>> 나머지 값이 없읕 때는 나누면 되는데 나머지값 있으면 +1해줘야 함
		// 500/10이면 50페이지면 끝. 501/10이면 51페이지여야
		
		if(totalRow % ROW_PER_PAGE !=0) {
		lastPage +=1;
		}
		
				

		
		// 메뉴 목록
		String locationSql = "SELECT location_no locationNo, location_name locationName FROM location"; //알리언스래 
		PreparedStatement locationStmt = conn.prepareStatement(locationSql);
		ResultSet locationRs = locationStmt.executeQuery();
		

		
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

	  	<!--  메인  -->
	  	<!--  이부분만 계속 유지보수할거래  -->
	  	<%
			// 게시글 목록 >>> locationNo가 null이냐(다들고옴) 아니냐(해당넘버만 들고옴)
			
			String boardSql =""; 
			PreparedStatement boardStmt = null;
			if (locationNo == null ){ // null이면 웨어절이 없어 널이 아니면 뭔가 추가야
				
				/*
						SELECT board_no boardNo, board_title boardTitle 
						FROM board 
						WHERE location no = ?
						ORDER BY board_no DESC";	
						└>>> 위에꺼를 이렇게 아래로 다시 또 쪼갤거야 >>> 조인하는게 반정규하 역정규화
						cf. 막 비슷하게 묶는건 정규화라고 볼 수 있음
			
						SELECT
							l.location_name locationName,
							b.location_no locationNo, 
							b.board_no boardNo, 
							b.board_title boardTitle 
						FROM location l INNER JOIN board b
						ON l.location_no = b.location_no
						ORDER BY board_no DESC
						LIMIT ?, ?;	
				*/
				
				
				boardSql ="SELECT l.location_name locationName, b.location_no locationNo, b.board_no boardNo, b.board_title boardTitle FROM location l INNER JOIN board b ON l.location_no = b.location_no ORDER BY board_no DESC LIMIT ?, ?";	
				boardStmt = conn.prepareStatement(boardSql);
				boardStmt.setInt(1, beginRow);
				boardStmt.setInt(2, ROW_PER_PAGE);
				
			}else {
				
				/*
						SELECT
							l.location_name locationName,
							b.location_no locationNo, 
							b.board_no boardNo, 
							b.board_title boardTitle 
						FROM location l INNER JOIN board b
						ON l.location_no = b.location_no
						WHERE l.location_no=?
						ORDER BY board_no DESC
						LIMIT ?, ?;					
				
				*/
				
				boardSql = "SELECT l.location_name locationName, b.location_no locationNo, b.board_no boardNo, b.board_title boardTitle FROM location l INNER JOIN board b ON l.location_no = b.location_no WHERE b.location_no=? ORDER BY board_no DESC LIMIT ?, ?";
	
				boardStmt = conn.prepareStatement(boardSql);
				boardStmt.setInt(1, Integer.parseInt(locationNo)); // 로케이션노가 스트링이라서		
				boardStmt.setInt(2, beginRow);
				boardStmt.setInt(3, ROW_PER_PAGE);
				
			}
			
			ResultSet boardRs = boardStmt.executeQuery();
		%>
		
		
		<%													
			if(session.getAttribute("loginLevel") != null // ┌오브젝트라 >0이라고 하면 안됨 인티저 팔스인트로 바꿔야함 (오토언박싱)
				&& (Integer)(session.getAttribute("loginLevel"))>0 )	{	
		%>
			
			<div>
				<a href="./insertBoard.jsp"> 글입력 </a> <!-- 이게 로그인이 되었을 때만 나와야 함  이렇게 이프문 안에 넣었다면 글입력 숨겨짇지-->
			</div>
					
		<%		
			}
		%>
		
	
		
	  	
	  	<table class="table table-boardless">
			    <thead class="table-light">
				<tr>
					<th> locationName </th>
					<th> boardNo </th>
					<th> boardTitle </th>
				</tr>
				</thead>
				<tbody>
					<%
						while(boardRs.next()){
					%>
							<tr>
								<td><%=boardRs.getString("locationName")%></td>
								<td><%=boardRs.getInt("boardNo")%></td>
								
								<td>
									<a href="./boardOne.jsp?boardNo=<%=boardRs.getInt("boardNo") %>" class="text-decoration-none">								
										<%=boardRs.getString("boardTitle")%>	
									</a>
								</td>	
										
							</tr>
					<%
						}
					%>
			</tbody>
		</table>
		
		
		<div>
		<form class="form-inline" action="./boardList.jsp"> <!-- ★★★★★  -->
              	<%
              		if(locationNo != null) { //★★★★★  
              	%>
              		<input type="hidden" name="locationNo" value="<%=locationNo%>"><!--  넘버도 같이 넘어가야 >> hiden넘버 -->              	              			
              	<%	
              		}            	
              	
              	%>              
              
               <label> 제목 </label>
               <input type="text" class="form-control" name="word"> 
               <button type="submit" class="btn btn-primary"> 검색 </button>
            </form>
		
      	</div>
      	
		
		<!-- 검색은 안다루어주시니가 다들 올린거 참고하래 -->
		<!--  페이징 -->
		<div>
		<ul class="pagination pagination-sm">
		
						
				<%
					if(locationNo == null){
						if( currentPage >1 ) {
				%>			
						<li class="page-item"><a class="page-link" href="./boardList.jsp?&currentPage=<%=currentPage-1%>"> 이전 </a></li>
							<!--  null 이기 때문에 뒤에 locationNo를 넘기지 않아 -->	
				<%			
							}
						} else {
							if( currentPage>1 )	{ // null 이 아니면서 1페이지가 아닌
				%>
						<li class="page-item"><a class="page-link" href="./boardList.jsp?&currentPage=<%=currentPage-1%>&locationNo=<%=locationNo%>"> 이전 </a></
				<%	
				
						}			
					}
					
				%>
				
				
				<% 
				
					if( lastPage>currentPage ) {
				%>
						
						
					<%
						if (locationNo == null) {
							
					%>
						<li class="page-item"><a class="page-link" href="./boardList.jsp?&currentPage=<%=currentPage+1%>"> 다음 </a></li>
					
					<%		
						} else {
					%>
						<li class="page-item"><a class="page-link" href="./boardList.jsp?&currentPage=<%=currentPage+1%>&locationNo=<%=locationNo%>"> 다음 </a></li>
				
					<%		
						}
					%>
					
				<% 
					}
				%>
		
		</ul>
		</div>	
	  </div><!--  end main -->
	</div>	
</div>
<div class="mt-5 p-4 bg-dark text-white text-center">
  <p>ⓒ 2022. 김희원 all rights reserved. (C) 2022. 김희원 all rights reserved</p>
</div>
</body>
</html>

<%
boardStmt.close();
locationRs.close();
rs2.close();
stmt2.close();
conn.close();
%>
