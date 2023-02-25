//SPDX-License-Identifier: MIT

pragma solidity 0.7.0;

contract ExampleExceptionRequire{

    mapping (address => uint) public balanceReceived;

    function receiveMoney() public payable{
        balanceReceived[msg.sender] += msg.value;
    }

    function withdrawMoney(address payable _to, uint _amount) public {
        // here, if you try to withdraw higher amount than the received amount, nothing happens.
        // to make the contract more user friendly, so that it tells the user that input wasn't valid to 
        // withdraw for higher amount and shows error message, we use `require` rather than `if`.

        // if (_amount <= balanceReceived[msg.sender]){
        //     balanceReceived[msg.sender] -= _amount;
        //     _to.transfer(_amount);
        // }
        
         require (_amount <= balanceReceived[msg.sender], "Not enough funds, aborting!");
         balanceReceived[msg.sender] -= _amount;
         _to.transfer(_amount);

         //require is for input validation, so it'll use up gas untill it hits the require statement
         //and then it'll return the rest of the gas. suppose, you give 4 million gas to a smart contract
         // but if untill require, it only uses 1 million, then it'll give back rest 3 millin gas.
    }
}