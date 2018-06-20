describe("ManaCoin", function() {
  this.timeout(0);
  
  before(function(done) {
    this.timeout(0);
    
    var contractsConfig = {
      "ManaCoin": {
        args: []
      }
    };
    EmbarkSpec.deployAll(contractsConfig, () => { done() });
  });

  it("should have initial total supply zero", async function() {
    let result = await ManaCoin.methods.totalSupply().call();
    assert.equal(result, 0);
  });

});
