pragma solidity ^0.4.23;

import "../node_modules/zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

contract ManaCoin is StandardToken {
    // Public variables
    string public name = "ManaCoin";
    string public symbol = "MANA";
    uint8 public decimals = 18;
    address public collectionAddress;

    // Public Events
    event TradeCreation(uint indexed tradeId, address indexed from, address indexed to, uint value);
    event TradeCompletion(uint indexed tradeId);
    event TradeCancellation(uint indexed tradeId);

    enum TradeStatus { Pending, Completed, Cancelled }

    struct Trade {
        address fromAddress;
        address toAddress;
        uint value;
        TradeStatus status;
    }

    mapping(uint => Trade) public trades;

    function createTrade(uint _tradeId, address _to, uint _value) external {
        require(super.balanceOf(msg.sender) >= _value);

        super.transferFrom(msg.sender, collectionAddress, _value);

        trades[_tradeId] = Trade(msg.sender, _to, _value, TradeStatus.Pending);
        
        emit TradeCreation(_tradeId, msg.sender, _to, _value);
    }

    function cancelTrade(uint _tradeId) external {
        Trade storage trade = trades[_tradeId];

        require(trade.fromAddress == msg.sender || trade.toAddress == msg.sender);
        require(trade.status == TradeStatus.Pending);
        
        super.transferFrom(collectionAddress, trade.fromAddress, trade.value);

        trade.status = TradeStatus.Cancelled;

        emit TradeCancellation(_tradeId);
    }

    function completeTrade(uint _tradeId) external {
        Trade storage trade = trades[_tradeId];

        require(trade.toAddress == msg.sender);
        require(trade.status == TradeStatus.Pending);

        super.transferFrom(collectionAddress, trade.toAddress, trade.value);

        trade.status = TradeStatus.Completed;

        emit TradeCompletion(_tradeId);
    }
}