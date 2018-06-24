pragma solidity ^0.4.23;

import "./lib/ERC20Token.sol";
import "./lib/Fulfilment.sol";

contract ManaCoinToken is ERC20Token {

  string public name = "ManaCoin";
  string public symbol = "MANA";
  uint8 public decimals = 18;

  event OrderCreatedEvent(uint256 indexed _orderId, address indexed _buyerAddress, address indexed _sellerAddress, uint256 _amount);
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
    address buyerAddress;
    address sellerAddress;
    uint256 amount;
    uint256 fulfilmentId;
    Fulfilment fulfilment;
    OrderStatus status;
  }

  mapping(uint256 => Order) orders;
  mapping(address => uint256[]) buyerOrders;
  mapping(address => uint256[]) sellerOrders;

  uint256 orderCounter = 0;

  function getBuyerOrderIds(address _buyerAddress) public view returns (uint256[]) {
    return buyerOrders[_buyerAddress];
  }

  function getSellerOrderIds(address _sellerAddress) public view returns (uint256[]) {
    return sellerOrders[_sellerAddress];
  }

  function getOrder(uint256 _orderId) public view returns (address, address, uint256, uint256, address, OrderStatus) {
    Order storage order = orders[_orderId];

    return (order.buyerAddress, order.sellerAddress, order.amount, order.fulfilmentId, order.fulfilment, order.status);
  }

  function createOrder(address _to, uint256 _amount, Fulfilment _fulfilment) public returns (uint256) {
    require(balanceOf(msg.sender) >= _amount);

    uint256 _orderId = orderCounter++;

    increasePending(msg.sender, _amount);

    uint256 _fulfilmentId = _fulfilment.startProcess(msg.sender, _to);

    orders[_orderId] = Order(msg.sender, _to, _amount, _fulfilmentId, _fulfilment, OrderStatus.PENDING);
    
    uint256[] storage _buyerOrderIds = buyerOrders[msg.sender];
    uint _buyerOrderIdsLength = _buyerOrderIds.length++;
    _buyerOrderIds[_buyerOrderIdsLength] = _orderId;

    uint256[] storage _sellerOrderIds = sellerOrders[_to];
    uint _sellerOrderIdsLength = _sellerOrderIds.length++;
    _sellerOrderIds[_sellerOrderIdsLength] = _orderId;

    emit OrderCreatedEvent(_orderId, msg.sender, _to, _amount);

    return _orderId;
  }

  function cancelOrder(uint256 _orderId) public {
    Order storage order = orders[_orderId];

    require(order.status == OrderStatus.PENDING);
    require(order.fulfilment.isCancellable(order.fulfilmentId));
    
    decreasePending(order.buyerAddress, order.amount);

    order.status = OrderStatus.CANCELLED;

    emit OrderCancelledEvent(_orderId);
  }

  function completeOrder(uint256 _orderId) public {
    Order storage order = orders[_orderId];

    require(order.status == OrderStatus.PENDING);
    require(order.fulfilment.isFulfiled(order.fulfilmentId));

    decreasePending(order.buyerAddress, order.amount);
    internalTransferFrom(order.buyerAddress, order.sellerAddress, order.amount);

    order.status = OrderStatus.COMPLETED;

    emit OrderCompletedEvent(_orderId);
  }

  function refundOrder(uint256 _orderId) public {
    Order storage order = orders[_orderId];

    require(order.sellerAddress == msg.sender);
    require(order.status == OrderStatus.COMPLETED);

    internalTransferFrom(order.sellerAddress, order.buyerAddress, order.amount);

    order.status = OrderStatus.REFUNDED;

    emit OrderRefundedEvent(_orderId);
  }
}