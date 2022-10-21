<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "vo.*"%> <!--  우리가 만든 그 vo -->

<%
	
	//달력을 출력할거다. 이번달 년도와 월은 알아야 달력을 출력하겠징
	/* 	int y = Integer.parseInt(request.getParameter("y"));
		int m = Integer.parseInt(request.getParameter("m")); */
	
	//둘은 최소필요조건이므로 둘다 충족되어야
	Calendar c = Calendar.getInstance();
	
	if(request.getParameter("y")!=null || request.getParameter("m")!=null) {
		// y와 m이 넘어온다면 
		int y = Integer.parseInt(request.getParameter("y"));
		int m = Integer.parseInt(request.getParameter("m"));

		
		// 월의 다음. 
		// 2022년 7월의 다음 >>> 2022년 8월 (월만 +)
		// 2022년 12월의 다음 >>> 2023년의 1월 (년도가 +)
		// m이 0이되면 12가 되면서 년도가 -1?
		// m이 13이 되면 년도가 +1
		// >>> 월값에 따라서 년도가 바뀔 수도 있엉
		
		
		if(m==-1) { // 1월에서 이전버튼 누를때
			m =11; // 그러면서 이전년도겠군
			y=y-1; // y=y-1; / y -=1; / y--; / 모두 같은 말
		}
		
		if(m==12) { // 12월에서 다음버튼 누를때
			m =0;
			y= y+1; // y=y+1; / y +=1; / y++; / 모두 같은 말			
		}
		
		c.set(Calendar.YEAR, y);
		c.set(Calendar.MONTH, m); //>>> 원래값이 넘어옴				
		
		// 게시판은 10개 n개 등으로 묶어서 페이징 하지만 달력은 월별로 페이징을 한다
	} 
	
	
	int lastDay = c.getActualMaximum(Calendar.DATE);
	
	
	
	
	//-----------------------------------------------------------이제 달력 테이블 시작
	
	
	int startBlank = 0; // 1일 전에 빈 td의 개수, 일요일 0, 월1, 토6  ; <- (1일의 요일값 -1)
	// (Ex. 일월화수목금토 기준 금요일이 1일일경우 일월화수목 >>> 5개)
	
	
	// 출력하는 달의 1일의 날짜 객체
	Calendar first = Calendar.getInstance(); // 년 월 일의 정보를 갑고잇는
	first.set(Calendar.YEAR, c.get(Calendar.YEAR));
	first.set(Calendar.MONTH, c.get(Calendar.MONTH));
	first.set(Calendar.DATE, 1);
	// >>> 이 날짜객체들로 요일을 구할 수있음
	
	startBlank = first.get(Calendar.DAY_OF_WEEK)-1; // 일요일 0, 월1, 토6  ; <- (1일의 요일값 -1) >>> = 객체날짜 -1
	//	아 그러니까 원래 Calendar.DAY_OF_WEEK는 일(1) 월(2) 화(3) 수(4) 목(5) 금(6) 토(7) 의 알고리즘임
	//										여기서 이제 -1을 하면 빈칸의 개수다
	
	
	int endBlank = 7- (startBlank+lastDay)%7; 
	// 마지막날짜 이후에 빈 td의 개수
	// 2022 07월 기준
	// 스타트 블랭크는 5개 +마지막일은 31 = 36
	// 36%7= 1,
	// 7-1= 6 >>> 엔드블랭크의 갯수는 6이다
	if(endBlank==7) {
		endBlank=0;
		// 이 경우 요일없이 빈칸이 7개되는데 이걸 추가하면 그냥 빈한줄 추가니까
		// 7이면 이제 0으로 바꿔서 그냥 출력 안되게
	}
	
	
	/*	
	SELECT *
	FROM diary
	WHERE YEAR(diary_date) = ? AND MONTH(diary_date)=?
	ORDER BY diary_date;	
	*/

	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("db로딩!");
	String url ="jdbc:mariadb://15.164.0.180/blog";
	String dbuser="root";
	String dbpw="xlavmf1012!";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	
	// 메뉴 목록
	String locationSql = "SELECT location_no locationNo, location_name locationName FROM location"; //알리언스래 
	PreparedStatement locationStmt = conn.prepareStatement(locationSql);
	ResultSet locationRs = locationStmt.executeQuery();
	
	
	
	
	// 다이어리
	String sql = "SELECT diary_no diaryNo, diary_date diaryDate, diary_todo diaryTodo FROM diary WHERE YEAR(diary_date)=? AND MONTH(diary_date)=? ORDER BY diary_date";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, c.get(Calendar.YEAR));
	stmt.setInt(2, c.get(Calendar.MONTH)+1);
	
	// 이것들을 저 밑에 출력을 시켜야행 >>> RS는 불편해서 못쓴대
	// 그냥 그 diary_no,diary_date,diary_todo, create_date 컬럼 4개에 속한 그 가로 한줄을 다 배열로 묶어버려
	
	ResultSet rs = stmt.executeQuery();
	// >>>ResultSet은 좀 특별한 타입이라 어레이리스트라는 일반적인 타입으로 바꿔줄거라는군				┌제네릭... Object그거..해두면 형변환 안해도 지가 알아서 바꿔주겠지 이경우 Diary type으로
	// 특수한 환경의 타입 diaryxpdlqmfdml ResultSet -> 자바를 사용하는 EVERYWHERE ArrayList<Diary> [콜렉션 프레임워크 3친구중 하나 기억나지?]
	//											어디서든(에브리웨어) 이러다가 하는말이 > 자바에 있는 기본 API타입으로 해야한대
	//											특수한 타입 말고 누구나 이거 가지면 가공 가능하게 
	//														
	
	ArrayList<Diary> list = new ArrayList<Diary>();
	// 현재는 만들고 db없어서 0개의 배열이여 >>> 이걸 다이어리로 채워
	while(rs.next()) {
		Diary d= new Diary(); // 행의 수만큼 >>> rs의 갯수만큼 채워짐 >>> rs가 그만큼 돌려야 
		d.diaryNo = rs.getInt("diaryNo");
		d.diaryDate = rs.getString("diaryDate");
		d.diaryTodo = rs.getString("diaryTodo");
		
		//	  ┌>>>이 d들을 누적시켜야
		list.add(d); // list 안에 rs수만큼 이제 d가 채워짐
	}
	
	System.out.print(list); // 디버깅
	
	
	
	rs.close();
	stmt.close();
	conn.close();
	
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

	<!--  todo-->
	  

		<div>
			
		<h1><span> <%=c.get(Calendar.YEAR)%>년 <%=c.get(Calendar.MONTH)+1%>월 </span></h1>	<!--  출력에만 +1일 뿐임 -->
			<a href="./diary.jsp?y=<%=c.get(Calendar.YEAR)%>&m=<%=c.get(Calendar.MONTH)-1%>" class="text-decoration-none"style="color: gray"> 이전달 </a>
			<a href="./diary.jsp?y=<%=c.get(Calendar.YEAR)%>&m=<%=c.get(Calendar.MONTH)+1%>" class="text-decoration-none"style="color: gray"> 다음달 </a>
			<!--   -->
		</div>
		
		
		<!--  <div> startBlank : <!%=startBlank%> </div> <!--  그냥 달력 켜서 빈칸 세도 똑같음 -->
			
		<table class="table table-bordered"  height="300">
			<tr>
			
				<td><span style=" font-style: italic ; font-weight: bold; color: red;"> SUN </span></td>
				<td><span style=" font-style: italic ; font-weight: bold;"> MON </span></td>
				<td><span style=" font-style: italic ; font-weight: bold;"> TUE </span></td>
				<td><span style=" font-style: italic ; font-weight: bold;"> WED </span></td>
				<td><span style=" font-style: italic ; font-weight: bold;"> THU </span></td>
				<td><span style=" font-style: italic ; font-weight: bold;"> FRI </span></td>
				<td><span style=" font-style: italic ; font-weight: bold;"> SAT </span></td>
			
			</tr>
			<tr>
				
			<%			
				// 블랭크 숫자만큼 td나와야 
				for(int i=1; i<=startBlank+lastDay+endBlank; i=i+1 ) {
				
					if(i-startBlank <1){
			%>
						<td>&nbsp;</td>
			<%			
					} else 	if(i-startBlank >lastDay) {
			%>
						<td>&nbsp;</td>
			<%			
					} else {
			%>
						<td> <!--  달력의 날짜 누르면 일정 입력가능하게 할거야 -->
																									<!-- 디비 숫자는 원래 숫자라서 +1 -->
							<a href="./insertDiary.jsp?y=<%=c.get(Calendar.YEAR)%>&m=<%=c.get(Calendar.MONTH)+1%>&d=<%=i-startBlank%>" style="color: black">
								<input type="hidden" value="<%=i-startBlank%>" name="d">
								<input type="hidden" value="<%=c.get(Calendar.YEAR)%>" name="y">
								<input type="hidden" value="<%=c.get(Calendar.MONTH)+1%>" name="m">
								
								<%=i-startBlank%>
								<!--  얼은 똑같으니까 다이어리데이트의 날자랑 이거랑 같아야한대 -->
								</a>
								<%
									for(Diary d : list) { // >>> 이건 td 마다 list의 내용을 반복해주세용 이라는 소리
										// d.diaryDate.substring(8); >>> 원래는 전체길이 알아야한대. 근데 지금은 전부 전체자리 숫자[9자리임;0부터 시작한](년도4 월2 일2 사이사이 --)
										// 나는 지금 끝에서부터 2자리를 자르고싶어
										// >>>Integer.parseInt(d.diaryDate.substring(8));
										
										// 	d하나씩 나올때마다
										if(Integer.parseInt(d.diaryDate.substring(8)) == i-startBlank) {
								%>								
										<div>
										<input type="hidden" value="<%=d.diaryNo%>" name="diaryNo">
										<a href="./diaryOne.jsp?diaryNo=<%=d.diaryNo%>" class="text-decoration-none"style="color: black" ><%=d.diaryTodo%></a>
										</div> <!--  [x]  이것만 쓰면 안되고 위에 if로 조건을 걸어줘야 날짜의 리스트만 출력해야한대 -->								
								<%		
										}
									}
								%>
							
						</td>
			<%		
					}
					 if(i%7==0 ) { //7로 나누어 딱 떨어지면 td 7번 찍혓단 소리 >>> 다음줄로 넘어가자
			%>
						</tr></tr>
						<!--  나ㅜㄴ어 떨어지는데 lastDay startBlank -->						
			<%			
					 }
				}			
			%>
			</tr>
		</table>
	    
	 <!--  마지막  -->   
     <!--  달력 알고리즘이 필요하대 >>> 우린 테이블ㄹ 달력 만들거래 전체 TD갯수
     TD에 인덱스를 붙여서 TD가 7로 나누어 떨어지는 자리에 1을 붙인대 -->
 
	</div>
	</div>
</div>
<div class="mt-5 p-4 bg-dark text-white text-center">
  <p>ⓒ 2022. 김희원 all rights reserved. (C) 2022. 김희원 all rights reserved</p>
</div>
</body>
</html>