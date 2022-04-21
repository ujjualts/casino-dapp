//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Casino {
    address public owner;
    uint256 public minimumBet;
    uint256 public totalBet;
    uint256 public numberOfBets;
    uint256 public maxAmountOfBets = 100;
    address[] public players;

    struct Player {
        uint256 amountBet;
        uint256 numSelected;
    }

    mapping(address => Player) public playerInfo;

    constructor(uint256 _minBet) {
        owner = msg.sender;
        if (_minBet != 0) minimumBet = _minBet;
    }

    function checkPlayerExists(address player) public constant returns(bool){
        for(uint256 i=0;i<players.length;i++){
            if(player == players[i]) return true;
        }
        return false;
    }

    function kill() public {
        if(msg.sender == owner){
            selfdestruct(owner);
        }
    }

    function bet(uint256 numberSelected) public payable {
        require(!checkPlayerExists(msg.sender));
        require(numSelected >=1 && numberSelected <=10);
        playerInfo[msg.sender].amountBet = msg.value;
        playerInfo[msg.sender].numSelected = numSelected;
        numberOfBets++;
        players.push(msg.sender);
        totalBet += msg.value;
    } 

    function distributePrizes(uint256 numberWinner) public {
        address[100] memory winners;
        uint256 count = 0;
         for(uint256 i = 0; i < players.length; i++){
         address playerAddress = players[i];
         if(playerInfo[playerAddress].numberSelected == numberWinner){
            winners[count] = playerAddress;
            count++;
         }
         delete playerInfo[playerAddress]; // Delete all the players
      }
      players.length = 0; // Delete all the players array
      uint256 winnerEtherAmount = totalBet / winners.length; // How much each winner gets
      for(uint256 j = 0; j < count; j++){
         if(winners[j] != address(0)) // Check that the address in this fixed array is not empty
         winners[j].transfer(winnerEtherAmount);
      }
   }
}

    function generateNumberWinner() public {
        uint256 numberGenerated =  block.number % 10 + 1;
        distributePrizes(numberGenerated);
    }

}
