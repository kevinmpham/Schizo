package schizo;

import java.util.Date;
import java.util.List;

import java.util.ArrayList;
import java.util.Random;

import com.google.appengine.api.users.User;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;

import com.googlecode.objectify.ObjectifyService;

@Entity
public class GroupSchedule {
	@Id Long id;
	@Index Date date;
	@Index ArrayList<User> users;
	@Index String name;
	@Index String uniqueCode;
	
	static ArrayList<String> UniqueCodes = new ArrayList<String>();
	
	protected GroupSchedule() {}
	
	public GroupSchedule(User user, String name) {
		this.users = new ArrayList<User>();
		this.users.add(user);
		this.date = new Date();
		this.name = name;
		this.uniqueCode = generateUniqueCode();
	}
	
	public boolean addUser(User user) {
		if(!users.contains(user)) {
			this.users.add(user);
			return true;
		} else {
			return false;
		}
	}
	
	public boolean removeUser(User user) {
		if(users.contains(user)) {
			this.users.remove(user);
			return true;
		} else {
			return false;
		}
	}
	
	private List<Schedule> getSchedules() {
		return ObjectifyService.ofy().load().type(Schedule.class).list();
	}
	
	protected ArrayList<Integer> calculateSchedule(List<Schedule> schedules){
		ArrayList<Integer> schedule = new ArrayList<Integer>();
		// init list to zero
		for(int i = 0; i < Schedule.weekLength; i++) {
			schedule.add(0);
		}
		// increment integer list
		for(Schedule s : schedules) {
			if(this.users.contains(s.getUser())) {
				for(int i = 0; i < Schedule.weekLength; ++i) {
					if(s.getSchedule().get(i).equals(true)) {
						schedule.set(i, schedule.get(i) + 1);
					}
				}
			}
		}
		return schedule;
	}
	
	protected String generateUniqueCode() {
		String possibleChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
		boolean unique;
		String code;
		Random rand = new Random();
		while(true) {
			unique = true;
			code = "";
			for(int i = 0; i < 11; i++) {
				code += possibleChars.charAt(rand.nextInt(36)); 
			}
			for(String c: UniqueCodes) {
				if(code.equals(c)) {
					unique = false;
					break;
				}
			}
			if(unique == true) {
				UniqueCodes.add(code);
				break;
			}
		}
		return code;
	}
	
	public String getName() {
		return name;
	}
	
	public String getUniqueCode() {
		return uniqueCode;
	}
	
	public ArrayList<User> getUsers() {
		return users;
	}
	
	public Date getDate() {
		return date;
	}
	
	public ArrayList<Integer> getSchedule() {
		return calculateSchedule(getSchedules());
	}
}
