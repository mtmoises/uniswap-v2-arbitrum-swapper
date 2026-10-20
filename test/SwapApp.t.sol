// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SwapApp} from "../src/SwapApp.sol";

contract SwapAppTest is Test {
    SwapApp public app;
    address public user;

    address constant USDC = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831;
    address constant DAI  = 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1;

    function setUp() public {
        app = new SwapApp(0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24);
        user = makeAddr("user");
    }

    function testSwapTokensCorrectly() public {
        uint256 amountIn = 1 * 1e6;
        deal(USDC, user, amountIn);

        vm.startPrank(user);
        IERC20(USDC).approve(address(app), amountIn);

        uint256 deadline = block.timestamp + 1000;
        address[] memory path = new address[](2);
        path[0] = USDC;
        path[1] = DAI;

        uint256 USDCBalanceBefore = IERC20(USDC).balanceOf(user);
        uint256 DAIBalanceBefore  = IERC20(DAI).balanceOf(user);

        uint256 amountOutMin = 0;
        app.swapTokens(amountIn, amountOutMin, path, deadline);

        uint256 USDCBalanceAfter = IERC20(USDC).balanceOf(user);
        uint256 DAIBalanceAfter  = IERC20(DAI).balanceOf(user);

        assert(USDCBalanceAfter == USDCBalanceBefore - amountIn);
        assert(DAIBalanceAfter > DAIBalanceBefore);

        vm.stopPrank();
    }

    function testRevertIfDeadlineExpired() public {
        uint256 amountIn = 1 * 1e6;
        uint256 amountOutMin = 0;
        uint256 deadline = block.timestamp - 1;
        
        address[] memory path = new address[](2);
        path[0] = USDC;
        path[1] = DAI;

        vm.startPrank(user);
        
        vm.expectRevert("SwapApp: Expired deadline");
        app.swapTokens(amountIn, amountOutMin, path, deadline);
        
        vm.stopPrank();
    }

    function testRevertIfAmountIsZero() public {
        uint256 amountIn = 0;
        uint256 amountOutMin = 0;
        uint256 deadline = block.timestamp + 1000;
        
        address[] memory path = new address[](2);
        path[0] = USDC;
        path[1] = DAI;

        vm.startPrank(user);
        
        vm.expectRevert("SwapApp: Amount must be > 0");
        app.swapTokens(amountIn, amountOutMin, path, deadline);
        
        vm.stopPrank();
    }
}