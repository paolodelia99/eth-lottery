//SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <=0.8.2;

contract Lottery {

    struct Participant {
        address addr;
    }

    struct LotteryPlay {
        uint endBlock;
        uint startBlock;
        bytes32 blockHash;
        address winner;
        Participant[] partecipants;
    }

    event LotteryFinished(address winner, uint256 amount);
    event Registered(address participantAddr);

    uint128 maxParticipant;
    uint currentLottery;
    uint256 ticketAmount;

    mapping(uint => LotteryPlay) lotteries;

    constructor(uint256 _ticketAmount) {
        if (_ticketAmount == 0) {
            ticketAmount = 0.02 ether;
        } else {
            ticketAmount = _ticketAmount;
        }
    }

    function setTicketAmount(uint256 _newTicketAmount) public {
        if (_newTicketAmount != 0) {
            ticketAmount = _newTicketAmount;
        }
    }


}
