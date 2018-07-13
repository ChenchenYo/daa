/**
 * @title Library to calculate and verify the voting duration.
 * @dev  The contract should inherate the methods of SafteMath.
 */
pragma solidity ^0.4.21;

import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol"; 

library TimedLib {
    
    /**
     *@dev This function checks whether the number sits in between the minimum and maximum number.
     *@notice This function can be used for time/duration/number...
     */
    function isInside(uint256 _currentBlockTime, uint256 _start, uint256 _end) pure internal returns (bool) {
        //@TODO Whether pass the block.timestamp as parameter into the function? There might be a delay for the transaction, 
        //      meaning the current timestamp is late comparing to the moment where the query is asked.
        if (_currentBlockTime >= _start && _currentBlockTime <= _end) {
            return true;
        } else {
            return false;
        }
    }

    /**
     *@title Check whether the proposal is finished or no
     *@notice When the end time is passed, some activites such as conclusion is thereby activated.
     */
    function isFinished(uint256 _currentTime, uint256 _end) pure internal returns (bool) {
        if (_currentTime > _end) {
            return true;
        } else {
            return false;
        }
    }
}