// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract lottery{

    address public manager ;
    address payable[] public players ; 

    constructor() {
        manager = msg.sender;
        
    }

    function alreadyentered() view private returns(bool){
        for(uint i =0;i<players.length;i++){
            if(players[i]==msg.sender)
            return true;
        }
        return false;
    }

    function enter() payable public {
        require(msg.sender != manager , "Manager can not enter");
        require(alreadyentered() == false , "Player already entered");
        require(msg.value>=1 ether,"Minimum amount must be paid");
        players.push(payable(msg.sender));
    }

    function random() view private returns(uint){
        return uint(sha256(abi.encodePacked(block.prevrandao,block.number,players)));
    }

    function pickWinner() public{
        require(msg.sender == manager , "Only manager can pick the winner");
        uint index = random() % players.length;
        address contractAddress = address(this);
        players[index].transfer(contractAddress.balance);
        players = new address payable[](0);

    }
    function getPlayers() view public returns(address payable[] memory){
        return players ;
    } 

}