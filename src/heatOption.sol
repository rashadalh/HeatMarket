// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.8.0;

import {NoReentrancy} from "./noReentrancy.sol";
// heat option solidity contract.

interface IHeatOption {
    function heatToken() external view returns (address);
    function owner() external view returns (address);
    function heatOracle() external view returns (address);
    function arbitrator() external view returns (address);
    function expiryBlock() external view returns (uint256);
    function strikePrice() external view returns (uint256);
    function arbitrationPeriod() external view returns (uint256);
    function exercised() external view returns (bool);
    function arbitrationPeriodFinished() external view returns (bool);
    function winnerIsYES() external view returns (bool);

    function balancesYES(address account) external view returns (uint256);
    function balancesNO(address account) external view returns (uint256);

    function totalYES() external view returns (uint256);
    function totalNO() external view returns (uint256);

    function betYes(uint256 num_tokens) external;
    function betNo(uint256 num_tokens) external;
    function arbitrate(bool winnerIsYES) external;
    function exerciseOption() external;
    function withdrawPayoutYES() external;
    function withdrawPayoutNO() external;
}

contract heatOption is NoReentrancy, IHeatOption {
    address public heatToken; // address of the HT token
    address public owner; // address of the owner of the option
    address public heatOracle; // address of the oracle that will provide the price of the asset
    address public arbitrator; // address of the arbitrator that will resolve disputes
    address public expiryBlock; // block number when the option expires
    uint256 public strikePrice; // price at which the option can be exercised
    uint256 public arbitrationPeriod; // number of blocks after expiry when the option can be disputed
    bool public exercised; // flag to check if the option has been exercised
    bool public arbitrationPeriodFinished; // flag to check if the arbitration period has finished

    bool public winnerIsYES; // flag to check if the winner is YES

    // NOTE: bets are made in HT tokens.
    mapping(address => uint256) public balancesYES; // mapping of addresses to balances betting YES
    mapping(address => uint256) public balancesNO; // mapping of addresses to balances betting NO

    uint256 public totalYES; // total amount of HT tokens bet on YES
    uint256 public totalNO; // total amount of HT tokens bet on NO


    constructor (address _heatToken, address _owner, address _arbitrator, address _heatOracle, address _expiryBlock, address _strikePrice) public {
        heatToken = _heatToken;
        owner = _owner;
        arbitrator = _arbitrator;
        heatOracle = _heatOracle;
        expiryBlock = _expiryBlock;
        strikePrice = _strikePrice;

        winnerIsYES = false; // default value

        // check that expiry block is in the future
        require(expiryBlock > block.number, "Expiry block is in the past");

        // check that the strike price is greater than zero
        require(strikePrice > 0, "Strike price is less than or equal to zero");

        // make sure arbitration period > 0
        require(arbitrationPeriod > 0, "Arbitration period is less than or equal to zero");
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier onlyArbitrator() {
        require(msg.sender == arbitrator, "Only the arbitrator can call this function");
        _;
    }

    function betYes(uint256 num_tokens) public noReentrancy {
        // check if the option has not been exercised
        require(!exercised, "Option has already been exercised");

        // check if the option has not expired
        require(block.number < expiryBlock, "Option has expired");

        // check if the sender has enough HT tokens
        require(Standard_Token(heatToken).balanceOf(msg.sender) >= num_tokens, "Not enough HT tokens");

        // transfer the HT tokens to this contract
        Standard_Token(heatToken).transferFrom(msg.sender, address(this), num_tokens);

        // update the balance of the sender
        balancesYES[msg.sender] += num_tokens;

        // update the total amount of HT tokens bet on YES
        totalYES += num_tokens;
    }

    function betNo(uint256 num_tokens) public noReentrancy {
        // check if the option has not been exercised
        require(!exercised, "Option has already been exercised");

        // check if the option has not expired
        require(block.number < expiryBlock, "Option has expired");

        // check if the sender has enough HT tokens
        require(Standard_Token(heatToken).balanceOf(msg.sender) >= num_tokens, "Not enough HT tokens");

        // transfer the HT tokens to this contract
        Standard_Token(heatToken).transferFrom(msg.sender, address(this), num_tokens);

        // update the balance of the sender
        balancesNO[msg.sender] += num_tokens;

        // update the total amount of HT tokens bet on NO
        totalNO += num_tokens;
    }

    // arbitrator can arbitrate the option only during the arbitration period
    // even if the option has already been exercised
    function arbitrate(bool _winnerIsYES) public onlyArbitrator noReentrancy {
        // check if the option has expired
        require(block.number > expiryBlock, "Option has not expired yet");

        // check if the arbitration period has finished
        require(block.number < expiryBlock + arbitrationPeriod, "Arbitration period has finished");

        // set the winner
        winnerIsYES = _winnerIsYES;

        // set the option as exercised
        exercised = true;
    }

    function exerciseOption() public noReentrancy {
        // check if option is not yet expired
        require(!exercised, "Option has already been exercised");
        
        // check if the option has expired
        require(block.number > expiryBlock, "Option has not expired yet");

        // check that we are BEFORE the arbitration period
        require(block.number < expiryBlock + arbitrationPeriod, "Arbitration period has finished");


        // Check if YES Won (price of the asset is greater than the strike price)
        if (heatOracle.getPrice() > strikePrice) {
            winnerIsYES = true;
        }
    }

    // function to transfer portion of winnings to the winner calling this function
    function withdrawPayoutYES noReentrancy() public {
        // check if the option has been exercised
        require(exercised, "Option has not been exercised yet");

        // check if the arbitration period has finished
        require(block.number > expiryBlock + arbitrationPeriod, "Arbitration period has not finished yet");

        // check if the winner is YES
        require(winnerIsYES, "Winner is NO");

        // check if the winner is calling this function
        require(balancesYES[msg.sender] > 0, "You are not the winner");

        // compute winner payout
        // this is the total amount of HT tokens that were bet on NO + the total amount of HT tokens that were bet on YES x the percentage of the total amount of HT tokens that were bet on YES by the winner

        // transfer the payout to the winner
        // calculate total YES and NO balances

        // compute winner payout
        uint256 winnerPayout = (totalNO + totalYES) * balancesYES[msg.sender] / totalYES;

        // transfer the payout to the winner
        balancesYES[msg.sender] = 0;
        msg.sender.transfer(winnerPayout);

        // decrese the total amount of HT tokens bet on YES
        if (totalYES > winnerPayout) {
            totalYES -= winnerPayout;
        } else {
            totalYES = 0;
        }
    }

    function withdrawPayoutNO() noReentrancy {
        // check if the option has been exercised
        require(exercised, "Option has not been exercised yet");

        // check if the arbitration period has finished
        require(block.number > expiryBlock + arbitrationPeriod, "Arbitration period has not finished yet");

        // check if the winner is NO
        require(!winnerIsYES, "Winner is YES");

        // check if the winner is calling this function
        require(balancesNO[msg.sender] > 0, "You are not the winner");

        // compute winner payout
        // this is the total amount of HT tokens that were bet on YES + the total amount of HT tokens that were bet on NO x the percentage of the total amount of HT tokens that were bet on NO by the winner

        // transfer the payout to the winner
        // calculate total YES and NO balances

        // compute winner payout
        uint256 winnerPayout = (totalNO + totalYES) * balancesNO[msg.sender] / totalNO;

        // transfer the payout to the winner
        balancesNO[msg.sender] = 0;
        msg.sender.transfer(winnerPayout);

        // decrese the total amount of HT tokens bet on NO
        if (totalNO > winnerPayout) {
            totalNO -= winnerPayout;
        } else {
            totalNO = 0;
        }
    }
}