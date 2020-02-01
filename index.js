//Required modules
const ipfsAPI = require('ipfs-api');
const express = require('express');
const fs = require('fs');
const app = express();
let cors=require('cors');
const ethers=require('ethers');
var bytecode = fs.readFileSync('license_sol_licenseValidation.bin').toString();
var abi = JSON.parse(fs.readFileSync('license_sol_licenseValidation.abi').toString());
var provider = new ethers.providers.JsonRpcProvider();
var address='0xfCCc40C41acc66Fd88587d7fcd9ac82Eb682835Dy';
privateKey='0x95704cff0bbdb1259b4b45af3ff474185b625c31fb47c5fcb47bfe482319e12c';
var wallet = new ethers.Wallet(privateKey, provider);
var contract = new ethers.Contract(address, abi, wallet);
var bodyParser= require('body-parser');
app.use(bodyParser.json());
app.use(cors());
app.use(bodyParser.urlencoded({ extended: true, limit: "50mb" }));

contract.getHash(0).then((r)=>console.log(r));
//Connceting to the ipfs network via infura gateway
const ipfs = ipfsAPI('ipfs.infura.io', '5001', {protocol: 'https'})
//should only be run once for deployment of smart license contract
app.get('/deployContract',(req,res)=>{

    var signer = provider.getSigner(0);//contract will be signed and owned by the first address in ganache CLI
    var factory = new ethers.ContractFactory(abi, bytecode, signer);//factory the altogethers to be deployed
    var contract = null //to be in safe side,just making contract empty
    factory.deploy().then((c)=> { contract = c
    res.send('contract succesfully deployed')
console.log(contract)});//the contract is being deployed

})
// provider.listAccounts().then(result => console.log(result));
app.get('/addApplicant',(req,res)=>{
    // //Reading file from computer
     var applicant={"fname":req.body.fname,"lname":req.body.lname,"number":req.body.number,"gender":req.body.gender};
     fs.writeFileSync('./../test-ipfs/file.json',JSON.stringify(applicant));
    let testFile = fs.readFileSync("./../test-ipfs/file.json");
    // //Creating buffer for ipfs function to add file to the system
    let testBuffer = new Buffer(testFile);

    //
    // //Addfile router for adding file a local file to the IPFS network without any local node

    //
        ipfs.files.add(testBuffer, function (err, file) {
            if (err) {
              console.log(err);
            }

  console.log(file);
             console.log(file[0].hash);
            // var file = JSON.parse(fs.readFileSync('file.json') .toString());

                 contract.addContact(file[0].hash).then((r)=>{
                     contract.getUID().then((f)=>{
                         console.log(f.toNumber())
                          data={"name":"mitesh pandey","id":f.toNumber()}
                          fs.writeFileSync('file.json',JSON.stringify(data));
                              res.send("written succesfully");

      })
  })
})



    //
    // privateKey='0x2354ff3e0bc006ebde5c7c0b5b9c15c9d07efe0deeef7c9a07c666decb126a54';
    // // var file = JSON.parse(fs.readFileSync('file.json').toString());
    //     var wallet = new ethers.Wallet(privateKey, provider);
    //     var contract = new ethers.Contract(address, abi, wallet);
    //      contract.addContact().then((r)=>{
    //          contract.getUID().then((f)=>{
    //               data={"name":"mitesh pandey","id":f.toNumber()}
    //               fs.writeFileSync('file.json',JSON.stringify(data),function(err,result){
    //                   console.log("written succesfully")
    //
    //                   //
    //

})






//console.log(ipfs);


//Getting the uploaded file via hash code.
app.get('/getfile', function(req, res) {

    //This hash is returned hash of addFile router.
    const validCID = 'QmNz2dohwXCy44AyaDcj8NiQbFmvWsf1Fp8eoZqKNyuSJY'

    ipfs.files.get(validCID, function (err, files) {
        console.log(files);
        files.forEach((file) => {
          console.log(file.path)
          console.log(file.content.toString('utf8'))
        })
      })

})

//route to set update of the written and trial pass status

app.get('/setStatus',(req,res)=>{
     contract.set_update(req.body.trialpass,req.body.writtenpass,req.body.id).then((r)=>{
         console.log('successfully updated to the contract');
     })

})
app.get('/getContact',(req,res)=>{
    console.log(req.body);
    contract.getContact(req.body.id).then((r)=>{
        console.log(r);
    })
})

app.listen(3000, () => console.log('App listening on port 3000!'))
