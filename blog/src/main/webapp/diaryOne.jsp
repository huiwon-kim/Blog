<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%

   request.setCharacterEncoding("UTF-8");
   


	if(session.getAttribute("loginId")==null ) {
		response.sendRedirect("./index.jsp"); // 완전 처음 인덱스로 ㄱ
		return;
	}
	



   int diaryNo = Integer.parseInt(request.getParameter("diaryNo"));
   System.out.println(diaryNo+"<--diaryNo");
   
   Class.forName("org.mariadb.jdbc.Driver");
	String url ="jdbc:mariadb://15.164.0.180/blog";
	String dbuser="root";
	String dbpw="xlavmf1012!";
   Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
   
   String sql = "";
   PreparedStatement stmt = null;
   ResultSet rset = null;
   
   
   sql = "SELECT diary_no diaryNo, diary_date diaryDate, diary_todo diaryTodo, create_date createDate FROM diary where diary_no=?;";
   stmt = conn.prepareStatement(sql);
   stmt.setInt(1, diaryNo);
   rset = stmt.executeQuery();
   
      
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
          <a class="nav-link" href="./boardList.jsp?locationNo=<%=locationRs.getString("locationNo")%>" >
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
      while (rset.next()) {
%>

   <div class="container">
      <h1> Diary View Details </h1>
      <hr/>
      <table class="table table-bordered">
         <tr>         
            <td>DiaryNo</td>            
            <td><%=rset.getInt("diaryNo") %></td>
         </tr>
         <tr>
            <td>DiaryDate</td>
            <td><%=rset.getString("diaryDate") %></td>
         </tr>
         <tr>
            <td>DiaryTodo</td>
            <td><%=rset.getString("diaryTodo") %></td>
         </tr>
         <tr>
            <td>CreateDate</td>
            <td><%=rset.getString("createDate") %></td>
         </tr>
      </table>
   
<%
      }
%>

<a href="./updateDiaryForm.jsp?diaryNo=<%=diaryNo%>" class="text-decoration-none">수정</a>
<a href="./deleteDiaryAction.jsp?diaryNo=<%=diaryNo%>" class="text-decoration-none">삭제</a>
</div>
</div>
</div>
</div>
<div class="mt-5 p-4 bg-dark text-white text-center">
  <p>ⓒ 2022. 김희원 all rights reserved. (C) 2022. 김희원 all rights reserved</p>
</div>
</body>
</html>