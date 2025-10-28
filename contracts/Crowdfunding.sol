// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Crowdfunding {
    address public owner;
    uint public goal;
    uint public totalFunds;

    constructor(uint _goal) {
        owner = msg.sender;
        goal = _goal;
    }

    // 1️⃣ Function to contribute funds
    function contribute() public payable {
        require(msg.value > 0, "Must send some Ether");
        totalFunds += msg.value;
    }

    // 2️⃣ Function to check if goal is reached
    function isGoalReached() public view returns (bool) {
        return totalFunds >= goal;
    }

    // 3️⃣ Function to withdraw funds (only owner)
    function withdrawFunds() public {
        require(msg.sender == owner, "Only owner can withdraw");
        require(totalFunds >= goal, "Goal not reached yet");
        payable(owner).transfer(address(this).balance);
    }
}
