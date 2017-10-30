
const Crowdsale = artifacts.require("./Crowdsale.sol");
const Token = artifacts.require("./Token.sol");

contract('TestToken', function(accounts){
    let token;
    beforeEach(async function() {
        let t = await Token.new(0);
        token = t;
    });

    describe('Test token operations', function(){
        it("Testing minting and burning",  async function() {
          let total = await token.totalSupply.call();
          assert.equal(total , 0, "totalSupply is initialized at 0");
          await token.mint(5);
          total = await token.totalSupply.call();
          console.log(token.totalSupply);
          assert.equal(total , 5, "totalSupply should equal 5");
          await token.burn(2);
          total = await token.totalSupply.call();
          assert.equal(total , 3, "totalSupply should equal 3");
        }),
        it("Testing transfer",  async function() {
          await token.mint(10);
          await token.transfer(accounts[1], 3);
          //console.log(await token.balanceOf(accounts[1]));
          await token.transfer(accounts[2], 4);
          //console.log(await token.balanceOf(accounts[2]));
          total1 = await token.balanceOf(accounts[1]);
          assert.equal(total1 , 3, "address 0 should have 3 in its account");
          total2 = await token.balanceOf(accounts[2]);
          assert.equal(total2 , 4, "address 1 should have 4 in its account");
        })
        it("Testing transferFrom",  async function() {
          await token.mint(10);
          await token.approve(accounts[1], 4);
          assert.equal(token.allowance(accounts[0], accounts[1]) , 4, "address 2 should have 4 in its account");
          await token.transferFrom(accounts[0], accounts[2], 4).call({from: accounts[1]});
          transfered = await token.balanceOf(accounts[2]);
          assert.equal(transfered , 4, "address 2 should have 4 in its account");
        })
    });
});
