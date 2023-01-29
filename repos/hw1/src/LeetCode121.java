
public class LeetCode121 {

	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}
	
	/*
	 * You are given an array prices where prices[i] is the price of a given stock
	 * on the ith day.
	 * 
	 * You want to maximize your profit by choosing a single day to buy one stock
	 * and choosing a different day in the future to sell that stock.
	 * 
	 * Return the maximum profit you can achieve from this transaction. If you
	 * cannot achieve any profit, return 0.
	 */
	// Time O(n)
	// Space O(1)
	public int maxProfit(int[] prices) {
		int prof = 0;
		int min = Integer.MAX_VALUE;

		for (int i = 0; i < prices.length; i++) {
			if (prices[i] < min)
				min = prices[i];
			else if (prices[i] - min > prof)
				prof = prices[i] - min;
		}

		return prof;
	}

}
