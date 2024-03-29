// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//import "@openzeppelin/contracts/access/Ownable.sol";


contract Beneficiary {
    address public depositor;
    address public arbiter;
    uint amount;
    bool public servicesDone;

    modifier onlyArbiter() {
        require(msg.sender == arbiter, "NotAuthorized");
        _;
    }

    event Deposit(address indexed beneficiary, uint amount);
    event Approved(uint amount);
    event ServicesToggled(bool status);

    constructor(address _arbiter) payable {
        arbiter = _arbiter;
        depositor = msg.sender;
        amount = msg.value;

        emit Deposit(msg.sender, amount);
    }

    function toggleServices() external onlyArbiter {
        servicesDone = !servicesDone;
        emit ServicesToggled(servicesDone);
    }

    function transferToBeneficiary() external onlyArbiter {
        require(servicesDone, "ServicesNotDone");

        (bool success, ) = depositor.call{ value: amount }("");
        require(success, "Transfer to beneficiary failed");

        emit Approved(amount);
    }

   // function getBeneficiary() external view returns (address) {
   //     return beneficiary;
    //}
    receive() external payable {}
}