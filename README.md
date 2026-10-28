# 🦄 Uniswap V2 Token Swapper (Arbitrum Network)

A production-ready, gas-optimized Smart Contract designed for automated token swaps on Uniswap V2 protocol (and forks like Sushiswap) deployed on Arbitrum One. 

Built with **Solidity 0.8.24**, leveraging **OpenZeppelin SafeERC20** for secure token transfers and robust error handling.

---

## 📌 Architecture & Features

- **Safe Token Transfer Engine:** Implements OpenZeppelin's `SafeERC20` with `forceApprove` to handle non-standard ERC-20 tokens securely.
- **DEX Routing Integration:** Directly interfaces with the `IV2Router02` to execute exact-input token swaps (`swapExactTokensForTokens`).
- **Slippage & Expiration Protection:** Enforces minimum amount out (`amountOutMin_`) and deadline checks (`deadline_`) to prevent front-running and bad execution.
- **Event Logging:** Emits a `SwapTokens` event on every execution for real-time frontend tracking and off-chain indexing (The Graph / Subgraphs).

---

## 🛠 Tech Stack & Tools

- **Language:** Solidity `0.8.24`
- **Framework:** Foundry / Hardhat
- **Libraries:** OpenZeppelin Contracts (SafeERC20, IERC20)
- **Target Chain:** Arbitrum One (EVM Compatible)

---

## 🚀 Smart Contract Details

### Key Function: `swapTokens`

```solidity
function swapTokens(
    uint256 amountIn_,
    uint256 amountOutMin_,
    address[] memory path_,
    uint256 deadline_
) external

```shell
$ forge --help
$ anvil --help
$ cast --help
```
