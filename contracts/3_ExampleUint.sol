//SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

contract ExampleUint{

   // uint256 public myUnit; this can store values
   // from 0 - [(2^256)-1]

    uint public myUnit ;

    // uint8 public myUnit8; to save on storage gas cost
    // you need to define smaller ones, but beware there might be 
    // certain side effects down the road if you suddenly have used
    // up the space, the interior space that you can actually use there.
    
    int public myInt = -10;// -2^128 to (+2^128) - 1

    function setMyUnit(uint _myunit) public {
        myUnit = _myunit;
    }

    function incrementInt() public {
        myInt++;
    }

}