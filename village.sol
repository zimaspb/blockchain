// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract Village is ERC1155{
    constructor() ERC1155(""){
        Admin=msg.sender;
    }

    uint public houseAmount = 0;
    uint public parkingAmount = 50;
    address Admin;
    uint public priceForWeek = 500000000 gwei;
    uint public priceForCleaning = 25000000 gwei;
    uint public priceForParking = 25000000 gwei;
    uint public priceForPizza = 25000000 gwei;


    mapping (uint => string) houseNumber;
    mapping (uint => address) rentedTo;
   

    //------------Admin
    function changeAdmin(address _newAdmin) public {
        require(Admin==msg.sender, "Only admin");
        Admin = _newAdmin;
      }
      function withdraw() public {
        require(Admin==msg.sender, "Only admin");
        payable(Admin).transfer(address(this).balance);
    }

    //------------House
    function buildHouse(string calldata _url) public {
        require(Admin==msg.sender, "Only admin");
        houseNumber[houseAmount] = _url;
        _mint(Admin, houseAmount, 1, "");
        houseAmount++;
    }
    function url (uint _houseID) public view returns (string memory){
        require(_houseID<houseAmount, "Not exist");
        return houseNumber[_houseID];
    }
    function rentHouse(uint _houseID, uint _week) public payable{
        require(_houseID<houseAmount, "Not exist");
        require(balanceOf(Admin, _houseID)!=0, "Already rented");
        require(priceForWeek*_week==msg.value, "Not enough funds");
        rentedTo[_houseID] = msg.sender;
        _setApprovalForAll(Admin, msg.sender, true);
        safeTransferFrom(Admin, msg.sender, _houseID, 1, "");
        _setApprovalForAll(Admin, msg.sender, false);
    }
    function houseOwner(uint _houseID) public view returns(address){
        require(_houseID<houseAmount, "Not exist");
        return rentedTo[_houseID];
    }
    function returnHouse(uint _houseID) public {
        require(msg.sender == rentedTo[_houseID], "Only admin");
        safeTransferFrom( msg.sender, Admin, _houseID, 1, "");
        delete rentedTo[_houseID];
    }
    //----------Additional offers
    function cleaningHouse (uint _houseID) public payable{
         require(_houseID<houseAmount, "Not exist");
         require(priceForCleaning==msg.value, "Not enough funds");
    }
     function rentParkingPlace(uint _parkingPlaceID, uint _week) public payable{
        require(_parkingPlaceID<parkingAmount, "Not exist");
        require(balanceOf(Admin, _parkingPlaceID)!=0, "Already rented");
        require(priceForParking*_week==msg.value, "Not enough funds");
        rentedTo[_parkingPlaceID] = msg.sender;
        _setApprovalForAll(Admin, msg.sender, true);
        safeTransferFrom(Admin, msg.sender, _parkingPlaceID, 1, "");
        _setApprovalForAll(Admin, msg.sender, false);
     }
     function returnParkingPlace(uint _parkingPlaceID) public {
        require(msg.sender == rentedTo[_parkingPlaceID], "Only admin");
        safeTransferFrom( msg.sender, Admin, _parkingPlaceID, 1, "");
        delete rentedTo[_parkingPlaceID];
     }
     function orderPizza (uint _houseID) public payable{
         require(_houseID<houseAmount, "Not exist");
         require(priceForPizza==msg.value, "Not enough funds");
     }

}
