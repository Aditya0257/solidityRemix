//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

// Child Smart Contract
contract Wallet{

    PaymentReceived public payment;

    function payContract() public payable {
        //object of contract
        payment = new PaymentReceived(msg.sender, msg.value);
    }
}

// here, 2 contracts are made, when you click on payContract payable button
// in deployed contract - Wallet Contract, firstly, the payContract() function is called which 
// calls Payment Received contract to store its new instance in payment variable.
// The PaymentReceived Contract is called then, which has a constructor, which is executed at beginning
// , it asks for _from and _amount, thats why at time of calling PaymentReceived, msg.sender and msg.value
// has been given, constructor takes these values and store them in address and uint.

// In the payment function in Wallet contract (getter function since public), what will be returned?
// it is of PaymentReceived type, so it returns address and then with this address, we can instruct 
// remix or whatever kind of software we are using to fetch actual variables at this addresss from the 
// PaymentReceived contract.

contract PaymentReceived{

    address public from;
    
    uint public amount;

    constructor(address _from, uint _amount){
        from = _from;
        amount = _amount;
    }

}

// Good reasons to use Structs over Child Contract:

// Saving Gas Costs! Deploying Child Contracts is simply more expensive.
// Saving Compexity: Every time you need to access a child contracts property or variable,
// it needs to go through the child contracts address. For structs, internally, 
//that's just an keccak hash for a lookup at the storage location.


// Another way to do this contract interaction for wallet system using Structs : -

// Struct Contract
contract Wallet2{

    struct PaymentReceivedStruct {
        address from;
        uint amount;
    }

    // Here, using this struct contract Deployment, we'll directly get variables rather than getting 
    // address for subcontract, then calling it while deploying to get the data in variables.

    PaymentReceivedStruct public payment;

    function payContract() public payable {
        // payment = PaymentReceivedStruct(msg.sender, msg.value);
        payment.from = msg.sender;
        payment.amount = msg.value;
    }
}
