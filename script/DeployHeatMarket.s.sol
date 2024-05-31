// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import { Token } from "../src/erc20.sol";
import { Standard_Token } from "../src/erc20.sol";
import { Ioracle } from "../src/oracle.sol";
import { oracle } from "../src/oracle.sol";
import { market } from "../src/marketplace.sol";
import { IMarket } from "../src/marketplace.sol";

contract DeployHeatMarket is Script {
    function run() external {
        // load private key from dotenv
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // First step is to deploy the oracle contract
        uint256 initialTemperature = 69;  // arbitrary initial temperature
        oracle oracle_ = new oracle(initialTemperature);
        address oracleAddress = address(oracle_);

        // Deploy the HeatToken contract
        Standard_Token ht = new Standard_Token(
            100_000_000_000 * 10**18,   // Initial supply of 100,000,000,000 tokens with 18 decimals
            "HEAT",                 // Token name
            18,                     // Decimals
            "HT"                    // Token symbol
        );
        address htAddress = address(ht);

        // Deploy the HeatMarket contract
        market market_ = new market(
            htAddress,  // address of the HeatToken contract
            oracleAddress  // address of the oracle contract
        );
        address marketAddr = address(market_);

        uint256 expiryBlock = block.number + 3600;

        // let's deploy a heat option to start
        IMarket(marketAddr).deployHeatOption(
            msg.sender,  // owner of the option
            oracleAddress,  // arbitrator
            oracleAddress,  // oracle
            expiryBlock,  // current block + 100
            initialTemperature  // strike price
        );

        vm.stopBroadcast();
    }
}