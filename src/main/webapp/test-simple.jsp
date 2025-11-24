<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Test Simple</title>
</head>
<body>
    <h1>Test Simple JSP</h1>
    <p>Si vous voyez cette page, les JSP fonctionnent !</p>

    <h2>Informations Session</h2>
    <%
        HttpSession sess = request.getSession(false);
        if (sess != null) {
            Object user = sess.getAttribute("currentUser");
            if (user != null) {
                out.println("<p style='color: green;'>✓ Session existe</p>");
                out.println("<p style='color: green;'>✓ currentUser existe: " + user.toString() + "</p>");
            } else {
                out.println("<p style='color: red;'>✗ currentUser est null</p>");
            }
        } else {
            out.println("<p style='color: red;'>✗ Pas de session</p>");
        }
    %>

    <h2>Tests de Navigation</h2>
    <ul>
        <li><a href="${pageContext.request.contextPath}/pay.jsp">pay.jsp</a></li>
        <li><a href="${pageContext.request.contextPath}/projects.jsp">projects.jsp</a></li>
        <li><a href="${pageContext.request.contextPath}/dashboard.jsp">dashboard.jsp</a></li>
    </ul>
</body>
</html>