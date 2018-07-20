const path = require('path');
const solc = require('solc');
const fs = require('fs-extra');

// resolve the build folder
const buildPath = path.resolve(__dirname, 'build');

// delete entire build folder contents
fs.removeSync(buildPath);

const campaignPath = path.resolve(__dirname, 'contracts', 'Campaign.sol');
const source = fs.readFileSync(campaignPath, 'utf8');
const output = solc.compile(source, 1).contracts;

// console.log(output);
fs.ensureDirSync(buildPath);

for (let contract in output) {
    fs.outputJsonSync(
        path.resolve(buildPath, contract.replace(':', '') + '.json'),
        output[contract]
    );
}