//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract ExampleMappingWithdrawals{

    mapping(address=>uint) public balanceReceived;

    function sendMoney() public payable {
        balanceReceived[msg.sender] += msg.value;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
    function withdrawAllMoney(address payable _to) public {
        // _to.transfer(balanceReceived[msg.sender]);
        // balanceReceived[msg.sender] = 0;
        // // _to.transfer(getBalance());
        // this _to function can sometimes again call the function so, its not preferred
        // to do balanceReceived[msg.sender] = 0 after calling _to. , so we write this line of code
        // before _to. function, in this way - :

        uint balanceToSendOut = balanceReceived[msg.sender];
        balanceReceived[msg.sender] = 0;
        _to.transfer(balanceToSendOut);

    }

}