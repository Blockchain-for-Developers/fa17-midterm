pragma solidity ^0.4.15;

import './Queue.sol';
import './Token.sol';
import './utils/SafeMath.sol';

/**
 * @title Crowdsale
 * @dev Contract that deploys `Token.sol`
 * Is timelocked, manages buyer queue, updates balances on `Token.sol`
FROM GITHUB:
Must deploy Token.sol
The contract must keep track of how many tokens have been sold
The contract must only sell to/refund buyers between start-time and end-time
The contract must forward all funds to the owner after sale is over
Owner:
	Must be set on deployment
	Must be able to time-cap the sale
	Must keep track of start-time
	Must keep track of end-time/time remaining since start-time
	Must be able to specify an initial amount of tokens to create
	Must be able to specify the amount of tokens 1 wei is worth
	Must be able to mint new tokens
		This amount would be added to totalSupply in Token.sol
	Must be able to burn tokens not sold yet
		This amount would be subtracted from totalSupply in Token.sol
	Must be able to receive funds from contract after the sale is over
Buyers:
	Must be able to buy tokens directly from the contract and as long as the sale has not ended, if they are first in the queue and there is someone waiting line behind them
		This would change their balance in Token.sol
		This would change the number of tokens sold
	Must be able to refund their tokens as long as the sale has not ended. Their place in the queue does not matter
		This would change their balance in Token.sol
		This would change the number of tokens sold
Events:
	Fired on token purchase
	Fired on token refund
 */

contract Crowdsale {
	// YOUR CODE HERE
	address _owner;
	uint start_time;
	uint tokenSupply;
	uint tokenPrice;

	Token token;

	//Ensure that tokenPrice is in wei
	function Crowdsale (uint time_cap, uint initTokenSupply, uint initTokenPrice){
		_owner = tx.origin;
		//I can imagine this will matter, might have to be block.number+constant
		assert (time_cap > block.number);

		start_time 	= block.number;
		tokenSupply = initTokenSupply;
		tokenPrice	= initTokenPrice;
		token = new Token();
	}

	function mintTokens(uint numTokensToAdd) {
		//THIS IMPLIES THAT TOKEN.SOL MUST SPECIFY ITS OWNER
		token.tokenSupply.add(numTokensToAdd);
	}

	function burnTokens(uint numTokensToBurn) {
		//THIS IMPLIES THAT TOKEN.SOL MUST SPECIFY ITS OWNER
		//assert(numTokensToBurn< NUM_UNSOLD_TOKENS);
		token.tokenSupply.sub(numTokensToAdd);
	}

	function redeemFunds() {
		assert(msg.sender == _owner);
		//_owner.transfer(this.balance);
	}
}
