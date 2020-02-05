package schizo;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import com.googlecode.objectify.ObjectifyService;
import static com.googlecode.objectify.ObjectifyService.ofy;

@SuppressWarnings("serial")
public class SaveScheduleServlet extends HttpServlet {
	
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
			// init schedule arraylist to false
			Schedule sched = populateSchedule(req.getParameterValues("hour"), user, Schedule.weekLength);
			// if created schedule exists on server, delete it and save new copy
			List<Schedule> schedules = ObjectifyService.ofy().load().type(Schedule.class).list();
			for(Schedule s : schedules) {
				if(s.getUser().equals(user)) {
					ofy().delete().entity(s).now();
				}
			}
			ofy().save().entity(sched).now();
		}
		resp.sendRedirect("/landing.jsp");
	}

	public Schedule populateSchedule(String[] req, User user, int weekLength) {
		ArrayList<Boolean> schedule = new ArrayList<Boolean>();
		for(int i = 0; i < weekLength; i++) {
			schedule.add(Boolean.valueOf(false));
		}
		// populate schedule array with checked free times
		String[] checked = req;
		if(checked != null) {
			for(String c : checked) {
				schedule.set(Integer.parseInt(c), Boolean.valueOf(true));
			}
		}
		Schedule sched = new Schedule(user, schedule);
		return sched;
	}
}
