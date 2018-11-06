import React, { Component } from 'react';
import web3 from './utils/getweb3';


class App extends Component {
      constructor(){
          super();
          this.state={
              currentAccount:''
          }

      }

    async componentDidMount () {
        let accounts = await web3.eth.getAccounts();
        this.setState({currentAccount:accounts[0]});

    }

    render() {
          let {currentAccount}=this.state;
        return (
            <p>管理员地址为：{currentAccount}</p>
        );
    }
}
export default App;
