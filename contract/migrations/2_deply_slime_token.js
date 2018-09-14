const SlimeToken = artifacts.require('./SlimeToken.sol');

module.exports = (deployer) => {
  var initialSupply = 50000e18;
  deployer.deploy(SlimeToken, initialSupply);
}
