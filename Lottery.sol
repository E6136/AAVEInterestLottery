//SPDX-License-Identifier: MIT
pragma solidity ^0.7.5;

import "./IERC20.sol";
import "./ILendingPool.sol";

contract Lottery {
	// the timestamp of the drawing event
	uint public drawing;
	// the price of the ticket in DAI (100 DAI)
	uint ticketPrice = 100e18;
	// the user have already purchased a ticket?
	mapping(address => bool) public hasTicket;

	ILendingPool pool = ILendingPool(0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9);
	IERC20 aDai = IERC20(0x028171bCA77440897B824Ca71D1c56caC55b68A3); 
	IERC20 dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);

	constructor() {
		// we set the drawing date 1 week after the deployment of the contract
        drawing = block.timestamp + 1 weeks;
	}

	/*The purchase method allow partecipants to purchase 
	tickets to enter in the lottery system.
	The purchase function accept DAI in exchange for tickets.
	The ticketPrice is set a 100 DAI.*/
	function purchase() external {
		require(hasTicket[msg.sender] == false, "You have already purchased a ticket.");
		dai.transferFrom(msg.sender, address(this), ticketPrice);
		hasTicket[msg.sender] = true;

        /*As soon as a ticket is purchased, we can start earning interest on it for the lottery 
		depositing the DAI transferred from the user's account into the AAVE pool.*/
		dai.approve(address(pool), ticketPrice);
		pool.deposit(address(dai), ticketPrice, address(this), 0);
	}

	event Winner(address);

	function pickWinner() external {
        
	}
}
