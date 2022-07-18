const SaveTheMoon = artifacts.require("SaveTheMoon");
const MoonPresale = artifacts.require("MoonPresale");
const Web3 = require("web3")

const buyLimit = Web3.utils.toWei("200")
const price =  Web3.utils.toWei("0.001")

module.exports = async function (deployer) {

  console.log({buyLimit,price})

  // await deployer.deploy(
  //   SaveTheMoon,
  //   "0x22b856cb8e6F074173C238Be35174A122be095bb",
  // );



  await deployer.deploy(
    MoonPresale,
    "0xff5e42a80B505E0B1131E788f968ECe4b78A27BA",
    buyLimit,
    price
  );


};
