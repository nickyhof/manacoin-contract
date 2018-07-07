pragma solidity ^0.4.23;

contract Fulfilment {

  function getFulfilmentOwner() public returns (address);

  function getFulfilmentFee() public returns (uint256);

  function startProcess(address _fromAddress, address _toAddress) public returns (uint256);

  function cancelProcess(uint256 _processId) public;

  function completeProcess(uint256 _processId) public;

  function isCancellable(uint256 _processId) public view returns (bool);

  function isFulfilled(uint256 _processId) public view returns (bool);
}