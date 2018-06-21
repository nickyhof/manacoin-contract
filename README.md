# manacoin-solidity [![Build Status](https://travis-ci.org/manacoinio/manacoin-solidity.svg?branch=master)](https://travis-ci.org/manacoinio/manacoin-solidity)
A Decentralized Trading Platform Based on Smart Contracts
# Setup
## Install tools
- ganache: https://truffleframework.com/ganache
- ipfs: https://dist.ipfs.io/#go-ipfs
## Install plugins
```
cd plugins/contracts-configuration
npm install
```
## Install package dependencies (from root directory)
```
npm install
```
## Globally install embark
Used for blockchain and contract management
```
npm install -g embark
```
See https://embark.status.im/ for more info
# Development
## Start a local blockchain
```
embark blockchain
```
## Start a blockchain simulator
```
embark simulator
```
## Compile and run all Contracts and Dapps
```
embark run --nodashboard
```
## Run tests
```
embark test
```