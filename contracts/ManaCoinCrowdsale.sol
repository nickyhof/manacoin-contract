pragma solidity ^0.4.23;

import "./ManaCoinToken.sol";
import "../node_modules/zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "../node_modules/zeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol";

contract ManaCoinCrowdsale is TimedCrowdsale, RefundableCrowdsale {

  function ManaCoinCrowdsale
  (
    uint256 _openingTime,
    uint256 _closingTime,
    uint256 _rate,
    uint256 _goal,
    address _wallet,
    ManaCoinToken _token
  )
  public
  Crowdsale(_rate, _wallet, _token)
  TimedCrowdsale(_openingTime, _closingTime)
  RefundableCrowdsale(_goal)
  {

  }
}