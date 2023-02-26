//SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

contract EventExample{

    mapping(address => uint) public tokenBalance;

    event TokensSent( address _from, uint _amount );

    function getAddressBalance() public view returns(uint){
        return tokenBalance[msg.sender];
    }

    constructor() {
        tokenBalance[msg.sender] = 100;
    }

    function sendToken( address _to, uint _amount ) public returns (bool) {
        require (tokenBalance[msg.sender] >= _amount, "Not Enough Tokens");
        tokenBalance[msg.sender] -= _amount;
        tokenBalance[_to] += _amount;

        emit TokensSent(msg.sender, _amount);

        return true;
        
    }
}