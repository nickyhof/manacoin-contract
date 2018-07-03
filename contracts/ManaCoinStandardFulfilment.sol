pragma solidity ^0.4.23;

import "./lib/Fulfilment.sol";
import "../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol";

/**
 * Standard Fulfilment Process which allows:
 * - fromAddress or toAddress to cancel the order
 * - toAddress to complete the order
 */
contract ManaCoinStandardFulfilment is Fulfilment, Ownable {

  enum FulfilmentStatus {
    STARTED,
    CANCELLED,
    COMPLETED
  }

  struct Fulfilment {
    address fromAddress;
    address toAddress;
    FulfilmentStatus status;
  }

  mapping(uint256 => Fulfilment) public processes;

  uint256 processCounter = 0;
  uint256 fulfilmentFee = 0;

  function getFulfilmentOwner() public returns (address) {
    return owner;
  }

  function getFulfilmentFee() public returns (uint256) {
    return fulfilmentFee;
  }

  function setFulfilmentFee(uint256 _fulfilmentFee) onlyOwner public {
    fulfilmentFee = _fulfilmentFee;
  }

  function startProcess(address _fromAddress, address _toAddress) public returns (uint256) {
    uint256 _processId = processCounter++;

    processes[_processId] = Fulfilment(_fromAddress, _toAddress, FulfilmentStatus.STARTED);

    emit FulfilmentStartedEvent(_processId, _fromAddress, _toAddress);

    return _processId;
  }

  function cancelProcess(uint256 _processId) public {
    Fulfilment storage process = processes[_processId];

    require(process.fromAddress == msg.sender || process.toAddress == msg.sender);
    require(process.status == FulfilmentStatus.STARTED);

    process.status = FulfilmentStatus.CANCELLED;

    emit FulfilmentCancelledEvent(_processId);
  }

  function completeProcess(uint256 _processId) public {
    Fulfilment storage process = processes[_processId];

    require(process.toAddress == msg.sender);
    require(process.status == FulfilmentStatus.STARTED);

    process.status = FulfilmentStatus.COMPLETED;

    emit FulfilmentCompletedEvent(_processId);
  }

  function isCancellable(uint256 _processId) public view returns (bool) {
    Fulfilment storage process = processes[_processId];

    return (process.status == FulfilmentStatus.STARTED);
  }

  function isFulfiled(uint256 _processId) public view returns (bool) {
    Fulfilment storage process = processes[_processId];

    return (process.status == FulfilmentStatus.COMPLETED);
  }
}