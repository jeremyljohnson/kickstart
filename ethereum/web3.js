import Web3 from 'web3';

let web3;

if (typeof window !== 'undefined' && typeof window.web3 !== 'undefined') {
    // means we are in the browser and user is running web3
    web3 = new Web3(window.web3.currentProvider);
} else {
    // server side rendering OR user is now running metamask
    const provider = new Web3.providers.HttpProvider(
        'https://rinkeby.infura.io/feHg3HOXbLltbwVIHgMc'
    );
    // would theorectically share key with anyone!!
    web3 = new Web3(provider);
}

export default web3;