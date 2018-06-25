pragma solidity ^0.4.23;

contract Fulfilment {

  event FulfilmentStartedEvent(uint256 indexed _processId, address indexed _fromAddress, address indexed _toAddress);
  event FulfilmentCancelledEvent(uint256 indexed _processId);
  event FulfilmentCompletedEvent(uint256 indexed _processId);

  function startProcess(address _fromAddress, address _toAddress) public returns (uint256);

  function cancelProcess(uint256 _processId) public;

  function completeProcess(uint256 _processId) public;

  function isCancellable(uint256 _processId) public view returns (bool);

  function isFulfiled(uint256 _processId) public view returns (bool);
}