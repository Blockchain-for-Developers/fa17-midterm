pragma solidity ^0.4.15;

/**
 * @title Queue
 * @dev Data structure contract used in `Crowdsale.sol`
 * Allows buyers to line up on a first-in-first-out basis
 * See this example: http://interactivepython.org/courselib/static/pythonds/BasicDS/ImplementingaQueueinPython.html
 */

contract Queue {


	uint8 size = 5;
	uint8 curSize;
	uint timeLimit;
	participant[] participantsList;

	struct participant{
		address a;
		uint timeLimit;
	}

	function Queue(uint  _timeLimit) {
		timeLimit = _timeLimit;
	}

	/* Returns the number of people waiting in line */
	function qsize() constant returns(uint8) {
		return curSize;
	}

	/* Returns whether the queue is empty or not */
	function empty() constant returns(bool) {
		return curSize == 0;
	}

	/* Returns the address of the person in the front of the queue */
	function getFirst() constant returns(address) {
		if(curSize == 0){
			return address(0);
		}
		return participantsList[0].a;
	}

	/* Allows `msg.sender` to check their position in the queue */
	function checkPlace() constant returns(uint8) {
		for(uint8 i = 0; i < curSize; i++){
			if(participantsList[i].a  == msg.sender){
				return i;
			}
		}
		revert();
	}

	/* Allows anyone to expel the first person in line if their time
	 * limit is up
	 */
	function checkTime() {
		if(participantsList[0].timeLimit < now){
			dequeue();
		}
	}

	/* Removes the first person in line; either when their time is up or when
	 * they are done with their purchase
	 */
	function dequeue() {
		delete participantsList[0];
		curSize = curSize - 1;
		if(curSize> 0){
			participantsList[0].timeLimit = now + timeLimit;
		}
	}

	/* Places `addr` in the first empty position in the queue */
	function enqueue(address addr) {
		if(curSize >= size - 1){
			return;
		}
		participantsList.push(participant( addr, now + timeLimit));
		curSize = curSize + 1;
	}
}
