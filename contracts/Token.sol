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
  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);
  event Burned(uint256 _value, uint256 _total);

  // Balances for each account
  mapping(address => uint256) private balances;

  // Owner of account approves the transfer of an amount to another account
  mapping(address => mapping (address => uint256)) allowed;

  function Token(uint _totalSupplyAmount) public{
    totalSupply = _totalSupplyAmount;
  }

  function totalToken() public returns (uint256){
    return totalSupply;
  }

  function mint(uint256 _amount) public{
    balances[msg.sender] = balances[msg.sender] + _amount;
    totalSupply = totalSupply + _amount;
  }

  function burn(uint256 _amount) public{
    balances[msg.sender] = balances[msg.sender] - _amount;
    totalSupply = totalSupply - _amount;
    Burned(_amount, totalSupply);
  }

  /// @notice send `_value` token to `_to` from `msg.sender`
  /// @param _to The address of the recipient
  /// @param _value The amount of token to be transferred
  /// @return Whether the transfer was successful or not
  function transfer(address _to, uint256 _value) public returns (bool) {
    if (balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
      balances[msg.sender] -= _value;
      balances[_to] += _value;
      Transfer(msg.sender, _to, _value);
      return true;
    } else {
      return false;
    }
  }

  /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
  /// @param _from The address of the sender
  /// @param _to The address of the recipient
  /// @param _value The amount of token to be transferred
  /// @return Whether the transfer was successful or not
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
    if (balances[_from] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
      if(msg.sender==_from){
        balances[_from] -= _value;
        balances[_to] += _value;
        Transfer(_from, _to, _value);
        return true;
      } else if (allowance(_from, msg.sender)<=_value){
        allowed[_from][msg.sender] -= _value;
        balances[_from] -= _value;
        balances[_to] += _value;
        Transfer(_from, _to, _value);
        return true;
      }
    } else {
      return false;
    }
  }

  function refund(address _from, uint256 _value) public returns (bool success){
    if (balances[_from] >= _value && _value > 0) {
      balances[_from] = balances[_from] - _value;
      return true;
    } else {
      return false;
    }
  }

  /// @param _owner The address from which the balance will be retrieved
  /// @return The balance
  function balanceOf(address _owner) public constant returns (uint256 balance){
    return balances[_owner];
  }

  /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
  /// @param _spender The address of the account able to transfer the tokens
  /// @param _value The amount of tokens to be approved for transfer
  /// @return Whether the approval was successful or not
  function approve(address _spender, uint256 _value) public returns (bool success){
    allowed[msg.sender][_spender]+=_value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

  /// @param _owner The address of the account owning tokens
  /// @param _spender The address of the account able to transfer the tokens
  /// @return Amount of remaining tokens allowed to spent
  function allowance(address _owner, address _spender) public constant returns (uint256 remaining){
    return allowed[_owner][_spender];
  }


}
