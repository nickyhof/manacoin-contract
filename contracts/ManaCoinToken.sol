pragma solidity ^0.4.23;

import "./ERC20/ERC20Token.sol";
import "./fulfilment/FulfilmentProcess.sol";

contract ManaCoinToken is ERC20Token {

  string public name = "ManaCoin";
  string public symbol = "MANA";
  uint8 public decimals = 18;

  event OrderCreatedEvent(uint256 indexed _orderId, address indexed _fromAddress, address indexed _toAddress, uint256 _value);
  event OrderCancelledEvent(uint256 indexed _orderId);
  event OrderCompletedEvent(uint256 indexed _orderId);
  event OrderRefundedEvent(uint256 indexed _orderId);

  enum OrderStatus {
    PENDING,
    COMPLETED,
    CANCELLED,
    REFUNDED
  }

  struct Order {
    address fromAddress;
    address toAddress;
    uint256 value;
    uint256 fulfilmentProcessId;
    FulfilmentProcess fulfilmentProcess;
    OrderStatus status;
  }

  mapping(uint256 => Order) public orders;

  uint256 orderCounter = 0;

  function createOrder(address _to, uint256 _value, FulfilmentProcess _fulfilmentProcess) public {
    require(super.balanceOf(msg.sender) >= _value);

    uint256 _orderId = orderCounter++;

    super.increasePending(msg.sender, _value);

    uint256 _fulfilmentProcessId = _fulfilmentProcess.startProcess(msg.sender, _to);

    orders[_orderId] = Order(msg.sender, _to, _value, _fulfilmentProcessId, _fulfilmentProcess, OrderStatus.PENDING);

    emit OrderCreatedEvent(_orderId, msg.sender, _to, _value);
  }

  function cancelOrder(uint256 _orderId) public {
    Order storage order = orders[_orderId];

    require(order.status == OrderStatus.PENDING);
    require(order.fulfilmentProcess.isCancellable(order.fulfilmentProcessId));
    
    super.decreasePending(order.fromAddress, order.value);

    order.fulfilmentProcess.completeProcess(order.fulfilmentProcessId);
    order.status = OrderStatus.CANCELLED;

    emit OrderCancelledEvent(_orderId);
  }

  function completeOrder(uint256 _orderId) public {
    Order storage order = orders[_orderId];

    require(order.status == OrderStatus.PENDING);
    require(order.fulfilmentProcess.isCancellable(order.fulfilmentProcessId));

    super.decreasePending(order.fromAddress, order.value);
    super.internalTransferFrom(order.fromAddress, order.toAddress, order.value);

    order.fulfilmentProcess.cancelProcess(order.fulfilmentProcessId);
    order.status = OrderStatus.COMPLETED;

    emit OrderCompletedEvent(_orderId);
  }

  function refundOrder(uint256 _orderId) public {
    Order storage order = orders[_orderId];

    require(order.toAddress == msg.sender);
    require(order.status == OrderStatus.COMPLETED);

    super.internalTransferFrom(order.toAddress, order.fromAddress, order.value);

    order.status = OrderStatus.REFUNDED;

    emit OrderRefundedEvent(_orderId);
  }
}