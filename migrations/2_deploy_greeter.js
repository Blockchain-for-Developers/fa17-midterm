var Queue = artifacts.require("./Queue.sol");
var Crowdsale = artifacts.require("./Token.sol");
var Token = artifacts.require("./Crowdsale.sol");

module.exports = function(deployer) {
    deployer.deploy(Queue);
    deployer.deploy(Crowdsale);
    deployer.deploy(Token);
};
