//SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

/*
abstract reference class is created of the ERC20 Token
*/
abstract contract ERC20 {  
     function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success);
     function decimals() public virtual view returns (uint8);
}

contract TokenSale{

    uint public tokenPriceInWei = 1 ether;

    ERC20 public token;
    address public tokenOwner;

// here _token is the address of the smart contract in which the ERC20 token has been defined with all the functions
// since we are using this contract to generate tokens for all the msg.sender users so that they can purchase coffees, 
// so we'll put the address of the  SampleCoffeeToken.sol smart contract in which we are providing coffees per token.
    constructor (address _token) {
        tokenOwner = msg.sender;
        token = ERC20(_token);
    }

    function purchaseACoffee () public payable {
        require (msg.value >= tokenPriceInWei, "Not enough money sent");
        uint tokensToTransfer = msg.value / tokenPriceInWei;
        uint remainder = msg.value - tokensToTransfer * tokenPriceInWei;
        token.transferFrom(tokenOwner, msg.sender, tokensToTransfer);
        payable(msg.sender).transfer(remainder); //? send the rest of the money back to the msg.sender who is buying tokens.
    }
}

// Steps to use this token sale for selling tokens to msg.sender users to purchase coffee later from the previous coffee contract -:
/*
1. Creating 3 addresses - owner address, vendor address and customer address.
2. Through owner address, the coffee-contract of the SampleCoffeeToken.sol has been deployed.
3. Tokens are minted to the vendor address -> suppose, the person who is taking 100 tokens 
   from the owner's coffee smart contract to sell them to other msg.senders later. he is the same
   guy who'll deploy this token sale contract to open his small shop outside the main coffee shop
   to sell tokens to all the coming customers so that they can purchase coffees.
4. So, now we'll deploy this SampleTokenSale.sol -> contract TokenSale from vendors address.
5. Now, we'll copy this deployed TokenSale smart contract's address, and take it to the inital
   main contract of SampleCoffeeToken to set the allowance i.e. the amount of tokens this vendor is 
   allowed to sell to the customers. for example, if we increase allowance of this tokenSale contract 
   to 5 ethers, then he can only sell tokens worth 5 ethers. We'll set this allowance using increaseAllowance()
   function. We can check the allowance given to this TokenSale contract using allowance function of coffee Contract
   where the owner would be vendor address and spender would be this TokenSale contract's address which we copied
   earlier to increase its allwance.
6. Now, when the new msg.sender comes i.e. the customer address, he'll set the value and purchase tokens
   from the purchaseACoffee() function from this above contract and if he provides valid value for purchasing
   i.e. between 1 to 5 ether, the tokens will be sent to his address, then he can use them to purchase coffee
   from the main SampleCoffeeToken.sol coffee contract.
*/