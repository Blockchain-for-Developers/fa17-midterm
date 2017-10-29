pragma solidity ^0.4.15;

/**
 * @title Queue
 * @dev Data structure contract used in `Crowdsale.sol`
 * Allows buyers to line up on a first-in-first-out basis
 * See this example: http://interactivepython.org/courselib/static/pythonds/BasicDS/ImplementingaQueueinPython.html
 */

contract Queue {

	uint8 size = 5;
	uint timeLimit;
	uint8 currentSize;
	Participant[] ParticipantsList;

	struct Participant {
		address a;
		uint timeStamp;
	}

	function Queue(uint _timeLimit) {
		// initinital constructor
		timeLimit = _timeLimit;
	}

	/* Returns the number of people waiting in line */
	function qsize() constant returns(uint8) {
		return currentSize;
	}

	/* Returns whether the queue is empty or not */
	function empty() constant returns(bool) {
		return (currentSize == 0);
	}

	/* Returns the address of the person in the front of the queue */
	function getFirst() constant returns(address) {
		if (currentSize > 0){
			return ParticipantsList[0].a;
		}
		return address(0);
	}

	/* Allows `msg.sender` to check their position in the queue.
	 * Returns the 1-indexed position of the sender in the line.
	 * If person is not in line, returns 0.
	 */
	function checkPlace() constant returns(uint8) {
		for (uint8 i = 0; i < currentSize; i++) {
			if(ParticipantsList[i].a  == msg.sender) {
				return i;
			}
		}
		return 0;
	}

	/* Allows anyone to expel the first person in line if their time
	 * limit is up
	 */
	function checkTime() {
		if (
			currentSize > 0 &&
			ParticipantsList[0].timeStamp + timeLimit < now)
		{
			dequeue();
		}
	}

	/* Removes the first person in line; either when their time is up or when
	 * they are done with their purchase
	 */
	function dequeue() {
		if (currentSize > 0) {
			delete ParticipantsList[0];
			currentSize = currentSize - 1;
		}
	}

	/* Places `addr` in the first empty position in the queue */
	function enqueue(address addr) {
		if(currentSize >= size){
			return;
		}
		ParticipantsList.push(Participant( addr, now + timeLimit));
		currentSize = currentSize + 1;
	}
}
