//SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

// ERC - Ethereum Request for Comment
// The number 20 simply refers to the 20th ERC that was posted by someone. 
// That person proposed a general interface for a fungible token.

// Fungible Token
/*
when each token doesn't have any sort of unique serial number and they are all 
worth equally much. Like Euro or Dollar coins. You take out the coins in your pocket 
and 50 cents are 50 cents, doesn't matter if the coin is old and used or new and shiny.
*/

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract CoffeeToken is ERC20, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    event CoffeePurchased( address indexed receiver, address indexed buyer);

    constructor() ERC20("CoffeeToken", "CFE") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        // here minter role has been given to the address of the main owner -> who deploys the function
        // i.e. because msg.sender is given inside the constructor.
        _grantRole(MINTER_ROLE, msg.sender);
    }

    // to mint means to create new tokens.
    //?  * 10 ** decimals() is done on amount so that it converts to 10^18, since in remix (EVM) it shows in wei
    //? and we want token price to be in ether.
    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount * 10 ** decimals());
    }

    function buyOneCoffee() public {
        _burn(_msgSender(), 1 * 10 ** decimals());
        emit CoffeePurchased(_msgSender(), _msgSender());
    }

    //* function _spendAllowance(address owner, address spender, uint256 amount)
    //? https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol
    //? from the above repo, we have imported functions, our base contract is ERC20, so, these are all
    //? internal functions of base contract which are already defined, so we directly use them by putting
    //? arguments in parameters as per their defined syntax.

    /*
    for example -> this is the base contract internal function for msg.sender to spend allowance
    from main owner's wallet.

    here, the allowance(owner, spender) itself is some other function in ERC20 base contract.

    function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }
    */

    function buyOneCoffeeFrom (address account) public {
        _spendAllowance(account, _msgSender(), 1 * 10 ** decimals());
        _burn(account, 1 * 10 ** decimals());
        emit CoffeePurchased(_msgSender(), account);
    }

    /*
    Let's use a sample contract from OpenZeppelin to deploy a token. This token could represent 
    anything - for example a voucher for coffees.
    The flow could be:
    1. We can give users tokens for coffees
    2. The user can spend the coffee token in his own name, or give it to someone else
    3. Coffee tokens get burned when the user gets his coffee.
    */
}
