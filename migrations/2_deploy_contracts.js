var ManaCoinStandardFulfilment = artifacts.require("./ManaCoinStandardFulfilment.sol");
var ManaCoinToken = artifacts.require("./ManaCoinToken.sol");
var ManaCoinCrowdsale = artifacts.require("./ManaCoinCrowdsale.sol");

module.exports = function(deployer, network, accounts) {
  if (network == 'development') {
    const openingTime = web3.eth.getBlock('latest').timestamp + 30; // 30 seconds in the future
    const closingTime = openingTime + 86400 * 7; // 7 days
    const rate = new web3.BigNumber(1000);
    const wallet = accounts[0];
  
    return deployer
      .then(() => {
        return deployer.deploy(ManaCoinStandardFulfilment);
      })
      .then(() => {
        return deployer.deploy(ManaCoinToken);
      })
      .then(() => {
        return deployer.deploy(
          ManaCoinCrowdsale,
          openingTime,
          closingTime,
          rate,
          wallet,
          ManaCoinToken.address
        );
      });
  } else {
    console.error("Unknown network:", network);
  }
};