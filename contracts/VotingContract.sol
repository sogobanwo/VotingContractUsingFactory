// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract VotingPoll {
    address public creator;
    string public electionName;
    string[] public candidates;
    mapping(address => bool) public hasVoted;

    event VoteCasted(address indexed voter, uint indexed candidateIndex);

    modifier onlyCreator() {
        require(msg.sender == creator, "Only the creator can perform this action");
        _;
    }

    modifier hasNotVoted() {
        require(!hasVoted[msg.sender], "You have already voted in this poll");
        _;
    }

    constructor(string memory _electionName, string[] memory _candidates) {
        creator = msg.sender;
        electionName = _electionName;
        candidates = _candidates;
    }

    function vote(uint candidateIndex) external hasNotVoted {
        require(candidateIndex < candidates.length, "Invalid option index");

        hasVoted[msg.sender] = true;

        emit VoteCasted(msg.sender, candidateIndex);
    }
}

contract PollFactory {
    address[] public polls;

    event PollCreated(address indexed pollAddress, address indexed creator);

    function createPoll(string memory electionName, string[] memory candidates) external {
        VotingPoll newPoll = new VotingPoll(electionName, candidates);
        polls.push(address(newPoll));

        emit PollCreated(address(newPoll), msg.sender);
    }

    function getPolls() external view returns (address[] memory) {
        return polls;
    }
}
