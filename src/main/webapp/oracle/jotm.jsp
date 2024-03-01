<%@page import="javax.transaction.UserTransaction"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<body>
<%
  InitialContext initialContext = new InitialContext();
  UserTransaction utrans = (UserTransaction) initialContext.lookup("java:comp/UserTransaction");
  out.println(utrans);
%>
</body>
</html>