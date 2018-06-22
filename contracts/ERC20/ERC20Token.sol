pragma solidity ^0.4.23;

import "../../node_modules/zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";

contract ERC20Token is MintableToken {

  mapping(address => uint256) pending;

  function increasePending(address _owner, uint256 _addedValue) public {
    pending[_owner] = pending[_owner].add(_addedValue);
  }

  function decreasePending(address _owner, uint256 _subtractedValue) public {
    require(_subtractedValue <= pending[_owner]);

    pending[_owner] = pending[_owner].sub(_subtractedValue);
  }

  /**
    * Internal function to transfer from one address to another without approval
    */
  function internalTransferFrom(address _from, address _to, uint256 _value) internal {
    require(_to != address(0));
    require(_value <= balanceOf(_from));

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);

    emit Transfer(_from, _to, _value);
  }

  /**
    * Overrides BasicToken.transfer
    * Checks that the specified address has a valid balance
    */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_value <= balanceOf(msg.sender));

    return super.transfer(_to, _value);
  }

  /**
    * Overrides StandardToken.transferFrom
    * Checks that the specified address has a valid balance
    */
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_value <= balanceOf(_from));
    
    return super.transferFrom(_from, _to, _value);
  }

  /**
    * Overrides BasicToken.balanceOf
    * Subtracts pending balance from owner balance
    */
  function balanceOf(address _owner) public view returns (uint256) {
    return balances[_owner].sub(pending[msg.sender]);
  }
}