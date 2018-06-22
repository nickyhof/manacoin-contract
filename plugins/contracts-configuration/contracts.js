var BigNumber = require('bignumber.js');
var Web3 = require('web3');

module.exports = function(embark) {
  if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
  } else {
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:7545"));
  }

  const accounts = web3.eth.accounts;

  const openingTime = new Date().getTime(); // now
  const closingTime = openingTime + 86400 * 7; // 7 days
  const rate = new BigNumber(1000);
  const wallet = accounts[0];

  embark.events.on("contractsDeployed", function() {
    embark.logger.info("Using wallet address for ManaCoinCrowdsale:" + wallet);
  });
  
  embark.registerContractConfiguration({
    "default": {
      "contracts": {
        "SafeMath": {
          "deploy": false
        },
        "Ownable": {
          "deploy": false
        },
        "BasicToken": {
          "deploy": false
        },
        "StandardToken": {
          "deploy": false
        },
        "MintableToken": {
          "deploy": false
        },
        "ERC20Token": {
          "deploy": false
        },
        "FulfilmentProcess": {
          "deploy": false
        },
        "StandardFulfilmentProcess": {
          "args": []
        },
        "ManaCoinToken": {
          "args": []
        },
        "Crowdsale": {
          "deploy": false
        },
        "ManaCoinCrowdsale": {
          "args": [
            openingTime,
            closingTime,
            rate,
            wallet,
            "$ManaCoinToken"
          ]
        }
      }
    }
  });
}