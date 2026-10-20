// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "./Interfaces/IV2Router02.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract SwapApp {
    using SafeERC20 for IERC20;

    address public V2Router02Address;
    event SwapTokens(address tokenIn, address tokenOut, uint256 amountIn, uint256 amountOut);

    constructor(address _V2Router02Address) {
        V2Router02Address = _V2Router02Address;
    }

    function swapTokens(
        uint256 amountIn_,
        uint256 amountOutMin_,
        address[] memory path_,
        uint256 deadline_
    ) external {
        require(deadline_ >= block.timestamp, "SwapApp: Expired deadline");
        require(amountIn_ > 0, "SwapApp: Amount must be > 0");

        IERC20(path_[0]).safeTransferFrom(msg.sender, address(this), amountIn_);
        IERC20(path_[0]).forceApprove(V2Router02Address, amountIn_);
        
        uint[] memory amountOuts = IV2Router02(V2Router02Address).swapExactTokensForTokens(
            amountIn_,
            amountOutMin_,
            path_,
            msg.sender,
            deadline_
        );
        
        emit SwapTokens(path_[0], path_[path_.length - 1], amountIn_, amountOuts[amountOuts.length - 1]);
    }
}