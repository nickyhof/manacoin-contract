pragma solidity ^0.4.23;

contract FulfilmentProcess {

    event FulfilmentProcessStartedEvent(uint256 indexed _processId, address indexed _fromAddress, address indexed _toAddress);
    event FulfilmentProcessCancelledEvent(uint256 indexed _processId);
    event FulfilmentProcessCompletedEvent(uint256 indexed _processId);

    function startProcess(address _fromAddress, address _toAddress) public returns (uint256);

    function cancelProcess(uint256 _processId) public;

    function completeProcess(uint256 _processId) public;

    function isCancellable(uint256 _processId) public returns (bool);

    function isCompleted(uint256 _processId) public returns (bool);
}