# The guess API is already defined for you.
# @param num, your guess
# @return -1 if my number is lower, 1 if my number is higher, otherwise return 0
# def guess(num):

class Solution(object):
    def guessNumber(self, n):
        """
        :type n: int
        :rtype: int
        """
        low = 0
        high = n

        while low <= high:
            mid = (low + high) // 2
            result = guess(mid)

            if result == -1:
                high = mid - 1
            elif result == 1:
                low = mid + 1
            else:
                return mid
