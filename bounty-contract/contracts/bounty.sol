// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;
import "OpenZeppelin/openzeppelin-contracts@4.7.3/contracts/access/Ownable.sol";
import "../interfaces/IBounty.sol";

// Smart contract of the git-bounty project:
// This stores and manages the bounty of a specific git project
// Works on any EVM-compatible blockchain

contract Bounty is IBounty,Ownable {
    // Contract version
    function version() external view returns (uint256) {
        return 0x0100;
    }

    // Bounty status
    enum B_STATUS {
        OPEN,
        LOCKED,
        CLOSED,
        CANCELLED
    }

    // Main bounty struct
    struct TB_entry {
        string title;
        B_STATUS status; //open/closed/cancelled/etc
        uint256 amount;
        address paidto;
        string paidtoInfo;
        uint256 createdTime;
        uint256 closedTime;
    }

   uint256 public totalPaid; // Total amount paid by this project
   string public URL; // Project title/URL

   // Bountry data storage
   TB_entry[] bounty_entries;

    // Private project: Only owner can add bounties
    bool isPrivate;

    //Adds a bounty to the array. Initial funding is zero.
    function addBounty(string memory title) external returns (uint256) {
        if (isPrivate) {
            if (msg.sender != owner()) revert("Contract is not public");
        }
        TB_entry memory be;
        be.title = title;
        be.status = B_STATUS.OPEN;
        be.createdTime = block.timestamp;
        bounty_entries.push(be);
        return (bounty_entries.length - 1);
    }

   // Funds a bounty. Anybody can send money to a bounty.
    function fundBounty(uint256 bountyId) external payable {
        TB_entry memory be = bounty_entries[bountyId];
        require(be.status == B_STATUS.OPEN, "Bounty is not open");
        bounty_entries[bountyId].amount += msg.value;
    }

   // Close a bounty. 
   // The bounty funds are sent to the bounty hunter, or to the project owner in case the bounty is cancelled.
    function closeBounty(
        uint256 bountyId,
        address hunter,
        string memory message,
        bool Cancelled
    ) external onlyOwner {
        TB_entry memory be = bounty_entries[bountyId];
        require(be.status == B_STATUS.OPEN, "Bounty is not open");
        uint256 amount = be.amount;
        if (Cancelled == true) {
            be.status = B_STATUS.CANCELLED;
            be.amount = 0;
        } else be.status = B_STATUS.CLOSED;
        be.paidto = hunter;
        be.paidtoInfo = message;
        be.closedTime = block.timestamp;
        bounty_entries[bountyId] = be;
        if (amount > 0) {
            totalPaid+=amount;
            (bool sent, bytes memory data) = hunter.call{value: amount}("");
            require(sent, "Failed to send Ether");
        }
    }

   // A projet can be set as private, meaning only the owner can add issues to it
    function setPrivate(bool isprivate) external onlyOwner {
        require(isPrivate != isprivate, "Invalid operation");
        isPrivate = isprivate;
    }

   // The owner can also set the description of the project
    function setURL(string memory url) external onlyOwner {
      URL = url;
    }

   // Return the balance of the project (total amount of money in open bounties)
    function getBalance() external view 
        returns (uint256) {
        return address(this).balance;
    }

   // Return bounty data
    function getBounties(uint256 minId, uint256 maxId) external view
        returns (TB_entry[] memory)
    {
        TB_entry[] memory lItems = new TB_entry[](maxId - minId);
        for (uint256 i = minId; i < maxId; i++) {
            lItems[i - minId] = bounty_entries[i];
        }
        return lItems;
    }

    // Returns amount of bounties
    function getBountyCount() external view returns (uint256) {
        return bounty_entries.length;
    }
}
