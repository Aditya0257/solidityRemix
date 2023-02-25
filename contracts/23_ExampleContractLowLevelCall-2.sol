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

    receive() external payable{
        deposit();
    }
}

contract ContractTwo {

    receive() external payable{}

    function depositOnContractOne(address _contractOne) public { 
    // bytes memory payload = abi.encodeWithSignature("deposit()");
       (bool success, ) =_contractOne.call{value: 10, gas: 100000}("");
       require(success, "Low level call wasn't successful.");
    }

}

// What changed?

// Now we generically send 10 wei to the address _contractOne. This can be a 
// smart contract. It can be a wallet. If its a contract it will always call 
// the fallback function. But it will provide enough gas to execute arbitrary logic.

// we used this way because ...suppose we have no idea that whether deposit function
// exists in contractOne or not... so we are directly sending the value and gas to the address
// then receive funciton is receiving the value and gas in contractOne and then it is calling 
// the deposit() to store value at addressBalances.

// RE ENTRANCY ATTACKS THREAT - : 

// Be careful here with so-called re-entrency attacks. If you provide enough gas 
// for the called contract to execute arbitary logic, then its also possible for 
// the smart contract ( here contractOne ) to call back into the calling contract ( here contractTwo ) 
// and potentially change state variables.

// Always try to follow the so-called checks-effects-interactions pattern, where 
// the external smart contract interaction comes last.