<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.*"%>

<%
		// 일단 로그인 안되어있음 못드렁와
		if(session.getAttribute("loginId")==null) {
			response.sendRedirect("./index.jsp"); // 완전 처음 인덱스로 ㄱ
			return;
		}


		// 위에서 로그인 성공햇지만 레벨값이 1보다 작으면 (어드민=관리자가 아니면)
		if((Integer)session.getAttribute("loginLevel") <1) {
			response.sendRedirect("./boardList.jsp"); // 글목록으로 강제 ㄱ	
			return;
		}




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
	<!--  todo -->
	
	  	<h1> 게시글 입력 </h1>
	  	
	  	<br>
	  	<form action="./insertBoardAction.jsp" method="post">
		  <table class="table table-bordered">
		  	<tr>
		  		<td>locationNo</td>
		  		<td>
		  			<select name="locationNo">
		  				<%
		  					// 더 좋은 방법이 있을 수도 있대. 그리고 이런 문제는 MVC MODEL1 MODEL2 쓰면 해결된대
		  					locationRs.first(); // 위에서 이미 rs.next() 써서 임시방편
		  					// >>> 자료가 시작되는 커서를 첫번째칸으로 옮긴거야 내장메서드를 이용해서
		  					// 시작은 서울인데 와일의 경우 서울부터 안나오고 다음칸(인천)부터 ㅏ농니까.. 서울부터 다 나오려면 두와일이래...
		  					do {
		  				%>
		  					<option value="<%=locationRs.getInt("locationNo")%>"> <!--  넘어가는 자료는 locationNo래 
		  					
		  					-->
		  						<%=locationRs.getString("locationName")%>
		  					</option>
		  				
		  				<%
		  					}while(locationRs.next());
		  				%>
		  			</select>
		  		</td>
		  		</tr>
		  		<tr>
		  			<td> BoardTitle </td>
		  			<td> <input type="text" name="boardTitle"></td>
		  		</tr>
		  		<tr>
		  			<td> BoardContent</td>
		  			<td>
		  				<textarea rows="5" cols="80" name="boardContent"></textarea>		  			
		  			</td>
		  		</tr>
		  			<tr>
		  			<td> BoardPw</td>
		  			<td>
		  				 <input type="password" name="BoardPw"> 			
		  			</td>
		  		</tr>
			</table>
				<button type="submit" class="btn btn-link"> 글입력 </button>
				<button type="reset" class="btn btn-link"> 초기화 </button>
		</form>
		</div>	
	  </div><!--  end main -->
	</div>	
<div class="mt-5 p-4 bg-dark text-white text-center">
  <p>ⓒ 2022. 김희원 all rights reserved. (C) 2022. 김희원 all rights reserved</p>
</div>
</body>
</html>