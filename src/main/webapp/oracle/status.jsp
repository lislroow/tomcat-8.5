<%@page import="java.util.UUID"%>
<%@page import="java.sql.PreparedStatement"%>
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
  DataSource ds = (DataSource) initialContext.lookup("java:comp/env/jdbc/oracleDS");
  Connection conn = null;
  Statement stmt = null;
  
  {
    out.println("<div>SELECT ID, USER_NAME FROM TB_TEST</div>");
    out.println("<div>---</div>");
    try {
      conn = ds.getConnection();
      stmt = conn.createStatement();
      stmt.execute("SELECT ID, USER_NAME FROM TB_TEST");
      ResultSet rs = stmt.getResultSet();
      while (rs.next()) {
        int id = rs.getInt(1);
        String userName = rs.getString(2);
        out.println("<div>id: "+id+", user_name=" + userName + "</div>");
      }
      stmt.close();
      conn.close();
    } catch (SQLException se) {
      out.println(se.toString()); 
    } catch (Exception e) {
      out.println(e.toString());
    } finally {
      try { if (stmt != null) stmt.close(); } catch (Exception e) {} 
      try { if (conn != null) conn.close(); } catch (Exception e) {} 
    }
  }
%>
</body>
</html>