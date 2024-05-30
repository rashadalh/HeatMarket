// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/erc20.sol";
import { oracle } from "../src/oracle.sol";
import { market } from "../src/marketplace.sol";
import { Imarket } from "../src/marketplace.sol";
dotenv.config({ path: '.env' });

contract DeployHeatToken is Script {
    function run() external {
        // load private key from dotenv
        uint256 deployerPrivateKey = vm.envUint(process.env.PRIVATE_KEY);
        vm.startBroadcast(deployerPrivateKey);

        // First step is to deploy the oracle contract
        uint256 initialTemperature = 69;  // arbitrary initial temperature
        address oracleAddress = new oracle(initialTemperature);

        // Deploy the HeatToken contract
        address htAddress = new Standard_Token(
            100_000_000_000 * 10**18,   // Initial supply of 100,000,000,000 tokens with 18 decimals
            "HEAT",                 // Token name
            18,                     // Decimals
            "HT"                    // Token symbol
        );

        // Deploy the HeatMarket contract
        address marketAddr = new market(
            htAddress,  // address of the HeatToken contract
            oracleAddress  // address of the oracle contract
        );

        uint256 expiryBlock = block.number + 3600;

        // let's deploy a heat option to start
        Imarket(marketAddr).deployHeatOption(
            msg.sender,  // owner of the option
            oracleAddress,  // arbitrator
            oracleAddress,  // oracle
            expiryBlock,  // current block + 100
            initialTemperature  // strike price
        );


        vm.stopBroadcast();
    }
}