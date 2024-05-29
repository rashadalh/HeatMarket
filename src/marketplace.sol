// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.8.0;


import { IhHeatOption } from "./heatOption.sol";
import { heatOption } from "./heatOption.sol";
import { NoReentrancy } from "./noReentrancy.sol";

import { Token } from "./erc20.sol";

// Prediction Marketplace for Heat Options....

contract market is NoReentrancy {
    address public owner;
    address public heatToken;

    mapping(address => address) public heatOptions;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function deployHeatOption(address _owner, address _arbitrator, address _heatOracle, address _expiryBlock, address _strikePrice) public onlyOwner noReentrancy{
        heatOptions[_owner] = address(new heatOption(heatToken, _owner, _arbitrator, _heatOracle, _expiryBlock, _strikePrice));
    }

    function betYesOnHeatOption(address _optionAddress, uint256 num_tokens) public noReentrancy {
        IhHeatOption(heatOptions[_optionAddress]).betYes(msg.sender, num_tokens);
    }

    function betNoOnHeatOption(address _optionAddress, uint256 num_tokens) public noReentrancy {
        IhHeatOption(heatOptions[_optionAddress]).betNo(msg.sender, num_tokens);
    }

    function arbitrateHeatOption(address _optionAddress, bool winnerIsYES) public noReentrancy {
        IhHeatOption(heatOptions[_optionAddress]).arbitrate(winnerIsYES);
    }

    function exerciseHeatOption(address _optionAddress) public noReentrancy onlyOwner {
        IhHeatOption(heatOptions[_optionAddress]).exerciseOption();
    }

    function withdrawPayoutYES(address _optionAddress) public noReentrancy {
        IhHeatOption(heatOptions[_optionAddress]).withdrawPayoutYES(msg.sender);
    }

    function withdrawPayoutNO(address _optionAddress) public noReentrancy {
        IhHeatOption(heatOptions[_optionAddress]).withdrawPayoutNO(msg.sender);
    }
}