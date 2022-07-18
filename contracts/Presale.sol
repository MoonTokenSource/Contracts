pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MoonPresale is Ownable {
    using SafeERC20 for IERC20;
    IERC20 public immutable MOON;

    bool public isParticipationEnabled;
    bool public isClaimEnabled;

    uint256 public maxBuyLimit;

    mapping(address => uint256) public participation;
    mapping(address => uint256) public tokensToBeClaim;

    bytes32 public merkleRoot;

    uint256 public immutable tokenPrice;

    event onParticipate(uint256 busdAmount, uint256 tokenAmount);
    event onTokenClaimed(uint256 tokenAmount);

    constructor(
        IERC20 _MOON,
        uint256 _maxBuyLimit,
        uint256 _tokenPrice
    ) {
        MOON = _MOON;
        maxBuyLimit = _maxBuyLimit;
        tokenPrice = _tokenPrice;
    }

    function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
        merkleRoot = _merkleRoot;
    }

    function checkValidity(bytes32[] calldata _merkleProof)
        public
        view
        returns (bool)
    {
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(
            MerkleProof.verify(_merkleProof, merkleRoot, leaf),
            "Incorrect proof"
        );
        return true;
    }

    function participate(bytes32[] calldata _merkleProof) public payable {
        require(isParticipationEnabled, "participation not enabled");
        require(msg.value > 0, "invalid amount");
        checkValidity(_merkleProof);
        participation[msg.sender] += msg.value;
        uint256 tokenAmount = ETHToMoon(msg.value);
        tokensToBeClaim[msg.sender] += tokenAmount;
        require(
            tokensToBeClaim[msg.sender] <= maxBuyLimit,
            "Max buy limit exceeds"
        );

        emit onParticipate(msg.value, tokenAmount);
    }

    function setMaxBuyLimit(uint256 amount) public onlyOwner {
        maxBuyLimit = amount;
    }

    function ETHToMoon(uint256 ethAmount) public view returns (uint256) {
        return (ethAmount * 1e18) / tokenPrice;
    }

    function claimToken() public {
        require(isClaimEnabled, "Claim not enabled");
        uint256 tokenAmount = tokensToBeClaim[msg.sender];
        tokensToBeClaim[msg.sender] = 0;
        MOON.safeTransfer(msg.sender, tokenAmount);
        emit onTokenClaimed(tokenAmount);
    }

    function flipParticipationEnabled() public onlyOwner {
        isParticipationEnabled = !isParticipationEnabled;
    }

    function flipClaimEnabled() public onlyOwner {
        isClaimEnabled = !isClaimEnabled;
    }

    function withdrawToken(IERC20 token) public onlyOwner {
        token.safeTransfer(msg.sender, token.balanceOf(address(this)));
    }

    function withdrawETH() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }
}
