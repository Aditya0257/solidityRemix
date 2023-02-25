//SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

contract SampleFallback{

    uint public lastValueSent;
    
    string public lastFunctionCalled;

    uint public myUint;

    function setMyUint(uint _myNewUint) public {
        myUint = _myNewUint;
    }

    // when you called setMyUint function to set myUint value to 2.
    // input code -> 0xe492fd840000000000000000000000000000000000000000000000000000000000000002

    // first 4 bytes ( 8 hex characters ) -> e492fd84 -> function's signature keccak hash-> here it is :-
    // "setMyUint(uint256)" -  functions signature
    // this is how internally EVM understands that what kind of function it should call that is the identifier.

    // you can actually write the above input code in low level transaction and press transact -> your myUint will update.
    // but suppose you change the function signature code and dont write it as per its format, then CALLDATA won't understand it.
    // it'll then not call setMyUint function, this will directly go to fallback function, since it doesn't know, where to go.

    // when you deploy this smart contract , and then enter certain value in Wei and go to low level interactions -> CALLDATA, 
    // without entering any data, you click on Transact button, the receive function which 
    // has payable is called and it takes the value which was entered before going to low level interactions
    // in wei, and displays it below lastValueSent blue button in deployed contracts.
    // and lastFunctionCalled shows string: receive.

    receive() external payable {
        lastValueSent = msg.value;
        lastFunctionCalled = "receive";
    }

    // if you are pressing transact button after entering some data in CALLDATA, then receive function doesn't work
    // you have to use fallback function -> which literally acts as backup.
    // if you have both receive and fallback function in same smart contract, then whenever data is entered in CALLDATA,  
    // then fallback function is called, and whenever without any data, transact button is pressed, receive function is called.
    // if there is no receive function then in both cases - data entered or left empty, fallback function is called.
    

    fallback() external payable {
        lastValueSent = msg.value;
        lastFunctionCalled = "fallback";
    }

}