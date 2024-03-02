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
  //seq #1) initialContext.lookup("java:comp/UserTransaction")
  UserTransaction utrans = null;
  {
    utrans = (UserTransaction) initialContext.lookup("java:comp/UserTransaction");
    out.println("<div>seq #1) ID 조회: max+1</div>");
    out.println("<div>utrans: "+utrans+"</div>");
  }
  
  // begin transaction
  {
    utrans.begin();
  }
  
  out.println("<div>---</div>");
  
  DataSource ds = (DataSource) initialContext.lookup("java:comp/env/jdbc/oracleDS");
  Connection conn = null;
  Statement stmt = null;
  
  // seq #2) SELECT NVL(MAX(ID), 0)+1 FROM TB_TEST
  int nextId = -1;
  {
    out.println("<div>seq #2) SELECT NVL(MAX(ID), 0)+1 FROM TB_TEST</div>");
    try {
      conn = ds.getConnection();
      stmt = conn.createStatement();
      stmt.execute("SELECT NVL(MAX(ID), 0)+1 FROM TB_TEST");
      ResultSet rs = stmt.getResultSet();
      if (rs.next()) {
        nextId = rs.getInt(1);
        out.println("<div>nextId: "+nextId+"</div>");
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
  
  out.println("<div>---</div>");
  
  //seq #3) INSERT INTO TB_TEST (ID, USER_NAME) VALUES (?, ?)
  {
    out.println("<div>seq #3) INSERT INTO TB_TEST (ID, USER_NAME) VALUES (?, ?)</div>");
    PreparedStatement pstmt = null;
    try {
      conn = ds.getConnection();
      {
        out.println("<div>conn.getAutoCommit(): "+conn.getAutoCommit()+"</div>");
        if (conn.getAutoCommit()) {
          out.println("<div>conn.setAutoCommit(false)</div>");
          conn.setAutoCommit(false);
        }
      }
      pstmt = conn.prepareStatement("INSERT INTO TB_TEST (ID, USER_NAME) VALUES (?, ?)");
      pstmt.setInt(1, nextId);
      pstmt.setString(2, UUID.randomUUID().toString());
      pstmt.execute();
      conn.commit();
      pstmt.close();
      conn.close();
    } catch (SQLException se) {
      out.println(se.toString()); 
    } catch (Exception e) {
      out.println(e.toString());
    } finally {
      try { if (pstmt != null) pstmt.close(); } catch (Exception e) {} 
      try { if (conn != null) conn.close(); } catch (Exception e) {} 
    }
  }
  
  out.println("<div>---</div>");

  // transaction
  {
    utrans.commit();
    //utrans.rollback();
  }
  
  // fin) SELECT ID, USER_NAME FROM TB_TEST
  {
    out.println("<div>fin) SELECT ID, USER_NAME FROM TB_TEST</div>");
    try {
      conn = ds.getConnection();
      stmt = conn.createStatement();
      stmt.execute("SELECT ID, USER_NAME FROM TB_TEST ORDER BY 1 DESC");
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