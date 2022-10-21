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
				


		String locationNo = request.getParameter("locationNo");
		System.out.println(locationNo +"<-locationNo"); 
					//	└같은 페이지지만 로케이션 넘버가변경중, 디버깅
		
				
		// 템플릿 -------------------------------
		// 메뉴 목록
		String locationSql = "SELECT location_no locationNo, location_name locationName FROM location"; //알리언스래 
		PreparedStatement locationStmt = conn.prepareStatement(locationSql);
		ResultSet locationRs = locationStmt.executeQuery();
		

		
		String guestbookNo = request.getParameter("guestbook_no");
		System.out.println(guestbookNo + "<-guestbookNo");

		
		
		// 페이징 -------------------------------
		
		int currentPage=1;
		if(request.getParameter("currentPage")!=null) {
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
			// 여기서 null을 여기서
		}
			

  		int ROW_PER_PAGE = 10;
  		int beginRow = (currentPage -1) * ROW_PER_PAGE;; // 원래는 커렌트페이지 등을 써야한대 ㅠㅠㅠ 우리보고 알아서 하랭 ㅠ 
  		int totalRow = 0;
  		
//		count(*) cnt 써도 ㅇㅋ							
		PreparedStatement stmt2 = conn.prepareStatement("select count(*) from guestbook"); 
						//└이게 컬럼명이래	
		ResultSet rs2 = stmt2.executeQuery();	
		System.out.println(stmt2 +"<--stmt2");
		
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
      
    
    <div class="col-sm-10"> <!-- --------여기 아래서 방명록 나오게!!!--------- -->
		<!--  todo -->
	  	<%
	  		if(session.getAttribute("loginId") !=null) {// 로그인 해서만 방명록 보임 	
	  	
	  	%>
	  	<form action="./insertGuestbookAction.jsp" method="post">	
	  	  	<h3>Guest book</h3>
	  		<table class="table table-hover">
	  			<tr>	  				
	  				
		  	  		<td>Contents : <input type="hidden" name="boardNo" value="<%=guestbookNo%>"></td> 
					<!--  세션에 아이디 잇으니까 히든값이 딱히 필요없엉 로그인하면 방명록 보이게만 하면 ㅇㅋ -->
				   	<td><textarea rows="3" cols="50" name="guestbookContent"></textarea></td>
			 		
			 		<td><button type="submit" class="btn btn-link"> 입력 </button></td>
				   	
			  			<!--  
			  			guestbook_no : auto increment
			  			guestbook_content : guestbookContent
			  			id : session.getAtttribute("loginId")
			  			create_date : now();
			  			 -->
		  		</tr>
	  	</table>
	  	</form>
	  	
	  	<%
	  		}
	  	
	  	%>
	  	
	 
		 <%
		 /*
		  	SELECT guestbook_no guestbokNo, 
		  	guestbook_content guestbookContent, 
		  	id, 
		  	create_date createDate 
		  	FROM guestbook 
		  	ORDER BY guestbook_no DESC LIMIT ?, ?
	  	*/
	  	
	  	
	  		String guestbookSql =""; 
			PreparedStatement guestbookStmt = null;
			if (guestbookNo == null ){ 
	  	
	  		guestbookSql = "SELECT guestbook_no guestbookNo, guestbook_content guestbookContent, id, create_date createDate FROM guestbook ORDER BY guestbook_no  LIMIT ?, ?";
	  		guestbookStmt = conn.prepareStatement(guestbookSql);
	  		guestbookStmt.setInt(1, beginRow);
	  		guestbookStmt.setInt(2, ROW_PER_PAGE);
	  		
			
	  		
	  		// 방명록은 상세보기 없ㅇ ㅓ그냥 바로 입력하고 밑에 나오게 할거랭
	  		
	  		
			}
			
			ResultSet guestbookRs = guestbookStmt.executeQuery();
	  	%>	
	  	  		
			  	<%	  	
			  		while(guestbookRs.next()) {
			  	%>
			  		<table class="table table-hover">
	  					
			  			<tr>	
			  				<td colspan="2"> Contents: <%=guestbookRs.getString("guestbookContent")%></td>
			  				<td> Name: <%=guestbookRs.getString("id")%></td>
			  				<td> Createdate: <%=guestbookRs.getString("createDate")%></td>				  		
			  			</tr>
			  		
			  		
			  		</table>	
			  		
			  					<% 
			  					String loginId = (String)session.getAttribute("loginId"); 					//┐
			  					if(loginId !=null && loginId.equals(guestbookRs.getString("id")))	{ //┌얘나 위나 같은 말임 복잡해서 쌤이 간단하게 한다고 스트링에 박았어
			  					//if(((String)session.getAttribute("loginId")).equals(guestbookRs.getString("id")))	{
				  				%>				  		
				  					<a href="./deleteGuestbookAction.jsp?guestbookNo=<%=guestbookRs.getInt("guestbookNo")%>"> 삭제 </a>	<!--  세션을 확인이 가능하니까 따로 비번확인란은 없엉 그냥 ㅐㅎ당 인간 로긴하면 삭제 ㄱ -->			  				
				  				<%
			  					}
				  		}
			  	%>

		  
	  	<!--  페이징 -->
	  	<!--  페이징 -->
	  	<!--  페이징 -->
	  	<!--  페이징 -->
	  	<div>
		<ul class="pagination pagination-sm">
		
						
				<%
				
						if( currentPage >1 ) {
				%>			
						<li class="page-item"><a class="page-link" href="./guestbook.jsp?&currentPage=<%=currentPage-1%>"> 이전 </a></li>
							<!--  null 이기 때문에 뒤에 locationNo를 넘기지 않아 -->	
				<%			
					}					
				%>
				
				<% 				
					if( lastPage>currentPage ) {
				%>
												
						<li class="page-item"><a class="page-link" href="./guestbook.jsp?&currentPage=<%=currentPage+1%>"> 다음 </a></li>
					
					<%		
						
				
					}
				%>
		
		</ul>
		</div>	
	  	
		</div>	
	  </div><!--  end main -->
	</div>	
<div class="mt-5 p-4 bg-dark text-white text-center">
  <p>ⓒ 2022. 김희원 all rights reserved. (C) 2022. 김희원 all rights reserved</p>
</div>
</body>
</html>