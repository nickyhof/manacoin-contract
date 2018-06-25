import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';

import { drizzleConnect } from "drizzle-react";
import { ContractData, ContractForm } from "drizzle-react-components";

class App extends Component {
  render() {
    const { drizzleStatus, accounts } = this.props;
    console.log(accounts);

    if (drizzleStatus.initialized) {
      return (
        <div className="App">
          <header className="App-header">
            <h1 className="App-title">ManaCoinToken</h1>
            <p>
              <strong>Total Supply</strong>:{" "}
              <ContractData
                contract="ManaCoinToken"
                method="totalSupply"
                methodArgs={[{ from: accounts[0] }]}
              />{" "}
              <ContractData
                contract="ManaCoinToken"
                method="symbol"
                hideIndicator
              />
            </p>
            <p>
              <strong>My Balance</strong>:{" "}
              <ContractData
                contract="ManaCoinToken"
                method="balanceOf"
                methodArgs={[accounts[0]]}
              />
            </p>
            <p>
              <strong>My Address</strong>:{[accounts[0]]}
            </p>
          </header>
          <h3>Mint Tokens</h3>
          <div className="App-intro">
            <ContractForm
              contract="ManaCoinToken"
              method="mint"
              labels={["ToAddress", "Amount to Mint"]}
            />
          </div>
          <h3>Send Tokens</h3>
          <div className="App-intro">
            <ContractForm
              contract="ManaCoinToken"
              method="transfer"
              labels={["To Address", "Amount to Send"]}
            />
          </div>
          <h2>Orders</h2>
          <h3>Create Order</h3>
          <div className="App-intro">
            <ContractForm
              contract="ManaCoinToken"
              method="createOrder"
              labels={["To Address", "Amount", "Fulfilment Contract"]}
            />
          </div>
          <h3>Cancel Order</h3>
          <div className="App-intro">
            <ContractForm
              contract="ManaCoinToken"
              method="cancelOrder"
              labels={["Order Id"]}
            />
          </div>
          <h3>Complete Order</h3>
          <div className="App-intro">
            <ContractForm
              contract="ManaCoinToken"
              method="completeOrder"
              labels={["Order Id"]}
            />
          </div>
          <h3>Refund Order</h3>
          <div className="App-intro">
            <ContractForm
              contract="ManaCoinToken"
              method="refundOrder"
              labels={["Order Id"]}
            />
          </div>
        </div>
      );
    }

    return <div>Loading ManaCoinToken Dapp...</div>;
  }
}

const mapStateToProps = state => {
  return {
    accounts: state.accounts,
    drizzleStatus: state.drizzleStatus,
    ManaCoinToken: state.contracts.ManaCoinToken
  };
};

const AppContainer = drizzleConnect(App, mapStateToProps);
export default AppContainer;