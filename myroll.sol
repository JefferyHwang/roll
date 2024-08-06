// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
    address public manager;
    address[] public participants;
    
    struct Winners {
        address firstPrizeWinner;
        address secondPrizeWinner;
        address thirdPrizeWinner;
    }

    Winners[] public pastWinners;

    event LotteryEntered(address participant);
    event LotteryDrawn(address firstPrizeWinner, address secondPrizeWinner, address thirdPrizeWinner);

    constructor() {
        manager = msg.sender;
    }

    function enterLottery() public {
        require(participants.length < 7, "Lottery is full");
        participants.push(msg.sender);
        emit LotteryEntered(msg.sender);

        if (participants.length == 7) {
            drawLottery();
        }
    }

    function drawLottery() private {
        require(participants.length == 7, "Not enough participants to draw lottery");

        // Simple random selection (not suitable for production)
        uint firstPrizeIndex = random() % participants.length;
        address firstPrizeWinner = participants[firstPrizeIndex];

        // Remove first prize winner from participants list
        participants[firstPrizeIndex] = participants[participants.length - 1];
        participants.pop();

        uint secondPrizeIndex = random() % participants.length;
        address secondPrizeWinner = participants[secondPrizeIndex];

        // Remove second prize winner from participants list
        participants[secondPrizeIndex] = participants[participants.length - 1];
        participants.pop();

        uint thirdPrizeIndex = random() % participants.length;
        address thirdPrizeWinner = participants[thirdPrizeIndex];

        // Record the winners
        pastWinners.push(Winners({
            firstPrizeWinner: firstPrizeWinner,
            secondPrizeWinner: secondPrizeWinner,
            thirdPrizeWinner: thirdPrizeWinner
        }));

        emit LotteryDrawn(firstPrizeWinner, secondPrizeWinner, thirdPrizeWinner);

        // Reset the lottery
        delete participants;
    }

    function random() private view returns (uint) {
        // This is not a secure random number generator. Do not use in production.
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants)));
    }

    function getParticipants() public view returns (address[] memory) {
        return participants;
    }

    function getPastWinners() public view returns (Winners[] memory) {
        return pastWinners;
    }
}
