//SPDX-License-Identifier: MIT

pragma solidity 0.8.18;


// SIMPLE TOKEN CONTRACT
/* 
    WORKING STRUCTURE
1. Select Account#1 from the Accounts Dropdown
2. Deploy the Contract 
3. Switch over to Account #2
4. Enter 1 into the value field & Select "Ether" from the Dropdown
5. Buy 1 Token for 1 Ether by hitting the purchase button\
6. Get the Token Balance -> Now lets look if we have the right balance. 
Copy your address, fill it into the input field for "tokenBalance" and see if the balance is 1.
7. Burn Tokens -> Now lets see what happens if we stay on Account#2 and try to burn tokens:
 Try to burn with Account #2
 Observe the Error message which is coming from the require statement
*/

//PROBLEM
/* 
Right now we have several similar require statements. They are all testing if a specific address 
called the smart contract. To avoid code duplication and make it easier to change this from a 
single place, we can use modifiers:  

        //other code
        modifier onlyOnwer {
            require(msg.sender == owner, "You are not allowed");
            _;
        }
        //...

*/

// contract Owner{
//     address owner;

//     constructor() {
//         owner = msg.sender;
//     }

//     modifier onlyOwner() {
//         require(msg.sender == owner, "You are not allowed!");
//         _;
//     }

// }

import "./28_Ownable.sol";

// `is` Owner written to extend the base contract in this one.
contract InheritanceModifierExample is Owner {
    mapping(address => uint) public tokenBalance;

    // address owner;

    uint256 tokenPrice = 1 ether;

   
    constructor() {
        // owner = msg.sender;
        // tokenBalance[owner] = 100;
        /* 
        After using Owner contract as base contract and inheriting its code in this contract, in constructor
        we only have to enter 100 token balance initally for the msg.sender, owner is taken as the inital msg.sender
        on its own by inheriting the base contract, as it also calls for a constructor.
        */
        tokenBalance[msg.sender] = 100;
    }

    // here, modifier used from within the same contract, we can put this only owner functionality
    // in another smart contract and then just use it within this one, it'll increase reusability.
    // we can also make a different .sol file and put the code which can be reused many times and import it.

    // modifier onlyOwner() {
    //     require(msg.sender == owner, "You are not allowed!");
    //     _;
    // }


    function createNewToken() public onlyOwner{
        // require(msg.sender == owner, "You are not allowed!");
        tokenBalance[owner]++;
    }

    function burnToken() public onlyOwner{
        // require(msg.sender == owner, "You are not allowed!");
        tokenBalance[owner]--;
    }

    // if msg.sender who is not owner wants to purchase some tokens, since
    // by default, all msg.senders except owner will have 0 tokens.
    function purchaseToken() public payable {
        require(
            (tokenBalance[owner] * tokenPrice) / msg.value > 0,
            "owner doesn't have that much tokens to sell to others who want to purchase, msg.value is way higher!"
        );
        tokenBalance[owner] -= msg.value / tokenPrice;
        tokenBalance[msg.sender] += msg.value / tokenPrice;
    }

    function sendToken(address _to, uint256 _amount) public {
        require(tokenBalance[msg.sender] >= _amount, "you don't have enough tokens!");
        tokenBalance[msg.sender] -= _amount;
        tokenBalance[_to] += _amount;
    }
}
