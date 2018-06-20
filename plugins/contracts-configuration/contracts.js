var BigNumber = require('bignumber.js');

module.exports = function(embark) {
  const openingTime = new Date().getTime(); // now
  const closingTime = openingTime + 86400 * 7; // 7 days
  const rate = new BigNumber(1000);
  const wallet = "0xEC93BD200068f380C12db8311eC524f22719f634";
  
  embark.registerContractConfiguration({
    "default": {
      "contracts": {
        "SafeMath": {
          "deploy": false
        },
        "BasicToken": {
          "deploy": false
        },
        "StandardToken": {
          "deploy": false
        },
        "Crowdsale": {
          "deploy": false
        },
        "ManaCoin": {
          "args": []
        },
        "ManaCoinCrowdsale": {
          "args": [
            openingTime,
            closingTime,
            rate,
            wallet,
            "$ManaCoin"
          ]
        }
      }
    }
  });
}