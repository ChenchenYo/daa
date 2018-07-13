# Decentralised Autonomous Association Switzerland – DAAS

This document describes the technical specifications of the DAAS project with a minimum introduction to the background.

- [Decentralised Autonomous Association Switzerland – DAAS](#decentralised-autonomous-association-switzerland-%E2%80%93-daas)
    - [Goal](#goal)
    - [Architecture](#architecture)
    - [Concerns](#concerns)
            - [GA Proposal](#ga-proposal)
                - [Propose a new delegate](#propose-a-new-delegate)

## Goal

The goal of this project is to create a decentralized autonomous association (DAO) that represents digitally and legitimely a Swiss association. 

The description is architecture agnostic but aims at being implemented on the Ethereum public blockchain.

## Architecture

### contracts

1. Membership management

   1. Accessible contract [Abstract]: Holds the structure of membership system. Three roles exists in the sytem: delegate, member, whitelister.
      i.e. There are one delegate who represents legally the association; Members who can propose and vote for proposals of the association; Whitelisters, who have the write to promote new members upon thorough examination of their identities (either online or offline).
   2. Membership contract: Defines actual functionalities that each role can do. 
2. Proposal management

    1. MinimalProposal [Abstract]: Holds the common pattern of all the proposals that belong to the two sub-categories - normal proposal and administrative proposal (aka. GA proposal). The list of all the proposals is stored inside a mapping in such contract. Proposals have limited period that is allowed to be open, this information is calculated via the library *TallyClerk*.
    2. ProposalManager: Creation / voting and other operations on proposals are conducted via this contract. The conclusion of the proposal is calculated with logic inside *TallyClerk* contract.
    3. ProposalInterface: an interface that allows other ocntracts communicate with each other.
3. General Assembly (GA): The GA is described in the GAManager contract, where historical and future GAs are saved inside this contract.
4. Treasury
    1. Treasury: The portal that manages all the financial operations of the DAAS.
    2. Wallet: Wallet that holds contribution from members. 
    3. ExternalWallet: Wallet that holds the depositiion from external companies who want to sponsor one or many project/proposal(s). The wallet holds the money until the such project and Please beware that no GA proposal accepts sponsorships.
5. DAA: contract deployer and address manager. 

### Functions

| Name of functions                | startingTime  | endingTime  | candidate     | proposedGADate | proposedStatute | internalWallet  | externalWallet  | wait for GA to set up voting time? |
| -------------------------------- | ------------- | ----------- | ------------- | -------------- | --------------- | --------------- | --------------- | ---------------------------------- |
| createDelegateCandidancyProposal | 0             | 0           | msg.sender    | 0              | ""              | 0x0             | 0x0             | Yes                                |
| createGADateProposal             | _votingStarts | _votingEnds | 0x0           | _proposedTime  | ""              | 0x0             | 0x0             | No                                 |
| createDissolutionProposal        | 0             | 0           | 0x0           | 0              | ""              | 0x0             | 0x0             | Yes                                |
| createUpdateStatuteProposal      | 0             | 0           | 0x0           | 0              | _newHash        | 0x0             | 0x0             | Yes                                |
| createExpelMemberProposal        | _startingTime | _endingTime | _targetMember | 0              | ""              | 0x0             | 0x0             | No                                 |
| createUpdateWalletProposal       | 0             | 0           | 0x0           | 0              | ""              | _internalWallet | _externalWallet | Yes                                |



## Concerns

### Upgradability and flexibility

Current DAAS hard coded almost all the possible administrative operations (marked as GA proposals), giving little flexibility to the association themselves to design their operations schemes. This aspect needs to be improved under Swiss legislation framework, to make sure that each action the association or the member of such association takes is complied with the Swiss regulation. For instance, the frequency of GA, the limitation of responsibility, etc. This gives us reason to limit certain degree of freedom from the association. However, we shall also bear in mind that the regulation may change when time passes by. These parameters (or even more) need to be adapted accordingly.  

It is necessary to define the scope of potential changes in our case, in order to find the right balance between upgradability and cost optimization. The scope is guided by the current Swiss legal system. Future change in the legal system may happen and there have no view on the speed, nor the direction of such potential pivot. Such incertainty is not included in the archtecture design.  If in any day, a drastic change in the legal system is presented, the DAAS cannot

### Security of the organization

Some possible attack vectors (e.g. double spending, theft, or signature forgery) need to be thoroughly considered during the architecture design of the system. Double spending and theft could be solved with the best practice for dApp architecture design and robust coding logics inherintly. However, the signature forgery needs to be further discussed: There are more than one approach to solve such problem:

- heritage model: Each user could point another user to inherit his property (his role in the association, his )
- Activity model: If a user was not actively participating any voting/initiating voting/paying membership for some time (duration TBD, e.g. 2 years), this account should then be on hold (freeze account). His absence is not counted in the quorum in voting. A whitelisted/ the delegate can freeze the account or release it. 

### GA Proposal

#### Propose a new delegate

1. What if there are multiple proposals for the
2. Difference between "step down and propose delegate" and "propose new delegate". The former one implies the current delegate is no longer in charge of the DAO, aka delegate = 0x0. In this case, the association is operating without legal representative, therefore payout is no longer active (There is a need of having a main valve in the Tresury contract for such purpose). The latter one allows a election happening before the current term finishes. 
3. When the new delegate proposal is ready to be initiated. a check on the starting time is needed
   1. In the latter case, since such election is preventive, there is a need to chek a minimum time gap between the two similar proposals. 
   2. In the first case, the election is very emergent. If the initiator is the delegate, there is no need to respect the time gap. 
4. Everyone can propose their candidancy at any time, but one can only propose the candidancy for the next election that will happen at the next closest GA. If the next GA is scheduled in one month and the second next is scheduled in 1 year, one cannot propose his delegate candidancy directly for the one in 1 year and skipping the current one. The proposal for candidacy does not need to be during GA, but before the GA.
5. When multiple people want to propose their candidancy, each of their candidancy has their own proposalID. All these proposalIDs are under the category of "delegateCandidancy". Members, during GA, can only vote for one of these open "Candidancy proposals".
6. What is the quorum for such delegate candiate proposal? Minimum participant numbers or/and minimum number in favor of the proposal?
7. What if the member who supposed to be elected as new delegate is got expelled via a GA proposal at the same time?
8. Can / Is it compulsary to propose delegate candidancy at GA?

#### Vote for proposals at GA

1. Who sets the order of the opening proposals?  (accroding to the order in the array?) The first one starts its voting slot as long as the clock hits the GA starting time.
2. Whether the member can decide the duration of the extraordinary GA? 
3. All the voting happens during GA lasts for 10 minutes?
4. The quorum: vote yes number is based on the participant number, or it is based on the total number?

#### Proposal for extraordinary GA and GA

Although an emergant GA can be initiated and set by the DAA members, there's a standard time for such extraordinary GA. Limited to 60 minutes? 

1. What if a GA proposal is still under voting phase, but the GA is over.? How to match the timing??

#### Dissolution 

What will happen exactly when dissolution??

#### Update

1. When changing the statute, is changed during one GA, is it effective directly?
2. To which extent is changing the quorum / voting procedure / logics possible? If the association has completely the freedom to take these actions, it makes even more sense to disassemble the structure even more (c.f. DAOstack)

#### Expel member

1. What if the expelled member has several on-going proposals? (to become delegate or to withdraw certain amount of money)
2. Will the membership contribution also be refunded?
3. Right now we allow to expel whitelister because if the whitelister can also be a member. If the whitelister is 
4. Delegate cannot be expelled directly. If one wants delegate be out of the association, there are some options:

- Proposese candidate delegate and got selected
- Step down voluntarily (and propose GA)

5. 

#### Membership fee

Is the membership compulsory or voluntary? Do we allow voluntary contribution (with extra amount)? Does the amount depend on the position or strictly same fee or there is a minimum contribution then the more it donates.

Further steps, to introduce the stake/token, the heavier the stake/vote weight it has.

Is it refundable? 

### Ordinary proposal

Is it possible to be destructed before it’s concluded by the owner?
External donation can only be accepted when the proposal is created (open and before it becomes concludable nor concluded). No need to be votable.

### GA

1. What is the minimum time interval for such kind of extraordinary GA: Frequency and length ? What are the criteria for ordinary (annual) GAs? Is there any other regulation for the time distance between extra- and ordinary GA? 
2. If there any obligation for delegate to have annual GA?
3. For both kinds of GA, is there any limits of timing? e.g. I can plan for max. in two years.

## Procedure

### Steps for deployment

1. Finished deployment for all the concrete contracts.
   1. Membership 
   2. Proposal
   3. GAManager
   4. Wallet
   5. ExternalWallet
   6. Treasury
2. Finished deployment for DAA
3. Transfer ownership from deployer to DAA contract.
4. Call finishDeployment function in DAA contract.

### Steps to set up a GA

1. We need to run the *prepareForGA()* first, so that all the special proposals are set with an apropiate starting and closing time.

   1. Delegate candidancy proposal:

      Each candidate is represented by one proposal. Therefore, all the candidancy propsals need to be open at the same time, so that members can choose which to vote for. 

## Undergoing Development

1. proposal discharge? = step down and propose GA?
2. check whether implemented: at the absence of delegate, disable payout.
3. Fix the conclusion of delegate candidate proposal
4. Fix the setup of quorum
5. **Fix the proposeDelegateCandidancy: ProposalManager.sol (line 369)**
6. check the magic constant across all contracts
7. Check the ProposalManager. If moving some structs and quorum calculation to TallyClerkLib and ActionLib is reasonable?
8. Hash important information for function inputs and outputs.