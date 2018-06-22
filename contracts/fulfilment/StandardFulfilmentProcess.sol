pragma solidity ^0.4.23;

import "./FulfilmentProcess.sol";

/**
 * Standard Fulfilment Process which allows:
 * - fromAddress or toAddress to cancel the order
 * - toAddress to complete the order
 */
contract StandardFulfilmentProcess is FulfilmentProcess {

  enum FulfilmentStatus {
    STARTED,
    CANCELLED,
    COMPLETED
  }

  struct FulfilmentProcess {
    address fromAddress;
    address toAddress;
    FulfilmentStatus status;
  }

  mapping(uint256 => FulfilmentProcess) public processes;

  uint256 processCounter = 0;

  function startProcess(address _fromAddress, address _toAddress) public returns (uint256) {
    uint256 _processId = processCounter++;

    processes[_processId] = FulfilmentProcess(_fromAddress, _toAddress, FulfilmentStatus.STARTED);

    emit FulfilmentProcessStartedEvent(_processId, _fromAddress, _toAddress);

    return _processId;
  }

  function cancelProcess(uint256 _processId) public {
    FulfilmentProcess storage process = processes[_processId];

    require(process.fromAddress == msg.sender || process.toAddress == msg.sender);
    require(process.status == FulfilmentStatus.STARTED && process.status != FulfilmentStatus.COMPLETED);

    process.status = FulfilmentStatus.CANCELLED;

    emit FulfilmentProcessCancelledEvent(_processId);
  }

  function completeProcess(uint256 _processId) public {
    FulfilmentProcess storage process = processes[_processId];

    require(process.toAddress == msg.sender);
    require(process.status == FulfilmentStatus.STARTED && process.status != FulfilmentStatus.CANCELLED);

    process.status = FulfilmentStatus.COMPLETED;

    emit FulfilmentProcessCompletedEvent(_processId);
  }

  function isCancellable(uint256 _processId) public returns (bool) {
    FulfilmentProcess storage process = processes[_processId];

    return (process.status == FulfilmentStatus.STARTED) && (process.status != FulfilmentStatus.COMPLETED);
  }

  function isCompleted(uint256 _processId) public returns (bool) {
    FulfilmentProcess storage process = processes[_processId];

    return (process.status == FulfilmentStatus.COMPLETED);
  }
}