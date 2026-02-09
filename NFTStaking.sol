// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract NFTStaking is Ownable, ReentrancyGuard {
    IERC721 public immutable nftCollection;
    IERC20 public immutable rewardToken;

    uint256 public rewardRatePerHour = 10 * 10**18; // 10 Tokens per hour

    struct Stake {
        uint248 tokenId;
        uint256 timestamp;
        address owner;
    }

    mapping(uint256 => Stake) public vault;

    constructor(address _nft, address _reward) Ownable(msg.sender) {
        nftCollection = IERC721(_nft);
        rewardToken = IERC20(_reward);
    }

    function stake(uint256[] calldata tokenIds) external nonReentrant {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            uint256 id = tokenIds[i];
            require(nftCollection.ownerOf(id) == msg.sender, "Not owner");

            nftCollection.transferFrom(msg.sender, address(this), id);
            vault[id] = Stake(uint248(id), block.timestamp, msg.sender);
        }
    }

    function unstake(uint256[] calldata tokenIds) external nonReentrant {
        uint256 reward = 0;
        for (uint256 i = 0; i < tokenIds.length; i++) {
            uint256 id = tokenIds[i];
            Stake memory deposited = vault[id];
            require(deposited.owner == msg.sender, "Not your NFT");

            reward += calculateReward(deposited.timestamp);
            delete vault[id];
            nftCollection.transferFrom(address(this), msg.sender, id);
        }
        if (reward > 0) rewardToken.transfer(msg.sender, reward);
    }

    function calculateReward(uint256 startTime) public view returns (uint256) {
        uint256 timeElapsed = block.timestamp - startTime;
        return (timeElapsed * rewardRatePerHour) / 3600;
    }

    function setRewardRate(uint256 _newRate) external onlyOwner {
        rewardRatePerHour = _newRate;
    }
}
