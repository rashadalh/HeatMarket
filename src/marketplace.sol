// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import { IHeatOption } from "./heatOption.sol";
import { heatOption } from "./heatOption.sol";
import { NoReentrancy } from "./noReentrancy.sol";

import { Token } from "./erc20.sol";

interface IMarket {
    function deployHeatOption(address _owner, address _arbitrator, address _heatOracle, uint256 _expiryBlock, uint256 _strikePrice) external;
    function betYesOnHeatOption(address _optionAddress, uint256 num_tokens) external;
    function betNoOnHeatOption(address _optionAddress, uint256 num_tokens) external;
    function arbitrateHeatOption(address _optionAddress, bool winnerIsYES) external;
    function exerciseHeatOption(address _optionAddress) external;
    function withdrawPayoutYES(address _optionAddress) external;
    function withdrawPayoutNO(address _optionAddress) external;
}


// Prediction Marketplace for Heat Options....
contract market is IMarket, NoReentrancy {
    address public owner;
    address public heatToken;
    address public heatOracle;

    mapping(address => address) public heatOptions;

    constructor(address _heatToken, address _heatOracle) {
        owner = msg.sender;
        heatToken = _heatToken;
        heatOracle = _heatOracle;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function deployHeatOption(address _owner, address _arbitrator, address _heatOracle, uint256 _expiryBlock, uint256 _strikePrice) public override onlyOwner noReentrancy{
        heatOptions[_owner] = address(new heatOption(heatToken, _owner, _arbitrator, _heatOracle, _expiryBlock, _strikePrice));
    }

    function betYesOnHeatOption(address _optionAddress, uint256 num_tokens) public override noReentrancy {
        IHeatOption(heatOptions[_optionAddress]).betYes(msg.sender, num_tokens);
    }

    function betNoOnHeatOption(address _optionAddress, uint256 num_tokens) public override noReentrancy {
        IHeatOption(heatOptions[_optionAddress]).betNo(msg.sender, num_tokens);
    }

    function arbitrateHeatOption(address _optionAddress, bool winnerIsYES) public override noReentrancy {
        IHeatOption(heatOptions[_optionAddress]).arbitrate(winnerIsYES);
    }

    function exerciseHeatOption(address _optionAddress) public override noReentrancy onlyOwner {
        IHeatOption(heatOptions[_optionAddress]).exerciseOption();
    }

    function withdrawPayoutYES(address _optionAddress) public override noReentrancy {
        IHeatOption(heatOptions[_optionAddress]).withdrawPayoutYES(msg.sender);
    }

    function withdrawPayoutNO(address _optionAddress) public override noReentrancy {
        IHeatOption(heatOptions[_optionAddress]).withdrawPayoutNO(msg.sender);
    }
}