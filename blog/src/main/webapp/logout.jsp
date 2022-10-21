<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	session.invalidate(); // 세션 리셋
	response.sendRedirect("./index.jsp"); // 당분간은 갈 곳 없음 리스폰스래

%>