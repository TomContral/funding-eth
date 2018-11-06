import Web3 from 'web3';
let web3;

if ( typeof window.web3==='undefined'){
    console.log('local web3 found!')
    web3=new Web3(new Web3.providers.HpptProvider('http://locahost:8545'))
}else{
    web3=new Web3( window.web3.currentProvider);
    console.log('injected web3 found!')

}

export default web3;
