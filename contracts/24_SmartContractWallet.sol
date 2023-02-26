//SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

contract SmartWallet {
    mapping(address => bool) public guardians;
    address payable public owner;
    address payable public nextOwner;
    mapping(address => mapping(address => bool)) public NewVote;
    mapping(address => uint256) public allowance;
    mapping(address => bool) public isAllowed;
    uint256 public count;
    uint256 public constant ConfirmationFromGuardiansForReset = 3;
    mapping(address => uint256) public voteCount;

    constructor() {
        owner = payable(msg.sender);
    }

    function proposeNewOwner(address payable _newOwner) public {
        require(guardians[msg.sender], "You are not a guardian");
        require(
            NewVote[_newOwner][msg.sender] == false,
            "you have already voted"
        );
        if (nextOwner != _newOwner) {
            if (voteCount[_newOwner] == 0) count = 0;

            nextOwner = _newOwner;
        }
        count++;
        voteCount[nextOwner] = count;
        NewVote[nextOwner][msg.sender] = true;
        if (count >= ConfirmationFromGuardiansForReset) {
            owner = nextOwner;
            nextOwner = payable(address(0));
        }
    }

    function setGuardian(address _for, bool _setGuardians) public {
        require(owner == msg.sender, "Your are not the owner");
        guardians[_for] = _setGuardians;
    }

    function setAllowance(address _for, uint256 _amount) public {
        require(owner == msg.sender, "You are not the owner");
        allowance[_for] = _amount;
        if (_amount > 0) {
            isAllowed[_for] = true;
        } else {
            isAllowed[_for] = false;
        }
    }

    function transfer(
        address payable _to,
        uint256 _amount,
        bytes memory _payload
    ) public returns (bytes memory) {
        //require(owner==msg.sender,"Transaction aborted, True owner missing");
        if (msg.sender != owner) {
            require(allowance[msg.sender] >= _amount, "Aukat me rehle bc");

            /// for edge case whena balance and amount is 0
            require(isAllowed[msg.sender], "You are not allowed to send");

            allowance[msg.sender] -= _amount;
        }
        (bool success, bytes memory returnData) = _to.call{value: _amount}(
            _payload
        );
        require(success, "Aborting the transaction");
        return returnData;
    }

    receive() external payable {}
}
