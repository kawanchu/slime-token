pragma solidity ^0.4.24;
import 'zeppelin-solidity/contracts/token/ERC20/StandardToken.sol';

contract SlimeToken is StandardToken {
  string public name = 'SlimeToken';
  string public symbol = 'SLM';
  uint public decimals = 18;

  constructor(uint initialSupply) public {
    totalSupply_ = initialSupply;
    balances[msg.sender] = initialSupply;
  }
}
