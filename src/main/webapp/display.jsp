
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
<%@ page import="java.util.*" %>
<%@ page import="schizo.GroupSchedule"%>
<%@ page import="schizo.Schedule"%>

<html>
	<title>Group Scheduling</title>
	<head>
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
	    <h3 class="w3-padding-64"><b>Group Schedules Page</b></h3>
	  </div>
	  <div class="w3-bar-block">
	    <a href="landing.jsp" class="w3-bar-item w3-button w3-hover-white w3-pad">Return to Home</a>
	    
	    <br>
		
		<form action="/create" method="post">
			<input type="text" name="groupName" class="w3-bar-item" placeholder="Type Group Name">
			<input type="submit" value="CreateGroup" class="w3-bar-item w3-button w3-hover-white">
		</form>
		
		<form action="/join" method="post">
			<input type="text" name="goupUnique" class="w3-bar-item" placeholder="Type Group ID">
			<input type="submit" value="JoinGroup" class="w3-bar-item w3-button w3-hover-white">
		</form>
		
		<form action="/leave" method="post">
			<input type="text" name="groupUnique" class="w3-bar-item" placeholder="Type Group ID">
			<input type="submit" value="LeaveGroup" class="w3-bar-item w3-button w3-hover-white">
		</form>
	  </div>
	</nav>
	
	<!-- Top menu on small screens -->
	<header class="w3-container w3-top w3-hide-large w3-red w3-xlarge w3-padding">
	  <a href="javascript:void(0)" class="w3-button w3-red w3-margin-right" onclick="w3_open()">☰</a>
	  <span>Group Scheduling</span>
	</header>
	
	<!-- Overlay effect when opening sidebar on small screens -->
	<div class="w3-overlay w3-hide-large" onclick="w3_close()" style="cursor:pointer" title="close side menu" id="myOverlay"></div>
	
	
	
	<!-- !PAGE CONTENT! -->
	<div class="w3-main" style="margin-left:340px;margin-right:40px">
	
	  <!-- Header -->
	  <div class="w3-container" style="margin-top:80px" id="showcase">
	    <h1 class="w3-jumbo"><b>Schizo</b></h1>
	    <h1 class="w3-xxxlarge w3-text-red"><b>Keep Yo Schiz Together Baby</b></h1>
	    <hr style="width:50px;border:5px solid red" class="w3-round">
	    
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
		
		ObjectifyService.register(Schedule.class);
		ObjectifyService.register(GroupSchedule.class);
		
		List<Schedule> individualSchedules = ObjectifyService.ofy().load().type(Schedule.class).list();
		ListIterator<Schedule> individualIter = individualSchedules.listIterator();
		while(individualIter.hasNext()){
		    if(!(individualIter.next().getUser().equals(user))){
		        individualIter.remove();
		    }
		}
		if(individualSchedules.isEmpty()){
		%>
			<script type="text/javascript">
				window.location.replace('https://utschizo.appspot.com')
			</script>
		<%
		}
		
		List<GroupSchedule> sched = ObjectifyService.ofy().load().type(GroupSchedule.class).list();		
		ListIterator<GroupSchedule> iter = sched.listIterator();
		while(iter.hasNext()){
		    if(!(iter.next().getUsers().contains(user))){
		        iter.remove();
		    }
		}
		
		if(sched.isEmpty()){
%>
		<h3 class="w3-large"><b>You are not a part of any groups... :(
		<br>
		Make or join a group on the left!</b></h3>
<% 
		} else {
			int k = 0;
			for(GroupSchedule gs : sched){	
				pageContext.setAttribute("group_name", gs.getName());
%>
				
				<h3 class="w3-large">GroupName: ${fn:escapeXml(group_name)}<br>
				<%=("Group UniqueCode: " + gs.getUniqueCode())%><br>
				<%=("Number of Group Members: " + gs.getUsers().size())%><br>
				</h3>
				
				<button class="w3-button w3-black w3-large" onclick="showHide(<%=k%>)">Show/Hide Group Schedule</button>
				
				<table class="w3-large" table-layout="fixed" id=<%=k%>>
					<col width="80px"/>
					<col width="50px" />
					<col width="50px" />
					<col width="50px" />
					<col width="50px" />
					<col width="50px" />
					<col width="50px" />
					<col width="50px" />
					<tr><td colspan="8"><br>Each number represents the number of people free at that time.</td></tr>
<%
					String[] days = {"Time", "Sun", "Mon", "Tues", "Wed", "Thur", "Fri", "Sat"};
					int percentage;
					ArrayList<Integer> schedInts = gs.getSchedule();
					for (int i = -1; i < 48; i++){ // each hour.
%>
						<tr>
<%
						for(int j = -1; j < 7; j++){ // each day.
							if(i == -1) {
%>
									<td align="center"><%=days[j+1]%> </td>
<%						
							} else if(j == -1) {
								if(i%2 == 0) {
									if(i == 0) {
%>										
										<td style="white-space: nowrap" align="center">24:00 - <%=i/2%>:30  </td>	
<%
									} else {
%>
										<td style="white-space: nowrap" align="center"><%=i/2%>:00 - <%=i/2%>:30  </td>	
<%	
									}									 
								} else {
%>
									<td style="white-space: nowrap" align="center"><%=i/2%>:30 - <%=i/2+1%>:00  </td>
<% 
								}			
							} else {
								int numPeople = schedInts.get(i + (48 * j));
								percentage = 100 * numPeople / gs.getUsers().size();
								if(percentage >= 75) {
									%><td align="center" bgcolor="green"><%=numPeople%></td><%
								} else if (percentage >= 50) {
									%><td align="center" bgcolor="yellow"><%=numPeople%></td><%
								} else if (percentage >= 25) {
									%><td align="center" bgcolor="orange"><%=numPeople%></td><%
								} else {
									%><td align="center" bgcolor="red"><%=numPeople%></td><%
								}
							}
						}
%>
						</tr>
<%			
					}
%>
				</table>
				<br><br><br>
				<script>
			    document.getElementById(<%=k%>).style.display = "none";
				</script>
<%
			k++;
			}
		}
%>	
		  </div>
	</div>
	
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
	function showHide(k) {
	    var x = document.getElementById(k);
	    if (x.style.display === "none") {
	        x.style.display = "block";
	    } else {
	        x.style.display = "none";
	    }
	}
	</script>
	
	</body>
</html>