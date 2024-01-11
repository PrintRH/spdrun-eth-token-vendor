pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract YourToken is ERC20, Ownable {
	constructor() ERC20("Gold", "GLD") {
		_mint(msg.sender, 1000 * 10 ** 18);
	}
}
