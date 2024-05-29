// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.8.0;

// No Reentrancy contract

contract NoReentrancy {
    bool locked;

    modifier noReentrancy() {
        require(!locked, "No reentrancy");
        locked = true;
        _;
        locked = false;
    }
}