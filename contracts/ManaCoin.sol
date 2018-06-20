pragma solidity ^0.4.23;

import "../node_modules/zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

contract ManaCoin is StandardToken {
    // Public variables
    string public name = "ManaCoin";
    string public symbol = "MANA";
    uint8 public decimals = 18;
}