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

	modifier isCreator() {
		require(msg.sender == creator);
		_;
	}

	modifier saleHasEnded() {
		require(now > startingTime);
		_;
	}

	modifier saleHasNotEnded() {
		require(now <= startingTime);
		_;
	}	

	function Crowdsale(uint256 _exhangeRate, uint256 totalSupply, uint timeCap) {
		startingTime = now;
		endingTime = startingTime + timeCap;
		creator = msg.sender;
		token = new Token(totalSupply);
		exchangeRate = _exhangeRate;
		queue = new Queue();
	}

	function mint(uint256 amount) isCreator() {
		token.mint(amount);
	}

	function burn(uint256 amount) isCreator() returns (bool) {
		return token.burn(amount);
	}

	function deliver() payable saleHasNotEnded() returns (bool) {
		
	}
	

	function refund(uint256 amount) saleHasNotEnded() returns (bool) {
		bool good = token.refund(msg.sender, amount);
		if (good) {
			good = msg.sender.send(amount);
		}
		return good;
		// RefundCompleted(msg.sender, success); // event
	}

	function withdrawFunds() saleHasEnded() isCreator() returns (bool) {
		return creator.send(currentBalence);
	}

	function () { throw; }

}
