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
<%@ page import="schizo.GroupSchedule"%>


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
<html>
	<head>
		<title>Schizo</title>
	</head>
	<body>
<% 

		ObjectifyService.register(Schedule.class);
		ObjectifyService.register(GroupSchedule.class);
		
		List<Schedule> schedules = ObjectifyService.ofy().load().type(Schedule.class).list();
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
%>
<!-- Sidebar/menu -->
<nav class="w3-sidebar w3-red w3-collapse w3-top w3-large w3-padding" style="z-index:3;width:300px;font-weight:bold;" id="mySidebar"><br>
  <a href="javascript:void(0)" onclick="w3_close()" class="w3-button w3-hide-large w3-display-topleft" style="width:100%;font-size:22px">Close Menu</a>
  <div class="w3-container">
    <h3 class="w3-padding-64"><b>Home Page</b></h3>
  </div>
  <div class="w3-bar-block">
<% 		
	if (user != null) {
		pageContext.setAttribute("user", user);
%>
		<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>" class="w3-bar-item w3-button w3-hover-white">Sign-out</a><br>
	    <a href="createschedule.jsp" class="w3-bar-item w3-button w3-hover-white">Create/Change Schedule</a> <br>
<%
		for(Schedule s : schedules){
			if(s.getUser().equals(user)){
%>
			    <a href="display.jsp" class="w3-bar-item w3-button w3-hover-white">View Group Schedule</a> <br>
<%
			    break;
			}
		}
	} else { 
%>
	    <a href="<%= userService.createLoginURL(request.getRequestURI()) %>"  class="w3-bar-item w3-button w3-hover-white">Sign-in</a>
<%
	}
%>
  </div>
</nav>

<!-- Top menu on small screens -->
<header class="w3-container w3-top w3-hide-large w3-red w3-xlarge w3-padding">
  <a href="javascript:void(0)" class="w3-button w3-red w3-margin-right" onclick="w3_open()">☰</a>
  <span>Home Page</span>
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
  </div>
  
  <!-- Photo grid (modal) -->
  <div class="w3-row-padding">
    <div class="w3-half">
      <p class="w3-large">
      	 Schizo is a scheduling application which helps groups of all types schedule meetings and activities. 
      	 Create your individual schedule, join a group, and Schizo's algorithm will calculate the best times for your group to meet.
      	 To get started, sign in and create your individual schedule on the left. 
      </p>
      <br>
      <p class="w3-large">Create Your Individual Schedule</p>
      <img src="createschedule.png" style="width:100%" onclick="onClick(this)" alt="Create Your Individual Schedule">
      <br>
      <br>
      <br>
      <p class="w3-large">Join, Create, and View Groups with Others</p>
      <img src="groups.png" style="width:100%" onclick="onClick(this)" alt="Join, Create, and View Groups with Others">
      <br>
      <br>
      <br>
      <p class="w3-large">Display Schedule in a Heat-map Format Indicating Free Time</p>
      <img src="display.png" style="width:100%" onclick="onClick(this)" alt="Display Schedule in a Heat-map Format Indicating Free Time">
      <br>
      <br>
      <br>
    </div>
  </div>

  <!-- Modal for full size images on click-->
  <div id="modal01" class="w3-modal w3-black" style="padding-top:0" onclick="this.style.display='none'">
    <span class="w3-button w3-black w3-xxlarge w3-display-topright">×</span>
    <div class="w3-modal-content w3-animate-zoom w3-center w3-transparent w3-padding-64">
      <img id="img01" class="w3-image">
      <p id="caption"></p>
    </div>
  </div>
<!-- End page content -->
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
