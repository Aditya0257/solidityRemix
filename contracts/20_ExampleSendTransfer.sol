//SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

// transfer function will throw an error when transfer fails.
// send function will return a boolean.
contract Sender{

    receive() external payable{}

    function withdrawTransfer(address payable _to) public {
        _to.transfer(10);
    }

    function withdrawSend(address payable _to) public {
        bool isSent = _to.send(10);

        require(isSent, "Sending the funds was unsuccessful");
    }
}

contract ReceiverNoAction{

    function balance() public view returns(uint) {
        return address(this).balance;
    }

    receive() external payable{}
}

contract ReceiverAction{
    // It costs a lot of gas, when you are writing to a storage variable
    // for the first time.
    // this one is writing to a storage variable, gas consumption is much higher
    // than ReceiverNoAction contract where there is no storage variable.
    uint public balanceReceived;

    receive() external payable{
        balanceReceived += msg.value;
    }

    function balance() public view returns(uint) {
        return address(this).balance;
    }
}

// Deploy the Sender contract
// fund the Sender contract with some 100 wei (hit transact to let it go to the receive function)
// Deploy the ReceiverNoAction and copy the contract address
// Send 10 wei to the ReceiverNoAction wiht withdrawTransfer. It works, 
// because the function receive in ReceiverNoAction doesn't do anything and doesn't use up more than 2300 gas
// Send 10 wei to the ReceiverNoAction with withdrawSend. It also works, 
// because the function still does not need more than 2300 gas.
// Deploy the ReceiverAction Smart contract and copy the contract address
// Send 10 Wei to the ReceiverAction with withdrawTransfer. It fails, 
// because the contract tries to write a storage variable which costs too much gas.
// Send 10 Wei to the ReceiverAction with withdrawSend. The transaction 
// doesn't fail, but it also doesn't work, which leaves you now in an odd state. 👈🏻 That's the Problem right here.
// so we use require and check for the bool value, and return a message when it is false.



