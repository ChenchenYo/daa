pragma solidity ^0.4.15;


import './ExtraordinaryGA.sol';


contract Dissolution is ExtraordinaryGA {

    uint256 private constant voteTimeInMins = 10;

    function proposeDissolution() public onlyMember onlyDuringGA {
        super.submitProposal(DISSOLUTION, "Dissolution", 0, address(0), voteTimeInMins * 1 minutes);
    }

    function voteForDissolution(uint256 proposalId, bool favor) public onlyMember onlyDuringGA {
        super.voteForProposal(DISSOLUTION, proposalId, favor);
    }

    function concludeProposal(uint256 proposalId) internal {
        concludeVoteForDissolution(proposalId);
    }

    function concludeVoteForDissolution(uint256 proposalId) private {
        // ⅔ have to vote “yes”
        // for * 3 >= (for + against) * 2
        Proposal storage proposal = proposals[DISSOLUTION][proposalId];
        proposal.result = proposal.votesFor * uint(3) >=
            proposal.votesFor.add(proposal.votesAgainst) * uint(2);
    }

}
