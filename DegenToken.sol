// 1. Minting new tokens: The platform should be able to create new tokens and distribute them to players as rewards. 
// Only the owner can mint tokens.
// 2.Transferring tokens: Players should be able to transfer their tokens to others.
// 3.Redeeming tokens: Players should be able to redeem their tokens for items in the in-game store.
// 4.Checking token balance: Players should be able to check their token balance at any time.
// 5.Burning tokens: Anyone should be able to burn tokens, that they own, that are no longer needed.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {

    // Mapping to store the token cost associated with each prize
    mapping(uint256 => uint256) private prizeCosts;

    // Mapping to store the redeemed prizes for each player
    mapping(address => uint256[]) private playerPrizes;

    // Constructor function, executed once upon contract deployment
    constructor(address initialOwner) ERC20("Degtoken", "DGN") Ownable(initialOwner) {
        // Mint initial tokens for the contract deployer
        _mint(initialOwner, 85);

        // Set the token costs for each prize (assumed prize IDs start from 1)
        prizeCosts[1] = 10; // Prize ID 1 costs 10 tokens
        prizeCosts[2] = 20; // Prize ID 2 costs 20 tokens
        prizeCosts[3] = 30; // Prize ID 3 costs 30 tokens
    }

    // Function to create and distribute new tokens; only accessible to the owner
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Function to redeem a prize by burning tokens equivalent to the prize's cost
    function redeem(uint256 prizeId) public {
        // Validate the prize ID
        require(prizeId > 0, "Prize ID must be valid");
        require(prizeCosts[prizeId] > 0, "Prize does not exist");

        uint256 cost = prizeCosts[prizeId];

        // Ensure the sender has enough tokens to redeem the prize
        require(balanceOf(msg.sender) >= cost, "Not enough tokens");

        // Burn tokens equal to the cost of the prize
        _burn(msg.sender, cost);

        // Assign the redeemed prize to the player
        playerPrizes[msg.sender].push(prizeId);

        // Emit the redemption event
        emit PrizeRedeemed(msg.sender, prizeId, cost);
    }

    // Function to allow token transfers between players
    function transferTokens(address recipient, uint256 amount) public {
        // Validate the recipient and transfer amount
        require(recipient != address(0), "Recipient address cannot be zero");
        require(amount > 0, "Transfer amount must be positive");
        require(balanceOf(msg.sender) >= amount, "Insufficient tokens");

        // Execute the transfer
        _transfer(msg.sender, recipient, amount);
    }

    // Function to check the balance of an account
    function checkTokenBalance(address account) public view returns (uint256) {
        return balanceOf(account);
    }

    // Function to check redeemed prizes for a player
    function checkRedeemedPrizes(address player) public view returns (uint256[] memory) {
        return playerPrizes[player];
    }

    // Function to burn tokens, reducing the sender's balance
    function burnTokens(uint256 amount) public {
        // Validate the amount to burn
        require(amount > 0, "Burn amount must be positive");
        require(balanceOf(msg.sender) >= amount, "Insufficient tokens");

        // Burn the specified amount of tokens
        _burn(msg.sender, amount);
    }

    // Event emitted upon successful prize redemption
    event PrizeRedeemed(address indexed account, uint256 prizeId, uint256 cost);
}


        
     
