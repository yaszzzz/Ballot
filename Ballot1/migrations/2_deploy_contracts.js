const Ballot = artifacts.require("Ballot");
module.exports = function (deployer) {
  deployer.deploy(Ballot, ["Apel", "Mangga", "Jeruk", "Pisang"]);
};