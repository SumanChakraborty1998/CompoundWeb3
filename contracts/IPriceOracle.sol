// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

interface PriceOracleInterface {
    function getUnderlyingPrice(address asset) external view returns (uint256);
}
