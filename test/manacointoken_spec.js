describe("ManaCoinToken", function() {
  this.timeout(0);
  
  before(function(done) {
    this.timeout(0);
    
    var contractsConfig = {
      "ManaCoinToken": {
        args: []
      }
    };
    EmbarkSpec.deployAll(contractsConfig, () => { done() });
  });

  it("should have initial total supply zero", async function() {
    let result = await ManaCoinToken.methods.totalSupply().call();
    assert.equal(result, 0);
  });

});
