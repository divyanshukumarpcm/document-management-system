// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0<0.9.0;
  
// Building the Contract
contract documentManagementSystem
{
    // Creating a structure for document details, id starts from 0, owner is address of owner
    struct document
    {
        int id;
        string name;
        string sha256sum;
        string url;
        address owner;
    }
  
    //doccount to to keep noumber of files added
    int public docCount = 0;

    //hash table , key- value pair, key is id and value is the struct document
    mapping(int => document) private docRecords;
  
  
  
    // function to add new documents, anyone can add the file, the address of account that adds the file is the owner of the file
    function addNewRecord(int _id, 
                           string memory _name,
                           string memory _sha256sum,
                           string memory _url
                           ) public
    {
        // Increasing the document count by 1
        docCount = docCount + 1;
        
        // Adding the document details with the help of count, id = key=count, since its 0 based indexing, hence -1
       
        docRecords[docCount-1] = document(_id, _name, 
                                       _sha256sum, _url,msg.sender);
    }


    //only owner can change the record, inoput new details with the same id number, returns false if non-owner tries to change
    function changeRecord(int _id, 
                           string memory _name,
                           string memory _sha256sum,
                           string memory _url
                           ) public returns(bool changed)
    {
        changed=false;
        // Fetching the document details with the help of id
       if(msg.sender == docRecords[_id].owner){
        docRecords[_id] = document(_id, _name, 
                                       _sha256sum, _url,msg.sender);
        changed=true;

       }
       return changed;

        
        
    }


    //only owner can change the owner address, return false if someone else tries otherwise changes  it.
    function changeOwner(int _id, 
                           address newOwner
                           ) public returns(bool changed)
    {
        changed=false;
        // Fetching the document details with the help of id
       if(msg.sender == docRecords[_id].owner){
        docRecords[_id].owner = newOwner;
        changed=true;

       }
       return changed;

        
        
    }


    //only owner can view record of the file, in non-owner tries to view, -1, invalid, invalid, invalid, msg.semder is returned, else correct data is returned
    function viewRecord(int _id) public returns(int a, string memory b, string memory c, string memory d , address e){
        if(msg.sender == docRecords[_id].owner)
        return (docRecords[_id].id, docRecords[_id].name, docRecords[_id].sha256sum, docRecords[_id].url, docRecords[_id].owner);
        else return (-1,"Invalid","Invalid","Invalid",msg.sender);
    }

    //anyone can verify the file details with id, name, sha256sum. Returns true if details are valid; returns false otherwise.
    function verifyRecord(int _id, 
                           string memory _name,
                           string memory _sha256sum,
                           string memory _url) public returns (bool isCorrect){
    
    isCorrect=false;
    if(strcmp(docRecords[_id].name,_name) && strcmp(docRecords[_id].sha256sum,_sha256sum) && strcmp(docRecords[_id].url,_url))isCorrect=true;
    return isCorrect;
    }


    //functions to compare two strings - helper functions for verifyRecords functions
    function memcmp(bytes memory a, bytes memory b) internal pure returns(bool){
        return (a.length == b.length) && (keccak256(a) == keccak256(b));
    }
    function strcmp(string memory a, string memory b) internal pure returns(bool){
        return memcmp(bytes(a), bytes(b));
    }
  
    
}
