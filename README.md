# manacoin-solidity [![Build Status](https://travis-ci.org/manacoinio/manacoin-solidity.svg?branch=master)](https://travis-ci.org/manacoinio/manacoin-solidity)
A Decentralized Trading Platform Based on Smart Contracts
# Setup
## Install ganache
https://truffleframework.com/ganache or install the CLI
```
npm install -g ganache-cli
```
## Globally install truffle
Used for development
```
npm install -g truffle
```
See https://truffleframework.com/ for more info
## Install package dependencies
```
npm install
```
# Development
## Run ganache using CLI
```
ganache-cli -p 7545
```
## Compile Contracts
```
truffle compile
```
## Deploy Contracts
```
truffle migrate
```
## Run Tests
```
truffle test