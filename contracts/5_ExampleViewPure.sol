//SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

contract ExampleViewPure{

    uint public myStorageVariable;
    //in view, local data of the contract can be accessed.
    function getMyStorageVariable() public view returns(uint){
        return myStorageVariable;
    }

    //in pure, only data given inside parameter can be accessed.
    function getAddition(uint a, uint b) public pure returns(uint){
        return a + b;
    }

    function setMyStorageVariable(uint _newVar) public returns(uint){
        myStorageVariable = _newVar;
        return _newVar;
    }
}