# NFT Staking Rewards Engine

This repository contains a high-performance smart contract system for NFT gamification and DeFi. Users can stake their NFTs to accumulate rewards over time based on a fixed emission rate.

## Architecture
* **Staking Contract**: Handles the secure locking of NFTs and tracks "time-staked" metadata.
* **Reward Token**: A standard ERC-20 token minted as an incentive for stakers.
* **Calculation Logic**: Uses a linear reward accumulation model to ensure fair distribution and gas efficiency.

## Features
* **Batch Staking**: Stake multiple NFTs in a single transaction to save gas.
* **Emergency Withdraw**: Safety mechanism for users to retrieve assets in unforeseen scenarios.
* **Adjustable Emissions**: Owner can tune reward rates to manage tokenomics.

## Setup
1. Deploy `RewardToken.sol`.
2. Deploy `NFTStaking.sol` using the Reward Token and NFT Collection addresses.
3. Transfer/Mint rewards to the Staking contract.
