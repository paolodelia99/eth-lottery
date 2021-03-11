//SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <=0.8.2;

import "@openzeppelin/contracts/utils/Pausable.sol";

contract Lottery is Pausable {

    struct Participant {
        address addr;
    }

    struct LotteryPlay {
        uint256 totalAmount;
        address winner;
        Participant[] participants;
    }

    event LotteryFinished(address winner, uint256 amount);
    event Registered(address participantAddr);

    uint64 public maxParticipant;
    uint128 public currentLottery;
    uint256 public ticketAmount;

    mapping(uint128 => LotteryPlay) lotteries;
    uint randNonce;

    constructor(uint256 _ticketAmount, uint64 _maxParticipants) {
        if (_ticketAmount == 0) {
            ticketAmount = 2 wei;
        } else {
            ticketAmount = _ticketAmount;
        }

        if (_maxParticipants == 0) {
            maxParticipant = 20;
        } else {
            maxParticipant = _maxParticipants;
        }

        currentLottery = 0;

        super._pause();

        initLottery();

        super._unpause();
    }

    function setTicketAmount(uint256 _newTicketAmount) external {
        if (_newTicketAmount != 0) {
            ticketAmount = _newTicketAmount;
        }
    }

    function setMaxParticipants(uint64 _maxParticipants) external {
        require(_maxParticipants != 0, "Participants cannot be zero");

        maxParticipant = _maxParticipants;
    }

    function register() external payable whenNotPaused returns (bool) {
        require(lotteries[currentLottery].participants.length + 1 <= maxParticipant, "No more participants are allowed");
        require(msg.value == ticketAmount, "The ticket value isn't the allowed one");

        lotteries[currentLottery].participants.push(Participant(msg.sender));
        emit Registered(msg.sender);
        return true;
    }

    function initLottery() internal whenPaused {
        require(address(this).balance == 0);
        currentLottery++;
    }

    function getCurrentParticipants() external view returns (uint256) {
        return lotteries[currentLottery].participants.length;
    }

    function runLottery() external {
        require(lotteries[currentLottery].participants.length >= 2, "There must be at least participants");

        super._pause();

        uint64 randomIndex = randMod(lotteries[currentLottery].participants.length);
        address winner = lotteries[currentLottery].participants[randomIndex].addr;
        address payable winnerPayable = address(uint160(winner));

        uint256 winningAmount = address(this).balance;
        if (winningAmount > 0) {
            winnerPayable.transfer(winningAmount);
        }

        lotteries[currentLottery].winner = winner;
        lotteries[currentLottery].totalAmount = winningAmount;

        emit LotteryFinished(winner, winningAmount);

        initLottery();

        super._unpause();
    }

    function randMod(uint256 _modulus) internal returns(uint64) {
        randNonce++;
        return uint64(uint(keccak256(abi.encodePacked(block.timestamp,
            msg.sender,
            randNonce))) % _modulus);
    }

}
