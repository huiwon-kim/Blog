<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>    
    
 <%

		// 1) 디비 로딩
		Class.forName("org.mariadb.jdbc.Driver");
		System.out.println("db로딩!");
		
		
		///////////////////// 템플릿--------------------------
		
		
		// 2) 접속
		String url ="jdbc:mariadb://15.164.0.180/blog";
		String dbuser="root";
		String dbpw="xlavmf1012!";
		Connection	conn = DriverManager.getConnection(url, dbuser, dbpw);
				

		String locationNo = request.getParameter("locationNo");
		System.out.println(locationNo +"<-locationNo"); 
					//	└같은 페이지지만 로케이션 넘버가변경중, 디버깅
		
		// 메뉴 목록
		String locationSql = "SELECT location_no locationNo, location_name locationName FROM location"; //알리언스래 
		PreparedStatement locationStmt = conn.prepareStatement(locationSql);
		ResultSet locationRs = locationStmt.executeQuery();
		
		
		
		///////////////////// 코멘트--------------------------
		
		String boardNo =request.getParameter("boardNo");
		String commentNo =request.getParameter("commentNo");
		String commentPw = request.getParameter("commentPw");
		System.out.println( boardNo + commentNo +"<-- boardNo,commentNo");
		
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
	<!--  여기서부터 비밀버놓 입력 -->
	  	<div>
	  	<form action ="./deletecommentAction.jsp" method="post">	  	
		  	<table class="table table-borderless">
			  	<tr>
			  		<td> Password</td>
			  		<td><input type="password" name="commentpw"></td>
			  		
			  		<td><input type="hidden" name="commentNo" value="<%=commentNo%>"></td>
					<td><input type="hidden" name="boardNo" value="<%=boardNo%>"></td>
					
			  		<td><button type="submit" class="btn btn-link"> 입력</button></td>
			  	</tr>
			  	</table>		  	 
	  	
	  	 </form>
	  	 </div>
		</div>	
	  </div><!--  end main -->
	</div>	
<div class="mt-5 p-4 bg-dark text-white text-center">
  <p>ⓒ 2022. 김희원 all rights reserved. (C) 2022. 김희원 all rights reserved</p>
</div>
</body>
</html>