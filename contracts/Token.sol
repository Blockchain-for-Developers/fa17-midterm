pragma solidity ^0.4.15;

import './interfaces/ERC20Interface.sol';

/**
 * @title Token
 * @dev Contract that implements ERC20 token standard
 * Is deployed by `Crowdsale.sol`, keeps track of balances, etc.
 */

contract Token is ERC20Interface {
	// YOUR CODE HERE

	// we need functions from token including following:
	// 	- token.mint(amount);
	// 	- token.burn(amount);
	// 	- token.totalSupply()
	// 	- token.transfer(msg.sender, tokensAmount);
	// 	- token.refund(msg.sender, amount);
	// 	---> these 5 functions
}
