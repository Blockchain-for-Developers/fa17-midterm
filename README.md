# MIDTERM: My First ICO
Welcome to the Blockchain for Developers DeCal's midterm assignment. You'll be designing your own ICO.

## Midterm Instructions
_Please work with your assigned teammates._

Your task is to complete both `Token.sol` and `Crowdsale.sol` such that they each function as described below. `Queue.sol` is also a necessary data structure contract. Notice that `Token.sol` inherits from `contracts/interfaces/ERC20Interface.sol`.

Implement all three contracts and test them in order to demonstrate your understanding of external calls, timestamping, testing, and everything else learned so far!

**All work should be done in _contracts/Crowdsale.sol_, _contracts/Queue.sol_ and _contracts/Token.sol_. Do not make changes to any other files. The exception to this is for testing: add as many test files as you need, of course**

## Rules
You will be building an ERC20-compliant token platform with a few caveats. Firstly, the token sale will be capped, so there can only be a limited number of tokens in circulation. Tokens can be minted and destroyed (burned), as well as refunded. The crux of the project is to set up a crowdsale where buyers must enter a **Queue**, waiting in line to place their order for tokens. Buyers waiting in line must make sure they are not the last person in line: you must have someone behind you to place a token order!

Details follow:
* `Crowdsale.sol` contract specifications:
	* Must deploy `Token.sol`
	* The contract must keep track of how many tokens have been sold
	* The contract must only sell to/refund buyers between start-time and end-time
	* The contract must forward all funds to the owner after sale is over
	* Owner:
		* Must be set on deployment
		* Must be able to time-cap the sale
			* Must keep track of start-time
			* Must keep track of end-time/time remaining since start-time
		* Must be able to specify an initial amount of tokens to create
		* Must be able to specify the amount of tokens _1 wei_ is worth
		* Must be able to mint new tokens
			* This amount would be added to `totalSupply` in `Token.sol`
		* Must be able to burn tokens not sold yet
			* This amount would be subtracted from `totalSupply` in `Token.sol`
		* Must be able to receive funds from contract after the sale is over
	* Buyers:
		* Must be able to buy tokens directly from the contract and as long as the sale has not ended, if they are first in the queue and there is someone waiting line behind them
			* This would change their balance in `Token.sol`
			* This would change the number of tokens sold
		* Must be able to refund their tokens as long as the sale has not ended. Their place in the queue does not matter
			* This would change their balance in `Token.sol`
			* This would change the number of tokens sold
	* Events:
		* Fired on token purchase
		* Fired on token refund
* `Queue.sol` (this is a first-in-first-out data structure, more info [here](http://interactivepython.org/courselib/static/pythonds/BasicDS/ImplementingaQueueinPython.html)):
	* Must have a finite size, please keep this set to 5
	* Must have a time limit someone can keep their spot in the front; this prevents griefing
	* Must have the following methods:
		* `qsize()`: Returns the number of people waiting in line
		* `empty()`: Returns whether the queue is empty or not
		* `getFirst()`: Returns the address of the person in the front of the queue
		* `checkPlace()`: Allows `msg.sender` to check their position in the queue
		* `checkTime()`: Allows anyone to expel the first person in line if their time limit is up
		* `dequeue()`: Removes the first person in line; either when their time is up or when they are done with their purchase
		* `enqueue(address addr)`: Places `addr` in the first empty position in the queue
	* The queue should only permit buyers to place an order if they are not the only ones in line, i.e. if there is at least one person waiting behind them
	* Events:
		* Fired when someone's time limit is over and they are ejected from the front of the queue
* `Token.sol` contract specifications:
	* Must implement `ERC20Interface.sol` fully
	* Must work in conjunction with `Crowdsale.sol`
		* `totalSupply` would be set on deployment of `Crowdsale.sol`
	* Users:
		* All standard functionality from `ERC20Interface.sol`
		* Must be able to burn their tokens
			* This amount would be subtracted from `totalSupply`
	* Events:
		* All standard events from `ERC20Interface.sol`
		* Fired on buyers burning their tokens

## Minimum Requirements
You have a lot freedom to carry out this assignment as you please. You will be graded on the following:
* At minimum, adhering to the requirements specified above
	* Any additional functionality is a welcome addition
	* If any mathematical operations are necessary, we expect overflow not to be an issue
		* To this end, `contracts/utils/Math.sol` and `contracts/utils/SafeMath.sol` have been provided
* Fully-fleshed out, specific tests
	* Reminder that _Mocha_ tests run **asynchronously**
	* Make sure to group related tests together
	* Use descriptive strings for test cases and assertions

## Extra Credit
* Have the token get more expensive with each purchase. In other words, implement an early-bird incentive
* Enforce a black/white-list of addresses that are/aren't able to participate in the crowdsale
* Provide a use-case contract for your token, something buyers would use it for
	* This could be a small game or another novel use; it doesn't have to be too sophisticated
* [MetaMask](https://metamask.io/) or [frontend integration](https://github.com/ethereum/web3.js/)

## Testing 
You can verify that your smart contract is implemented correctly with `truffle test`. Be sure to have a testrpc server running in a separate terminal.

Refresher: in an empty terminal, run `testrpc` to initialize a default testrpc server. If you get errors, read the [_testrpc_ documentation](https://github.com/ethereumjs/testrpc).

### Truffle Console
If you're having trouble passing the tests and would like to play around with the contracts manually:
1. Run `truffle migrate`
2. Run `truffle console`, This will open up a Node JavaScript console that is connected to your testrpc server

## Submission Instructions
Please fork this repo and push your code up to your fork. Please fill out this Google Form to let us know where you've got your answers: https://goo.gl/forms/KGoAOfsz2QSTyIEy1.

Please feel free to reach out to the staff via Piazza should you run into any trouble.
