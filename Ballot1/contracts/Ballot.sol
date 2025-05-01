// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ballot {
    // Struct untuk menyimpan data proposal
    struct Proposal {
        string name;   // Nama buah (contoh: "Apel")
        uint voteCount; // Total vote
    }

    // Struct untuk menyimpan data voter
    struct Voter {
        bool registered; // Apakah sudah terdaftar?
        bool voted;      // Apakah sudah voting?
        uint vote;       // Index proposal yang dipilih
    }

    address public chairperson; // Alamat chairperson
    mapping(address => Voter) public voters; // Mapping alamat ke data voter
    Proposal[] public proposals; // Daftar proposal

    // Modifier: Hanya chairperson yang bisa eksekusi
    modifier onlyChairperson() {
        require(msg.sender == chairperson, "Hanya chairperson yang boleh.");
        _;
    }

    // Constructor: Inisialisasi proposal dan tentukan chairperson
    constructor(string[] memory proposalNames) {
        chairperson = msg.sender;
        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    // Fungsi untuk mendaftarkan voter (hanya chairperson)
    function register(address voter) public onlyChairperson {
        require(!voters[voter].registered, "Voter sudah terdaftar.");
        voters[voter].registered = true;
    }

    // Fungsi untuk voting
    function vote(uint proposalIndex) public {
        Voter storage sender = voters[msg.sender];
        require(sender.registered, "Anda belum terdaftar.");
        require(!sender.voted, "Anda sudah voting.");
        require(proposalIndex < proposals.length, "Proposal tidak valid.");

        sender.voted = true;
        sender.vote = proposalIndex;
        proposals[proposalIndex].voteCount += 1;
    }

    // Fungsi untuk melihat pemenang
    function winningProposal() public view returns (uint winningIndex) {
        uint winningVoteCount = 0;
        for (uint i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winningIndex = i;
            }
        }
    }
}