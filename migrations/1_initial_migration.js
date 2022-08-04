const SaveTheMoonBSC = artifacts.require("SaveTheMoonBSC");
const MoonMigrate = artifacts.require("MoonMigrator");
const Web3 = require("web3")

const buyLimit = Web3.utils.toWei("200")
const price =  Web3.utils.toWei("0.001")

module.exports = async function (deployer) {

  console.log({buyLimit,price})

  
  await deployer.deploy(SaveTheMoonBSC,
    "0x4d1A12d63379df869ad98bB39A5F226660ac6C88",
    "0x4d1A12d63379df869ad98bB39A5F226660ac6C88")



  await deployer.deploy(
    MoonMigrate,
    SaveTheMoonBSC.address
  );



};
