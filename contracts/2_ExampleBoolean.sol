//SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

contract ExampleBoolean{

    //we cant do anything with this because we have no function
    //we have no interface to interact with this smart contract
    //our boolean is also not public meaning solidity will not
    //automatically create a getter function for it.
    // bool myBool;
    
    bool public myBool;

    function setMyBool(bool _myBool) public {
        myBool = _myBool;
    }

}