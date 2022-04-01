// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./IComptroller.sol";
import "./ICToken.sol";
import "./IPriceOracle.sol";

contract RajaMotoDefi {
    ComptrollerInterface public comptroller;
    PriceOracleInterface public priceOracle;

    constructor(address _comptroller, address _priceOracle) public {
        comptroller = ComptrollerInterface(_comptroller);
        priceOracle = PriceOracleInterface(_priceOracle);
    }

    function supply(address cTokenAddress, uint256 underlyingAmount) public {
        CTokenInterface cToken = CTokenInterface(cTokenAddress);
        address underlyingAddress = cToken.underlying();
        IERC20(underlyingAddress).approve(cTokenAddress, underlyingAmount);
        uint256 result = cToken.mint(underlyingAmount);

        require(result == 0, "CToken.mint is not working");
    }

    function reedem(address cTokenAddress, uint256 cTokenAmount) external {
        CTokenInterface cToken = CTokenInterface(cTokenAddress);
        uint256 result = cToken.redeem(cTokenAmount);
        require(result == 0, "CToken.reedem is not working");
    }

    function enterMarkets(address cTokenAddress) external {
        address[] memory markets = new address[](1);
        markets[0] = cTokenAddress;
        uint256[] memory result = comptroller.enterMarkets(markets);
        require(result[0] == 0, "CToken.enterMarkets is not working");
    }

    function borrow(address cTokenAddress, uint256 borrowAmount) external {
        CTokenInterface cToken = CTokenInterface(cTokenAddress);
        uint256 result = cToken.borrow(borrowAmount);
        require(result == 0, "CToken.borrow is not working");
    }

    function repayBorrow(address cTokenAddress, uint256 underlyingAmount)
        external
    {
        CTokenInterface cToken = CTokenInterface(cTokenAddress);
        address underlyingAddress = cToken.underlying();
        IERC20(underlyingAddress).approve(cTokenAddress, underlyingAmount);
        uint256 result = cToken.repayBorrow(underlyingAmount);
        require(result == 0, "CToken.repayBorrow is not working");
    }

    function getMaxBorrowable(address cTokenAddress)
        external
        view
        returns (uint256)
    {
        (uint256 result, uint256 liquidity, uint256 shortfall) = comptroller
            .getAccountLiquidity(address(this));

        require(result == 0, "Comptroller.getAccountLiquidity is not working");
        require(shortfall == 0, "Account Underwater");
        require(liquidity > 0, "Account does not have Collateral");

        uint256 underlyingPrice = priceOracle.getUnderlyingPrice(cTokenAddress);
        return liquidity / underlyingPrice;
    }
}
