//SPDX-License-Identifier: MIT

pragma solidity 0.8.18;


// Assert is used to check invariants. Those are states our contract or variables should never reach, ever. 
// For example, if we decrease a value then it should never get bigger, only smaller.

contract ExceptionExample{
    
    // if you send 257 wei as the value to receiveMoney() function, since msg.value is of uint8 type
    // it'll only take till { 0 to [ 2^(8) - 1 ] } i.e. 0 to 255, so 256 th will become 0 and 257 will become 1.
    // so balanceReceived function will show uint8: 1 value.

    // Asserts are here to check states of your Smart Contract that should never be violated. For example: a 
    // balance can only get bigger if we add values or get smaller if we reduce values.

    mapping(address => uint8) public balanceReceived;

    function receiveMoney() public payable {
        assert(msg.value == uint8(msg.value));
        balanceReceived[msg.sender] += uint8(msg.value);
        assert(balanceReceived[msg.sender] >= uint8(msg.value));
    }

    // but unlike require, assert consume all 
    // the gas which was given to run the smart contract.
    function withdrawMoney(address payable _to, uint8 _amount) public {
        require(_amount <= balanceReceived[msg.sender], "Not enough funds, aborting!");

        assert(balanceReceived[msg.sender] >= balanceReceived[msg.sender] - _amount);
        balanceReceived[msg.sender] -= _amount;

        _to.transfer(_amount);
    }
}

