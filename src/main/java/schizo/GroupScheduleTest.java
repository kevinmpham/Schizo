package schizo;

import static org.junit.jupiter.api.Assertions.*;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import com.google.appengine.api.users.User;

class GroupScheduleTest {
	
	@Test
	void testCalculateSchedule() {
		Random rand = new Random();
		List<Schedule> schedules = new ArrayList<Schedule>();
		ArrayList<Boolean> data1, data2;
		ArrayList<Integer> result;
		data1 = new ArrayList<Boolean>();
		data2 = new ArrayList<Boolean>();
		result = new ArrayList<Integer>();
		for(int i = 0; i < Schedule.weekLength; i++) {
			data1.add(rand.nextBoolean());
			data2.add(rand.nextBoolean());
			if(data2.get(i) && data1.get(i)) result.add(2);
			else if(data2.get(i) || data1.get(i)) result.add(1);
			else result.add(0);
		}
		User user1 = new User("test1example.com", "gmail.com");
		User user2 = new User("test2example.com", "gmail.com");
		schedules.add(new Schedule(user1, data1));
		schedules.add(new Schedule(user2, data2));
		GroupSchedule gs = new GroupSchedule();
		ArrayList<User> users = new ArrayList<User>();
		users.add(user1);
		users.add(user2);
		gs.users = users;
		gs.calculateSchedule(schedules);
		assertTrue(gs.calculateSchedule(schedules).equals(result));
	}

	@Test
	void testGenerateUniqueCode() {
		GroupSchedule gs = new GroupSchedule();
		ArrayList<String> codes = new ArrayList<String>();
		for(int i = 0; i < 100; i++) {
			codes.add(gs.generateUniqueCode());
		}
		int count;
		for(String fst : codes) {
			count = 0;
			for(String snd : codes) {
				if(fst.length() != 11) assertTrue(fst.length() == 11);
				if(fst.equals(snd)) count++;
			}
			if(count != 1) assertTrue(count == 1);
		}
	}
}
