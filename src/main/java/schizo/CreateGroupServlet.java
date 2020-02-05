package schizo;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import com.googlecode.objectify.ObjectifyService;
import static com.googlecode.objectify.ObjectifyService.ofy;

@SuppressWarnings("serial")
public class CreateGroupServlet extends HttpServlet {
	
	// who knows if you really need this
	static {
		ObjectifyService.register(Schedule.class);
		ObjectifyService.register(GroupSchedule.class);
	}
	
	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		if(user != null) {
			String groupName = req.getParameter("groupName");
			if(groupName != null) {
				if(!(groupName.equals(""))) {
					createSchedule(user, groupName);
				}
			}
		}
		resp.sendRedirect("/display.jsp");
	}

	public GroupSchedule createSchedule (User user, String groupName) throws IOException {
		GroupSchedule gs = new GroupSchedule(user, groupName);
		ofy().save().entity(gs).now();
		return gs;
	}
}
