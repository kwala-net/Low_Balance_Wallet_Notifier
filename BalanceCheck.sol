// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Native POL balance checker (Polygon)
/// @notice Emits an event if a user's native POL balance is below 0.1 POL.
contract PolNativeBalanceChecker {
    // 1 POL == 1 ether in EVM units; 0.1 POL is 0.1 ether.
    uint256 public constant THRESHOLD = 0.1 ether;

    event LowPolBalance(address indexed user, uint256 balanceWei);

    /// @notice Read-only helper to get any address's native POL balance.
    function polBalanceOf(address user) public view returns (uint256) {
        return user.balance; // Wei
    }

    /// @notice Checks `user` balance and emits LowPolBalance if below 0.1 POL.
    /// @return balanceWei The user's current balance in wei.
    function checkAndWarn(address user) public returns (uint256 balanceWei) {
        balanceWei = user.balance;
        if (balanceWei < THRESHOLD) {
            emit LowPolBalance(user, balanceWei);
        }
    }

    /// @notice Convenience for the caller; checks your own balance and may emit.
    function checkMe() external returns (uint256) {
        return checkAndWarn(msg.sender);
    }
}
