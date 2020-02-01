pragma solidity ^0.5.10;



contract licenseValidation{
   struct Contact{
       bool trialpass;
       bool writtenpass;
       string  hashvalue;
       bool pass;

   }
   uint id;
   mapping (uint => Contact) id_to_contact;
   function addContact(string memory _hashvalue) public returns (uint id_){
        id_to_contact[id] = Contact(false,false,_hashvalue,false);
        id++;
        return id-1;
    }
    function getUID() view public returns (uint _id){ return id-1;}
    function getHash(uint _id) view public returns (string memory _hashvalue){
        return id_to_contact[_id].hashvalue;
    }
   function getContact(uint _id) view public returns (bool _trialpass,bool _writtenpass,bool _pass,string memory _hashvalue) {
       require(_id < id);
        return (id_to_contact[_id].trialpass,id_to_contact[_id].writtenpass,id_to_contact[_id].pass,id_to_contact[_id].hashvalue);
    }
    function set_update(bool _trialpass,bool _writtenpass,uint _id)public{

        id_to_contact[_id].trialpass=_trialpass;
         id_to_contact[_id].writtenpass=_writtenpass;
         id_to_contact[_id].pass = id_to_contact[_id].trialpass && id_to_contact[_id].writtenpass;

    }
}
