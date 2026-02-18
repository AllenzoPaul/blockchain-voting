// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting {

    address public admin;
    uint public candidateCount;
    bool public electionStarted;
    bool public electionEnded;


    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    modifier onlyRegistered() {
        require(isRegistered[msg.sender], "Not registered");
        _;
    }

    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    event CandidateAdded(uint id, string name);
    event VoterRegistered(address voter);
    event ElectionStarted();
    event ElectionEnded();
    event Voted(address voter, uint candidateId);

    mapping (uint => Candidate) public candidates;
    mapping (address => bool) public isRegistered;
    mapping (address => bool) public hasVoted;

    function addCandidate(string memory _name) public onlyAdmin {
        require(!electionStarted, "Election already started");

        candidateCount++;
        candidates[candidateCount] = Candidate(candidateCount, _name, 0);

        emit CandidateAdded(candidateCount, _name);
    }

    function registerVoter(address _voter) public onlyAdmin {
        require(!electionStarted, "Election already started");
        require(!isRegistered[_voter], "Already registered");


        isRegistered[_voter] = true;

        emit VoterRegistered(_voter);
    }

    function startElection() public onlyAdmin {
        require(!electionStarted, "Election already started");
        electionStarted = true;

        emit ElectionStarted();
    }

    function endElection() public onlyAdmin {
        require(electionStarted, "Election not started");
        require(!electionEnded, "Election already ended");

        electionEnded = true;
        
        emit ElectionEnded();
    }

    function vote(uint _candidateId) public onlyRegistered {
        require(electionStarted, "Election not started");
        require(!electionEnded, "Election already ended");
        require(!hasVoted[msg.sender], "Already voted");
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate");

        hasVoted[msg.sender] = true;
        candidates[_candidateId].voteCount++;
        

        emit Voted(msg.sender, _candidateId);   
    }
}   