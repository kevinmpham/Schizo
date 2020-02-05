package schizo;

import static org.junit.Assert.*;
import java.util.TreeSet;
import java.util.Set;
import org.junit.Test;

import java.util.ArrayList;


import com.google.appengine.api.users.User;

class SaveScheduleServletTest {

	@Test
	void test() {
		SaveScheduleServlet sss = new SaveScheduleServlet();
		String slist[] = {"0", "3"};
		User user = new User("test", "gmail.com");
		Schedule s = sss.populateSchedule(slist, user, 4);
		ArrayList<Boolean> sl = s.getSchedule();
		boolean saveScheduleFlag = sl.get(0) && sl.get(3);
		assert(saveScheduleFlag);
		assert(s.getUser().getEmail().equals("test"));
	}

}
