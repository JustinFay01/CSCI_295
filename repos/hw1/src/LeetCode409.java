import java.util.HashMap;

public class LeetCode409 {

	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}
	/*
	 * Given a string s which consists of lowercase or uppercase letters, return the
	 * length of the longest palindrome that can be built with those letters.
	 * 
	 * Letters are case sensitive, for example, "Aa" is not considered a palindrome
	 * here.
	 */
	public int longestPalindrome(String s) {
		HashMap<Character, Integer> countMap = new HashMap<>();

		for (int i = 0; i < s.length(); i++) {
			if (!countMap.containsKey(s.charAt(i)))
				countMap.put(s.charAt(i), 1);
			else {
				countMap.put(s.charAt(i), (countMap.get(s.charAt(i)) + 1));
			}
		}
		int total = 0;
		/*
		 * For each letter, say it occurs v times. We know we have v // 2 * 2 letters
		 * that can be partnered for sure. For example, if we have 'aaaaa', then we
		 * could have 'aaaa' partnered, which is 5 // 2 * 2 = 4 letters partnered.
		 * 
		 * At the end, if there was any v % 2 == 1, then that letter could have been a
		 * unique center. Otherwise, every letter was partnered. To perform this check,
		 * we will check for v % 2 == 1 and ans % 2 == 0, the latter meaning we haven't
		 * yet added a unique center to the answer.
		 */
		for (Character key : countMap.keySet()) {
			total += countMap.get(key) / 2 * 2;
			if (total % 2 == 0 && countMap.get(key) % 2 == 1)
				total++;
		}

		return total;
	}

}
