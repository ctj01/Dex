// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract FlashLoan is FlashLoanSimpleReceiverBase {
    address payable owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Ownable: caller is not the owner");
        _;
    }
    constructor(
        address provider
    ) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(provider)) {
        owner = payable(msg.sender);
    }
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address,
        bytes calldata
    ) external override returns (bool) {
        uint256 totalDebt = amount + premium;
        IERC20(asset).approve(address(POOL), totalDebt);
        return true;
    }
    function requestFlashLoan(address asset, uint256 amount) public {
        bytes memory params = abi.encode(asset, amount);
        uint16 referrerCode = 0;

        POOL.flashLoanSimple(
            address(this),
            asset,
            amount,
            params,
            referrerCode
        );
    }
    function withdraw(address asset, uint256 amount) public onlyOwner {
        IERC20(asset).transfer(owner, amount);
    }
    function getBalance(address asset) public view returns (uint256) {
        return IERC20(asset).balanceOf(address(this));
    }
    receive() external payable {}
}
