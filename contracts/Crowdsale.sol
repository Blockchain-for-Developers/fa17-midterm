pragma solidity ^0.4.15;

import './Queue.sol';
import './Token.sol';
import './utils/SafeMath.sol';

/**
 * @title Crowdsale
 * @dev Contract that deploys `Token.sol`
 * Is timelocked, manages buyer queue, updates balances on `Token.sol`
 */

contract Crowdsale {
	address public 		creator;
	uint 	public 		totalRaised; // measured in token
	uint 	public 		currentBalence; // measured in wei
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
		uint256 _totalSupply, 
		uint _timeInMinutesForFundraising) 
	{
		startingTime = now;
		endingTime = SafeMath.add(startingTime, SafeMath.mul(_timeInMinutesForFundraising, 1 minutes));
		//endingTime = startingTime + (_timeInMinutesForFundraising * 1 minutes);
		creator = msg.sender;
		exchangeRate = _exhangeRate;
		token = new Token(_totalSupply);
		queue = new Queue(100);
	}



	function mint(uint256 amount) isCreator() {
		token.mint(amount);
	}

	function burn(uint256 amount) isCreator() {
		token.burn(amount);
	}

	function weiToToken(uint256 weiAmount) returns (uint256) {
		return SafeMath.mul(weiAmount, exchangeRate);
	}

	function tokenToWei(uint256 tokenAmount) returns (uint256) {
		return SafeMath.div(tokenAmount, exchangeRate);
	}

	function deliver() payable saleHasNotEnded() returns (bool) {
		uint tokensAmount = weiToToken(msg.value);
		uint difference = SafeMath.sub(token.totalSupply(), totalRaised);
		if (tokensAmount > difference) {
			//revert();
			msg.sender.transfer(msg.value);
			return false;
		}

		queue.enqueue(msg.sender);

		while (queue.checkPlace() > 1) {  // wait until being the first buyer
			continue;
		}
		require(queue.checkPlace() == 1);

		while (queue.qsize() < 1) {  // make sure the buyer always have ppl behind
			queue.checkTime();
			if (queue.checkPlace() == 0) {  // times up
				//revert();
				msg.sender.transfer(msg.value);
				TokenDelivered(msg.sender, false);
				return false;
			}
			continue;
		}
		queue.checkTime();
		if (queue.checkPlace() == 0) {  // times up
			//revert();
			msg.sender.transfer(msg.value);
			TokenDelivered(msg.sender, false);
			return false;
		}
		queue.dequeue();
		bool success = token.transfer(msg.sender, tokensAmount);
		if (success) {
			currentBalence = SafeMath.add(currentBalence, msg.value);
			//currentBalence += msg.value;
		}
		TokenDelivered(msg.sender, success);
		return success;

	}


	function refund(uint256 amount) public saleHasNotEnded() returns (bool) {
		bool good = token.refund(msg.sender, amount);
		if (good) {
			uint256 refundAmount = tokenToWei(amount);
			good = msg.sender.send(refundAmount);
		}
		EtherRefunded(msg.sender, good); // event
		return good;
	}

	function withdrawFunds() public saleHasEnded() isCreator() returns (bool) {
		return creator.send(currentBalence);
	}

	function removeContract() public isCreator() saleHasEnded() {
		selfdestruct(msg.sender);
	}    

	function () { revert(); }

}
