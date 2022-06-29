const XYZMoon = artifacts.require("XYZMoon");

module.exports = function (deployer) {
  deployer.deploy(XYZMoon,"0x22b856cb8e6F074173C238Be35174A122be095bb","0x73B61707573e4D14e94622A59cD9981571Eef2c1");
};
