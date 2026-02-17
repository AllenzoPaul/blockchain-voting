// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting {

    address public admin;
    uint public candidateCount;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    mapping (uint => Candidate) public candidates;
    mapping (address => bool) public isRegistered;
    mapping (address => bool) public hasVoted;

    function addCandidate(string memory _name) public onlyAdmin {
        require(!electionStarted, "Election already started");

        candidateCount++;
        candidates[candidateCount] = Candidate(candidateCount, _name, 0);

        emit CandidateAdded(candidateCount, _name);
    }
    
}