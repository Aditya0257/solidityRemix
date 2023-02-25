//SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

contract ContractOne {

    mapping(address => uint) public addressBalances;

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function deposit() public payable {
        addressBalances[msg.sender] += msg.value;
    }
}

contract ContractTwo {

    receive() external payable{}

    //this is how we can call any kind of function of a smart contract with specefic call data. 
    // payload is the specefic call data here, which is calling deposit function.

    // for every low level function like in case of sent, we have to check the return value and
    // if its successful, it won't fail.
    // so the way this works is we have actually 2 return values over _contractOne.call{value: 10,... line of code.
    // one return tells us whether the transaction was successful and the other one if there is
    // an actual return over the deposit() function i.e. the function which is being abi.encodeWithSignature() 
    // and being stored as specefic call data. In this case, the deposit function doesn't have any return, it's only
    // public payable, so we only need to see one return to check whether transaction was successful or not.
    function depositOnContractOne(address _contractOne) public { 
       bytes memory payload = abi.encodeWithSignature("deposit()");
    // _contractOne.call{value: 10, gas: 100000}(payload);
    // A boolean success to tell us if the low level call was successful.
       (bool success, ) =_contractOne.call{value: 10, gas: 100000}(payload);
       require(success, "Low level call wasn't successful.");
    }
}

// What does it do? Exactly the same as 21_ExampleContractExternalFunctionCall.sol code, 
// but with low level calls (_contractOne.call) 
// and therefore the typesafety is gone. We have to manually check if success returned is true, 
// otherwise there is no chance that we'll know if the called contract errored out. Interestingly here, 
// it needs slightly more gas as well than the version used in 21_ExampleContractExternalFunctionCall.sol.

// But it can be even one level lower. Because, what if we don't even know the function to all 
// at all. That means, we would need to send the funds to the fallback receive function in ContractOne.



