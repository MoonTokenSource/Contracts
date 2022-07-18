const { MerkleTree } = require("merkletreejs");
const keccak256 = require("keccak256");

let addresses = ["0x22b856cb8e6F074173C238Be35174A122be095bb","0x07890274273f5A5F2604255f201ae68da85dd653"];

// Hash leaves
let leaves = addresses.map((addr) => keccak256(addr));

// Create tree
const merkleTree = new MerkleTree(leaves, keccak256, { sortPairs: true });
let rootHash = merkleTree.getRoot().toString("hex");



function genMerkleRoot() {
    console.log("ssa")
console.log(rootHash);
}

function getProof(address) {
  let hashedAddress = keccak256(address);
  let proof = merkleTree.getHexProof(hashedAddress);
  console.log(proof);
}


genMerkleRoot()

// getProof("0x22b856cb8e6F074173C238Be35174A122be095bb")