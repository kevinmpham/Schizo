<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ page import="java.util.Collections" %>
<%@ page import="schizo.Schedule"%>
<%@ page import="java.util.*" %>

<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Create/Update Schedule</title>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
		<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Poppins">
		<style>
		body,h1,h2,h3,h4,h5 {font-family: "Poppins", sans-serif}
		body {font-size:16px;}
		.w3-half img{margin-bottom:-6px;margin-top:16px;opacity:0.8;cursor:pointer}
		.w3-half img:hover{opacity:1}
		</style>
	</head>
	<body>
	
		<!-- Sidebar/menu -->
		<nav class="w3-sidebar w3-red w3-collapse w3-top w3-large w3-padding" style="z-index:3;width:300px;font-weight:bold;" id="mySidebar"><br>
		  <a href="javascript:void(0)" onclick="w3_close()" class="w3-button w3-hide-large w3-display-topleft" style="width:100%;font-size:22px">Close Menu</a>
		  <div class="w3-container">
		    <h3 class="w3-padding-64"><b>Create/Update Schedule</b></h3>
		  </div>
		  <div class="w3-bar-block">
		    <a href="landing.jsp" onclick="w3_close()" class="w3-bar-item w3-button w3-hover-white">Home</a> 
		  </div>
		</nav>
	
		<!-- Top menu on small screens -->
		<header class="w3-container w3-top w3-hide-large w3-red w3-xlarge w3-padding">
		  <a href="javascript:void(0)" class="w3-button w3-red w3-margin-right" onclick="w3_open()">☰</a>
		  <span>Schizo</span>
		</header>
		
		<!-- Overlay effect when opening sidebar on small screens -->
		<div class="w3-overlay w3-hide-large" style="cursor:pointer" title="close side menu" id="myOverlay"></div>

		<!-- !PAGE CONTENT! -->
		<div class="w3-main" style="margin-left:340px;margin-right:40px">

		<!-- Header -->
		<div class="w3-container" style="margin-top:80px" id="showcase">
		  <h1 class="w3-jumbo"><b>Schizo</b></h1>
		  <h1 class="w3-xxxlarge w3-text-red"><b>Keep Yo Schiz Together Baby</b></h1>
		  <hr style="width:50px;border:5px solid red" class="w3-round">
		</div>
	
		<%
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		if(user == null) {
		%>
			<script type="text/javascript">
				window.location.replace('https://utschizo.appspot.com')
			</script>

		<%
		}
		%>	
			<br>
			<p class="w3-large">Check When You're Free</p>
			<br>
			<form action="/save" method="post">
				<table table-layout="fixed" >
					<col width="80px"/>
					<col width="50px" />
					<col width="50px" />
					<col width="50px" />
					<col width="50px" />
					<col width="50px" />
					<col width="50px" />
					<col width="50px" />
					<tr>
						<th>Time</th>
						<th>Sun</th>
						<th>Mon</th>
						<th>Tues</th>
						<th>Wed</th>
						<th>Thur</th>
						<th>Fri</th>
						<th>Sat</th>
					</tr>
						<%
						for(int j = 0; j < 48; j++) {
							%><tr style="white-space:nowrap;"><%
							for(int i = -1; i < 7; i++) {
								%>
								<td style="white-space:nowrap;" align="center">
								<% 
									if(i == -1) {
										if(j%2 == 0) {
											if(j == 0) {
												%> 24:00 - 0:30<% 
											} else {
												%>
												<%=j/2%>:00 - <%=j/2%>:30 
												<%
											}
										} else {
											%>
											<%=j/2%>:30 - <%=j/2+1%>:00 
											<%
										}
									} else {
										if(j%2 == 0) {
								%>
											<input type="checkbox" id=<%=i*48+j %> name="hour" value=<%=Integer.toString(i*48+j)%>>  
								<% 
										} else {
								%>
											<input type="checkbox" id=<%=i*48+j %> name="hour" value=<%=Integer.toString(i*48+j)%>>  
								<% 
										}
									}
								%></td><%
								}
							%></tr><%
						}
						%>	
				</table>
				<br>
				<input class="w3-button w3-black w3-large" type="submit" value="Submit">
				<br><br><br>
			</form>
		</div>
<% 
	    ObjectifyService.register(Schedule.class);
	    List<Schedule> sched = ObjectifyService.ofy().load().type(Schedule.class).list();
		ArrayList<Boolean> schedule = new ArrayList<Boolean>();	
		
		for(Schedule s : sched) {
			if(s.getUser().equals(user)) {
				schedule = s.getSchedule();
			}
		}
		
		if(schedule.size() != 0) {
			for(int i = 0; i < 336; i++) {
				if(schedule.get(i)) {
%>
					<script>
			    		document.getElementById(<%=i%>).checked = true;
					</script>	
<% 
				}
			}
		}
%>
		<script>
		// Script to open and close sidebar
		function w3_open() {
		    document.getElementById("mySidebar").style.display = "block";
		    document.getElementById("myOverlay").style.display = "block";
		}
		 
		function w3_close() {
		    document.getElementById("mySidebar").style.display = "none";
		    document.getElementById("myOverlay").style.display = "none";
		}
		
		// Modal Image Gallery
		function onClick(element) {
		  document.getElementById("img01").src = element.src;
		  document.getElementById("modal01").style.display = "block";
		  var captionText = document.getElementById("caption");
		  captionText.innerHTML = element.alt;
		}
		</script>
	</body>
</html>