pragma solidity ^0.4.15;

/**
 * @title Queue
 * @dev Data structure contract used in `Crowdsale.sol`
 * Allows buyers to line up on a first-in-first-out basis
 * See this example: http://interactivepython.org/courselib/static/pythonds/BasicDS/ImplementingaQueueinPython.html
 */

contract Queue {
	/* State variables */
	uint8 size = 5;
	uint8 spotsFilled;
	address[] participants;
	uint[] times;
	uint limit;
	// YOUR CODE HERE

	/* Add events */
	// YOUR CODE HERE
	event TimeLimitReached(address addr);

	/* Add constructor */
	// YOUR CODE HERE
	function Queue(uint _limit) {
		spotsFilled = 0;
		participants = new address[](size);
		times = new uint[](size);
		limit = _limit;
	}

	/* Returns the number of people waiting in line */
	function qsize() constant returns(uint8) {
		// YOUR CODE HERE
		return spotsFilled;
	}

	/* Returns whether the queue is empty or not */
	function empty() constant returns(bool) {
		// YOUR CODE HERE
		return (spotsFilled == 0);
	}
	
	/* Returns the address of the person in the front of the queue */
	function getFirst() constant returns(address) {
		// YOUR CODE HERE
		if (spotsFilled == 0) {
			return address(0);
		}
		return participants[0];
	}
	
	/* Allows `msg.sender` to check their position in the queue */
	function checkPlace() constant returns(uint8) {
		// YOUR CODE HERE
		for (uint8 i = 0; i < spotsFilled; i++) {
			if (participants[i] == msg.sender) {
				return i + 1;
			}
		}
		return 0;
	}
	
	/* Allows anyone to expel the first person in line if their time
	 * limit is up
	 */
	function checkTime() {
		// YOUR CODE HERE
		if (spotsFilled == 0) {
			return;
		}
		if (now > times[0] + limit) {
			TimeLimitReached(participants[0]);
			dequeue();
		}
	}
	
	/* Removes the first person in line; either when their time is up or when
	 * they are done with their purchase
	 */
	function dequeue() {
		// YOUR CODE HERE
		if (spotsFilled != 0) {
			for (uint i = 1; i < spotsFilled; i++) {
				participants[i - 1] = participants[i];
				times[i - 1] = times[i];
			}
			spotsFilled -= 1;
			delete participants[spotsFilled];
			delete times[spotsFilled];
		}
	}

	/* Places `addr` in the first empty position in the queue */
	function enqueue(address addr) {
		// YOUR CODE HERE
		if (spotsFilled < size) {
			participants[spotsFilled] = addr;
			times[spotsFilled] = now;
			spotsFilled += 1;
		}
	}
}
