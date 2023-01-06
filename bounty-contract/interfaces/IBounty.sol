// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

interface IBounty {

function version() external view returns (uint256);
function getBountyCount() external view returns (uint256);
function getBalance() external view returns (uint256);

}
