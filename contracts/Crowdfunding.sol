// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Crowdfunding {
    address public owner;
    uint public goal;
    uint public totalFunds;
    uint public deadline;
    mapping(address => uint) public contributions;

    constructor(uint _goal, uint _durationInDays) {
        owner = msg.sender;
        goal = _goal;
        deadline = block.timestamp + (_durationInDays * 1 days);
    }

    //  Contribute to the campaign
    function contribute() public payable {
        require(block.timestamp < deadline, "Campaign has ended");
        require(msg.value > 0, "Must send some Ether");
        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;
    }

    //  Check if goal is reached
    function isGoalReached() public view returns (bool) {
        return totalFunds >= goal;
    }

    //  Withdraw funds (only by owner after goal is reached)
    function withdrawFunds() public {
        require(msg.sender == owner, "Only owner can withdraw");
        require(totalFunds >= goal, "Goal not reached yet");
        payable(owner).transfer(address(this).balance);
    }

    // Refund contributors if goal not met and deadline passed
    function refund() public {
        require(block.timestamp > deadline, "Campaign not yet ended");
        require(totalFunds < goal, "Goal was reached, cannot refund");
        uint amount = contributions[msg.sender];
        require(amount > 0, "No contribution to refund");
        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    //  Get remaining time for the campaign
    function getTimeLeft() public view returns (uint) {
        if (block.timestamp >= deadline) return 0;
        return deadline - block.timestamp;
    }
}
