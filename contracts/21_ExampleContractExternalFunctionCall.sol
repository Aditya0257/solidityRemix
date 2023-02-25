//SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

// To call smart contracts from other smart contracts and also send a value, as a well as, more gas.
// There are two ways to achieve that:

// External function calls on contract instances
// Low-Level calls on the address

contract ContractOne{

    mapping (address => uint) public addressBalances;

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function deposit() public payable{
        addressBalances[msg.sender] += msg.value;
    }
}

contract ContractTwo{

    // we could also use this deposit function to give value to ContractTwo,
    // but we have used receive() function with low level interactions here.
    // function deposit() public payable {}

    receive() external payable{}

    function depositOnContractOne(address _contractOne) public {
        ContractOne one = ContractOne(_contractOne);
        one.deposit{value: 10, gas: 100000}();
    }
}

// Deploy ContractOne
// Deploy ContractTwo
// Send 1000 wei to ContractTwo using low level Transact button, receive() will catch it.
// if you have created a deposit function in ContractTwo, then can use it.
// Copy ContractOne Address and sent a transaction to 
// ContractTwo.depositOnContractOne with the address from ContractOne.
// You see that the ContractTwo address is the one who deposited the funds
// so , in addressBalances button of ContractOne, copy the address of ContractTwo to check the amount received.
// And you also see that not all 100000 gas were used. The remainder was returned


// WHAT IF WE DON'T KNOW THAT ContractOne IS SMART CONTRACT ?

// The above method only works if you know:

// That the receiving contract is a contract
// And that the receiving contract has a specific function

// Thus, we use another method -> Low-Level Calls on Address-Type Variables