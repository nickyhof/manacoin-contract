pragma solidity ^0.4.23;

import "./lib/Fulfilment.sol";
import "../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol";

/**
 * Standard Fulfilment Process which allows:
 * - buyer or seller to cancel the order
 * - seller to complete the order
 */
contract ManaCoinStandardFulfilment is Fulfilment, Ownable {

  event FulfilmentStartedEvent(uint256 indexed _processId, address indexed _buyerAddress, address indexed _sellerAddress);
  event FulfilmentCancelledEvent(uint256 indexed _processId);
  event FulfilmentCompletedEvent(uint256 indexed _processId);

  enum FulfilmentStatus {
    STARTED,
    CANCELLED,
    FULFILLED
  }

  struct Fulfilment {
    address buyerAddress;
    address sellerAddress;
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

  function startProcess(address _buyerAddress, address _sellerAddress) public returns (uint256) {
    uint256 _processId = processCounter++;

    processes[_processId] = Fulfilment(_buyerAddress, _sellerAddress, FulfilmentStatus.STARTED);

    emit FulfilmentStartedEvent(_processId, _buyerAddress, _sellerAddress);

    return _processId;
  }

  function cancelProcess(uint256 _processId) public {
    Fulfilment storage process = processes[_processId];

    require(process.buyerAddress == tx.origin || process.sellerAddress == tx.origin);
    require(process.status == FulfilmentStatus.STARTED);

    process.status = FulfilmentStatus.CANCELLED;

    emit FulfilmentCancelledEvent(_processId);
  }

  function completeProcess(uint256 _processId) public {
    Fulfilment storage process = processes[_processId];

    require(process.sellerAddress == msg.sender);
    require(process.status == FulfilmentStatus.STARTED || process.status == FulfilmentStatus.CANCELLED);

    process.status = FulfilmentStatus.FULFILLED;

    emit FulfilmentCompletedEvent(_processId);
  }

  function isCancellable(uint256 _processId) public view returns (bool) {
    Fulfilment storage process = processes[_processId];

    return (process.status == FulfilmentStatus.STARTED);
  }

  function isFulfilled(uint256 _processId) public view returns (bool) {
    Fulfilment storage process = processes[_processId];

    return (process.status == FulfilmentStatus.FULFILLED);
  }
}