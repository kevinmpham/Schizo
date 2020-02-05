// trivial do not need to include

package schizo;

import static org.junit.jupiter.api.Assertions.*;

import java.util.ArrayList;
import java.util.Date;
import java.util.Random;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import com.google.appengine.api.users.User;

class ScheduleTest {
	
	private static ArrayList<Boolean> data;
	private static Schedule sched;
	private static User user;
	private static Date date;
	
	@BeforeAll
	public static void initialize() {
		data = new ArrayList<Boolean>();
		Random rand = new Random();
		for(int i = 0; i < Schedule.weekLength; i++) {
			data.add(rand.nextBoolean());
		}
		date = new Date();
		user = new User("test.example.com", "gmail.com");
		sched = new Schedule(user, data);
	}

	@Test
	void testSchedule() {
		Schedule mySched = new Schedule(user, data);
		assertTrue((mySched.getUser().equals(user)) && (mySched.getSchedule().equals(data)));
	}

	@Test
	void testGetUser() {
		assertTrue(sched.getUser().equals(user));
	}

	@Test
	void testGetDate() {
		assertTrue(sched.getDate().equals(date));
	}

	@Test
	void testGetSchedule() {
		assertTrue(sched.getSchedule().equals(data));
	}

}
