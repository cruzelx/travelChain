const ipfsAPI = require('ipfs-api');
const ipfs = new ipfsAPI({ host: 'ipfs.infura.io', port: 5001, protocol: 'https' });
const fs= require('fs');

let testFile = fs.readFileSync("new.txt");
// //Creating buffer for ipfs function to add file to the system
let testBuffer = new Buffer(testFile);

ipfs.files.add(testBuffer, function (err, file) {
    if (err) {
      console.log(err);
    }

console.log(file);})
