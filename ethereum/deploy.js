const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require ('web3');
const compiledFactory = require('./build/CampaignFactory.json');

const { interface, bytecode } = require('./compile');

const provider = new HDWalletProvider(
    'ghost waste liquid mix bonus genius replace insect antique ribbon desert husband',
    'https://rinkeby.infura.io/feHg3HOXbLltbwVIHgMc'
);

const web3 = new Web3(provider);

const deploy = async () => {
    const accounts = await web3.eth.getAccounts();

    console.log('Attempting to deploy from account ' + accounts[0]);

    const result = await new web3.eth.Contract(JSON.parse(compiledFactory.interface))
        .deploy({data: '0x' + compiledFactory.bytecode})
        .send({gas: '2000000', from: accounts[0]});

    console.log('Contract deployed to ', result.options.address);

    // 0x13c939750a8c10623364f93e5c00e2d73C189fD4
};

deploy();
