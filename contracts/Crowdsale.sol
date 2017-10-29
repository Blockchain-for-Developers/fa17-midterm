pragma solidity ^0.4.15;

import './Queue.sol';
import './Token.sol';

/**
 * @title Crowdsale
 * @dev Contract that deploys `Token.sol`
 * Is timelocked, manages buyer queue, updates balances on `Token.sol`
 */

contract Crowdsale {
	address public 		creator;
	uint 	public 		totalRaised;
	uint 	public 		currentBalence;
	uint 	private 	startingTime;
	uint 	private 	endingTime;
	uint 	public		exchangeRate;
	Token   private		token;
	Queue 	public 		queue;

	event TokenDelivered(address receiver, bool status);
	event EtherRefunded(address receiver, bool status);

	modifier isCreator() {
		require(msg.sender == creator);
		_;
	}

	modifier saleHasEnded() {
		require(now > endingTime);
		_;
	}

	modifier saleHasNotEnded() {
		require(startingTime < now && now < endingTime);
		_;
	}

	function Crowdsale(
		uint256 _exhangeRate, 
		uint256 totalSupply, 
		uint _timeInMinutesForFundraising) 
	{
		startingTime = now;
		endingTime = startingTime + (_timeInMinutesForFundraising * 1 minutes);
		creator = msg.sender;
		exchangeRate = _exhangeRate;
		token = new Token(totalSupply);
		queue = new Queue();
	}

	function mint(uint256 amount) isCreator() {
		token.mint(amount);
	}

	function burn(uint256 amount) isCreator() returns (bool) {
		return token.burn(amount);
	}

	function deliver() payable saleHasNotEnded() returns (bool) {
		uint tokensAmount = msg.value * exchangeRate;

		if (tokensAmount > (token.totalSupply() - totalRaised)) {
			revert();
			return false;
		}

		queue.enqueue(msg.sender, tokensAmount);

		while (queue.checkPlace() > 1) {  // until first in line
			continue;
		}
		require( queue.checkPlace() == 1 );

		queue.checkTime();
		if (queue.checkPlace() == 0) {  // times up
			revert();
			TokenDelivered(msg.sender, false);
			return false;
		}

		while (queue.qsize() < 1) {  // until at least 2 nodes in the queue
			continue;
		}
		queue.dequeue();
		bool success = token.transfer(msg.sender, tokensAmount);
		if (success) {
			currentBalence += msg.value;
		}
		TokenDelivered(msg.sender, success);
		return success;

	}


	function refund(uint256 amount) saleHasNotEnded() returns (bool) {
		bool good = token.refund(msg.sender, amount);
		if (good) {
			good = msg.sender.send(amount*exchangeRate);
		}
		EtherRefunded(msg.sender, good); // event
		return good;
	}

	function withdrawFunds() saleHasEnded() isCreator() returns (bool) {
		return creator.send(currentBalence);
	}

	function () { revert(); }

}
