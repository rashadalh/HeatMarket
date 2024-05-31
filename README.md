Hi there! For our Consensus easyA hackathon project, we are building a prediction market for the weather available on the EVM Bitcoin chain Rootstock. In particular, we are focused on a prediction market for the Heat. Thermal efficiency is a billion dollar issue in the energy sector, after a certain heat, the plant lose expontenially in efficiency. Weather company weight their prediction and monetize them, enregy company hedge with pricing insurance options.

Traders can bet wheather it will be above or below a particular temperature. Bet's are simple "Will the high temperature tomorrow in [X] be above or below 65 degrees?", and trader's can buy or sell YES or NO. 

To price the odds, we simply state that the price of YES is the ratio of YES VOTES / (YES VOTES + NO VOTES). Thus as more people buy yes, this increases the number of votes on YES. The odds of winning are implied by the market as YES VOTES / (YES VOTES + NO VOTES).

To add a single yes vote, you can do this by betting 1 heat token. Betting the heat token will lock it into the contract and at finalization, you will be able withdraw your investment + the reward if you are the winner.

At the finalization, there is a 24 hour dispute window from which an arbitrator can arbitrate the outcome.

If no sucessful challenge is made, the full amount of heat tokens is allocated to the winners. You share of heat tokens is equal to You Votes on Winning Side x (Yes votes + No Votes) / (Votes on Winning Side)

You can then re-invest your $HEAT tokens into new markets!

#Links
Presentation Deck: https://www.canva.com/design/DAGGvPlMkoY/2f95gQoNssPD1LP7xlAnsg/edit?utm_content=DAGGvPlMkoY&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton

Twitter: https://x.com/HeatMarketRSK

Architecture: https://excalidraw.com/#json=6cE8DjWAZr4fvqCNrmhGH,KGKAuPZ4xPoaVou7wSw9Bg

# Founder
Rashad: https://x.com/rashad0101
Julesfoa.eth: https://x.com/JulesFoa


## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
