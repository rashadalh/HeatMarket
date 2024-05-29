// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/erc20.sol";

contract DeployHeatToken is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy the HeatToken contract
        new Standard_Token(
            100_000_000_000 * 10**18,   // Initial supply of 100,000,000,000 tokens with 18 decimals
            "HEAT",                 // Token name
            18,                     // Decimals
            "HT"                    // Token symbol
        );

        vm.stopBroadcast();
    }
}