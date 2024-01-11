pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
	YourToken public yourToken;
	uint256 public constant tokensPerEth = 100;

	event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
	event SellTokens(
		address seller,
		uint256 amountOfTokens,
		uint256 amountOfETH
	);

	constructor(address tokenAddress) {
		yourToken = YourToken(tokenAddress);
	}

	fallback() external payable {}

	receive() external payable {}

	function buyTokens() public payable {
		address sender = msg.sender;
		uint256 amountOfTokens = msg.value * tokensPerEth;
		require(msg.value > 0, "Insufficient ETH to Purchase BGB");
		yourToken.transfer(sender, amountOfTokens);
		emit BuyTokens(sender, msg.value, amountOfTokens);
	}

	// ToDo: create a withdraw() function that lets the owner withdraw ETH
	function withdraw() public payable onlyOwner {
		(bool success, ) = msg.sender.call{ value: address(this).balance }("");
		require(success, "Not Owner!");
	}

	// ToDo: create a sellTokens(uint256 _amount) function:
	function sellTokens(uint256 amount) public {
		uint256 amountOfEthForSeller = amount / tokensPerEth;

		// check to prevent negative or zero values
		require(amount > 0, "Please enter amount more than 0");

		// check to ensure seller has enough tokens to sell
		require(
			yourToken.balanceOf(msg.sender) >= amount,
			"Insufficient balance to sell"
		);

		// check to ensure vendor has enough tokens to sell
		require(
			address(this).balance >= amountOfEthForSeller,
			"Insufficient liquidity in Vendor to perform sale"
		);

		bool success = yourToken.transferFrom(
			msg.sender,
			address(this),
			amount
		);
		require(success, "Failed to transfer token to Vendor");
		payable(msg.sender).transfer(amountOfEthForSeller);
		emit SellTokens(address(this), amount, amountOfEthForSeller);
	}
}
