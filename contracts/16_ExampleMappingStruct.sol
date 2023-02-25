//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract MappingStructExample{

    struct Transaction{
        uint amount;
        uint timestamp;
    }

    struct Balance{
        uint totalBalance;
        uint numDeposits;
        mapping(uint => Transaction) deposits;
        // mapping(uint => Transaction) public deposits; <- this doesn't create any getter function here.
        uint numWithdrawals;
        mapping(uint => Transaction) withdrawals;
    }

    // here, when we call Balance struct as value from balances map after giving address as key
    // it only shows totalBalance, numDeposits, and withdrawals.
    // writing public here in mapping type also doesn't work, you have to create your own getter 
    // function by defining.

    function getDepositNum(address _from, uint _numDeposit) public view returns (Transaction memory) {
        return balances[_from].deposits[_numDeposit];
    }

    mapping(address => Balance) public balances;

    function depositMoney() public payable {
        balances[msg.sender].totalBalance += msg.value;

        Transaction memory deposit = Transaction(msg.value, block.timestamp);
        balances[msg.sender].deposits[balances[msg.sender].numDeposits] = deposit;
        balances[msg.sender].numDeposits++;
    }

    function withdrawMoney(address payable _to, uint _amount) public {
        
        balances[msg.sender].totalBalance -= _amount;

        Transaction memory withdrawal = Transaction(_amount, block.timestamp);
        balances[msg.sender].withdrawals[balances[msg.sender].numWithdrawals] = withdrawal;
        balances[msg.sender].numWithdrawals++;

        _to.transfer(_amount);
    }
}