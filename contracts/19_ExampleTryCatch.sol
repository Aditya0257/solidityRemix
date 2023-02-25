//SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

contract WillThrow {
    
    // for custom exceptions, to catch directly in the end, not in catch Error or catch Panic
    error NotAllowedError(string);

    function aFunction() public pure {
        // require(false, "Error Message");
        // assert(false);
        revert NotAllowedError("You are not allowed!");
    }
}

contract ErrorHandling {
    event ErrorLogging(string reason);
    event ErrorLogCode(uint256 code);
    event ErrorLogByte(bytes lowLevelData);

    function catchTheError() public {
        WillThrow will = new WillThrow();
        try will.aFunction() {
            // add code here if it works
        } catch Error(string memory reason) // for require - :
        {
            emit ErrorLogging(reason);
        } catch Panic(
            uint256 errorCode
        ) // for assert (it only has error code, no message like in require)- :
        {
            emit ErrorLogCode(errorCode);
        } catch (
            bytes memory lowLevelData
        ) // for custom errors, not in require and assert - :
        {
            emit ErrorLogByte(lowLevelData);
        }
    }
}
