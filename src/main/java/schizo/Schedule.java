package schizo;

import java.util.Date;
import java.util.ArrayList;

import com.google.appengine.api.users.User;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;

@Entity
public class Schedule {
	@Id Long id;
	@Index Date date;
	@Index User user;
	@Index ArrayList<Boolean> schedule;
	
	public final static int weekLength = 336;
	
	private Schedule() {}
	
	public Schedule(User user, ArrayList<Boolean> schedule) {
		this.user = user;
		this.schedule = schedule;
		this.date = new Date();
	}
	
	public User getUser() {
		return user;
	}
	
	public Date getDate() {
		return date;
	}
	
	public ArrayList<Boolean> getSchedule() {
		return schedule;
	}
}
