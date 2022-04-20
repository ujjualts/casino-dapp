//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Casino {
    address public owner;

    constructor {
        owner = msg.sender;
    }

    function kill() public {
        if(msg.sender == owner){
            selfdestruct(owner);
        }
    }

}
