var Migrations = artifacts.require("./Migrations.sol");
var ManaCoinToken = artifacts.require("./ManaCoinToken.sol");
var ManaCoinStandardFulfilment = artifacts.require("./ManaCoinStandardFulfilment.sol");

contract('ManaCoinToken', function(accounts) {

  var token;
  var fulfilment;

  var account1;
  var account2;

  beforeEach(async () => {
    token = await ManaCoinToken.new();
    fulfilment = await ManaCoinStandardFulfilment.new();

    account1 = accounts[1];
    account2 = accounts[2];

    await token.mint(account1, 500);
    await token.mint(account2, 10);
  });

  it("test initial balances in each account", async () => {
    let account1Balance = await token.balanceOf(account1);
    let account2Balance = await token.balanceOf(account2);

    assert.equal(account1Balance.valueOf(), 500);
    assert.equal(account2Balance.valueOf(), 10);
  });

  describe("Order", function() {
    it("test create an order", async () => {
      await token.createOrder.sendTransaction(account2, 200, fulfilment.address, {from: account1});

      let buyerOrderIds = await token.getBuyerOrderIds(account1).valueOf();
      let sellerOrderIds = await token.getSellerOrderIds(account2).valueOf();

      let account1Balance = await token.balanceOf(account1);
      let account1PrendingBalance = await token.pendingBalanceOf(account1);
      let account2Balance = await token.balanceOf(account2);

      assert.equal(buyerOrderIds.length, 1);
      assert.equal(buyerOrderIds[0].valueOf(), 0);
      assert.equal(sellerOrderIds.length, 1);
      assert.equal(sellerOrderIds[0].valueOf(), 0);
      assert.equal(account1Balance.valueOf(), 300);
      assert.equal(account1PrendingBalance.valueOf(), 200);
      assert.equal(account2Balance.valueOf(), 10);
    });
    
    it("test create an order will all tokens", async () => {
      await token.createOrder.sendTransaction(account2, 500, fulfilment.address, {from: account1});

      let account1Balance = await token.balanceOf(account1);
      let account1PrendingBalance = await token.pendingBalanceOf(account1);
      let account2Balance = await token.balanceOf(account2);

      assert.equal(account1Balance.valueOf(), 0);
      assert.equal(account1PrendingBalance.valueOf(), 500);
      assert.equal(account2Balance.valueOf(), 10);
    });

    it("test cancel order from buyer account", async () => {
      let orderId = await token.createOrder.call(account2, 500, fulfilment.address, {from: account1});
      await token.createOrder.sendTransaction(account2, 500, fulfilment.address, {from: account1});
      await token.cancelOrder.sendTransaction(orderId, false, {from: account1});

      let account1Balance = await token.balanceOf(account1);
      let account1PrendingBalance = await token.pendingBalanceOf(account1);
      let account2Balance = await token.balanceOf(account2);

      assert.equal(account1Balance.valueOf(), 500);
      assert.equal(account1PrendingBalance.valueOf(), 0);
      assert.equal(account2Balance.valueOf(), 10);
    });

    it("test cancel order from seller account", async () => {
      let orderId = await token.createOrder.call(account2, 500, fulfilment.address, {from: account1});
      await token.createOrder.sendTransaction(account2, 500, fulfilment.address, {from: account1});
      await token.cancelOrder.sendTransaction(orderId, false, {from: account2});

      let account1Balance = await token.balanceOf(account1);
      let account1PrendingBalance = await token.pendingBalanceOf(account1);
      let account2Balance = await token.balanceOf(account2);

      assert.equal(account1Balance.valueOf(), 500);
      assert.equal(account1PrendingBalance.valueOf(), 0);
      assert.equal(account2Balance.valueOf(), 10);
    });

    it("test complete order", async () => {
      let orderId = await token.createOrder.call(account2, 500, fulfilment.address, {from: account1});
      await token.createOrder.sendTransaction(account2, 500, fulfilment.address, {from: account1});

      let order = await token.getOrder(orderId);
      let fulfilmentId = order[3];
      await fulfilment.completeProcess.sendTransaction(fulfilmentId, {from: account2});

      await token.completeOrder.sendTransaction(orderId, {from: account2});

      let account1Balance = await token.balanceOf(account1);
      let account1PrendingBalance = await token.pendingBalanceOf(account1);
      let account2Balance = await token.balanceOf(account2);

      assert.equal(account1Balance.valueOf(), 0);
      assert.equal(account1PrendingBalance.valueOf(), 0);
      assert.equal(account2Balance.valueOf(), 510);
    });

    it("test refund order", async () => {
      let orderId = await token.createOrder.call(account2, 500, fulfilment.address, {from: account1});
      await token.createOrder.sendTransaction(account2, 500, fulfilment.address, {from: account1});

      let order = await token.getOrder(orderId);
      let fulfilmentId = order[3];
      await fulfilment.completeProcess.sendTransaction(fulfilmentId, {from: account2});

      await token.completeOrder.sendTransaction(orderId, {from: account2});

      await token.refundOrder.sendTransaction(orderId, {from: account2});

      let account1Balance = await token.balanceOf(account1);
      let account1PrendingBalance = await token.pendingBalanceOf(account1);
      let account2Balance = await token.balanceOf(account2);

      assert.equal(account1Balance.valueOf(), 500);
      assert.equal(account1PrendingBalance.valueOf(), 0);
      assert.equal(account2Balance.valueOf(), 10);
    });
  });
});
