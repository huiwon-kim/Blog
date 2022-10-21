<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%

	request.setCharacterEncoding("utf-8");
		
		String id = request.getParameter("id");
		String pw = request.getParameter("pw");

	//로그인 한 사람이 여기로 오면 
	if(session.getAttribute("loginId") !=null) {
		response.sendRedirect("./index.jsp"); // 더이상 진행 못하게 인덱스로 ㄱㄱ
		return;
	}

	if(id==null || pw==null ){
			response.sendRedirect("./index.jsp?erroMsg=Invalid Access");
			return; // return 대신 else 블록 사용해도 오케이래
			// 
	}
	

	
	


	Class.forName("org.mariadb.jdbc.Driver");
	String url ="jdbc:mariadb://15.164.0.180/blog";
	String dbuser="root";
	String dbpw="xlavmf1012!";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	
	// ┌ 아이디와 비번이 같은지 어떻게 아는데?
	String sql ="SELECT id, level FROM member WHERE id=? AND pw=password(?)"; // 있다면 가틍ㄴ거고 아니면 아닌거지
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, id);
	stmt.setString(2, pw);
	ResultSet rs = stmt.executeQuery();
	
	// 요즘은 아디 틀렸나 비번 틀렷나 둘중 하나 자세히 말 안해줌 주인 아닐경우 프로그램 돌려서 찾지 말라구
	//	>>> 그냥 틀렸다고만 말해주는게 국롤인듯
	if(rs.next()) { // 로그인 성공		
		// 객체지향의 주요 특징 : 추상화, 다형성, 상속, 캡슐화 >>>> ★★★★★
		// 		└>>> 이거 개념 다시 정리해보자 추상화는 클래스를 만드는게 가장 쉬운 예이다 
		//		└>>> 여자보다는 사람이 더 추상적 나를 사람이다 여자다 표현 가능한건 상속받았기 때문(부모일수록 추상적인거 알지?)
		//		└>>> 상속은 자식(객체)이 부모타입 다 ㅇㅋ인거 / 티코 > 자동차 [O] / 학생 > 사람[O] >>> 이라면 학생특징이 가려져서 형변환으로 꺼내씀
		//		└>>> 필드값을 숨기는거; 정보은닉. 그렇게 숨겨진 정보(기능,속성)들을 다른 접근자 메소드로 보여줄 수 있다는데 이게 캡슐화래 (단순 감추기=정보은닉이랑 다름)
		//						  String	   Object >>> 부모타입의 자식계층은 아무거나 다 가질 수 잇는거 기억하징?? [다형성] ★★★★★
		// sesssion의 셋 어트리뷰트는 (String , Object)>>> 오브젝트는 최상위인거 알지?
		session.setAttribute("loginId", rs.getString("id")); // Object <- String
		session.setAttribute("loginLevel", rs.getInt("level")); // Objcet <- int 원래 기본타입은 참조타입에 들어갈 수 없는데 되네? 왜?
		//														Object <- Integer <- int ; 인티저가 들어간거야 (인티저;래퍼타입)[오토박싱 발생!]
		//																인트->인티져; 오토박싱/ 인트<-인티져; 오토언박싱
		//																인티져->오브젝트 일 때 [다형성 발생!]
		response.sendRedirect("./index.jsp");
	} else { // 로그인 실패
		response.sendRedirect("./index.jsp?erroMsg=Invalid ID or PW");
	}
	
	// 분기가 필요한 이유가 로그인 실패시 또 뭐 잇다는데?
	
	
%>