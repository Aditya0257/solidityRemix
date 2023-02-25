//SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

contract ExampleMapping{

    mapping(uint => bool) public myMapping;
    mapping(address => bool) public myAddressMapping;
    mapping(uint => mapping(uint => bool)) public uintUintBoolMapping;

    // this happens internally with public visibility specifier written in 
    //first line of code-> public myMapping
    // function myMapping(uint _key) public view returns(bool){
    //     return myMapping[_key];
    // }
    
    function setValue(uint _index) public {
        myMapping[_index] = true;
    }

    function setMyAddressToTrue() public {
        myAddressMapping[msg.sender] = true;
    }

    function setUintUintBoolMapping(uint _key1, uint _key2, bool _value) public {
        uintUintBoolMapping[_key1][_key2] = _value;
    }

}