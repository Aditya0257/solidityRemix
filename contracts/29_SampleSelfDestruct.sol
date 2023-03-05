//SPDX-License-Identifier: MIT

pragma solidity 0.8.18;


//The data on the blockchain is forever, but the state is not. 
// That means, we can not erase information from the Blockchain, 
// but we can update the current state so that you can't interact 
// with an address anymore going forward. Everyone can always go 
// back in time and check what was the value on day X, but, once 
// the function selfdestruct() is called, you can't interact with a Smart Contract anymore.


// Deprecated - selfdestruct

// contract StartStopUpdateExample {

//     receive() external payable {}

//     function destroySmartContract() public {
//         selfdestruct(payable(msg.sender));
//     }
// }

//HOW TRANSACTION WORKS ?
/* 
Deploy a new Instance
Send 1 Ether to the smart contract
Try to call destroySmartContract and 1 Ether is sent back. 
*/