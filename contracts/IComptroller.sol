// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

interface ComptrollerInterface {
    function enterMarkets(address[] calldata cTokens)
        external
        returns (uint256[] memory);

    function getAccountLiquidity(address owner)
        external
        view
        returns (
            uint256,
            uint256,
            uint256
        );
}
