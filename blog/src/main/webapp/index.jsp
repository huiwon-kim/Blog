<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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


<div class="container">

	<br>
	<%
		if(request.getParameter("errorMsg") !=null) { // 로그인 액션서 msg가 발생한다면
	%>
		<div><%=request.getParameter("errorMsg")%></div>
	
	<%		
		}
	%>


	<%
	if (session.getAttribute("loginId") == null) { // 로그인 전 >>> 로그인 한 적이 없다 >>> 세션에 기록된 id가 없다
		
	
	%>
	<br>
	
	<h3> LOGIN </h3>
	<form action="./loginAction.jsp" method="post">
		
		<table class="table table-hover">
		
			<tr>
				<td> id </td>
				<td><input type="text" name="id"></td>
			</tr>			
			<tr>
				<td> pw </td>
				<td><input type="password" name="pw"></td>
			</tr>
	
		</table>
			<button type="submit" class="btn btn-link"> 로그인</button>
	</form>	
	<a href="./insertMemberForm.jsp" class="btn btn-link"> 회원가입 </a>
	
	<%
	} else {
	%>
	<div style="text-align:center;">
	<br>
	<div style="text-align: center">
	<img src="./image/dolphin.jpg" style="width: 10vw; min-width: 100px;" class="rounded-circle">
</div>
		<br>
	<span style=" font-style: italic ; font-weight: bold;">
		<h1>"
		
		<%=session.getAttribute("loginId")%>(level.<%=session.getAttribute("loginLevel")%>)" 님 반갑습니다 !</h1>
		
		</span> 
		<!--  세션에 데이터 들어갈 때는 오브젝트타입이래. 얘가 대빵이잖앙 알지? >> 그래서 나중엔 형변환해준대 -->
		<h5><a href="./logout.jsp" class="text-decoration-none"> 로그아웃</a></h5>
		<div>
		<br>
		※ 본 홈페이지의 이용은 상단의 Home, Index, Diary, GuestBook, Logout 를 이용해주세요 !
		</div>
		</div>
	<%
	}
	%>
	

</div>

</body>
</html>