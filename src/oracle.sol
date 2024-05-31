// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// simple contract to act as a temperature oracle

interface Ioracle {
    function setTemperature(uint256 _temperature) external;
    function getTemperature() external view returns (uint256);
}

contract oracle is Ioracle {
    address public owner;
    uint256 public temperature;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function setTemperature(uint256 _temperature) public onlyOwner() {
        temperature = _temperature;
    }

    function getTemperature() public view returns (uint256) {
        return temperature;
    }

    // constructor
    constructor(uint256 _init_temp) public {
        owner = msg.sender;
        temperature = _init_temp;
    }
}