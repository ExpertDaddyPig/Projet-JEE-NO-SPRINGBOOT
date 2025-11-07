<!-- cette page contient les elements communs, par exemple le header -->
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html>
   <head>
      <title>JSP - Hello World</title>
   </head>
   <body>
      <header>
         <ul>
            <li><a href="">Employees</a></li>
            <li><a href="">Departements</a></li>
            <li><a href="">Projets</a></li>
            <li><a href="">Pay</a></li>
            <li><a href="">Admin</a></li>
         </ul>
      </header>

      <h1><%= "Hello World!" %></h1>

      <br />

      <a href="hello-servlet">Hello Servlet</a>
   </body>
</html>
