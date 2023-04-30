// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.17;

import "forge-std/Test.sol";

contract BaseTest is Test {
    string mainnetFork = vm.envString("MAINNET_RPC");
    uint256 mainnet = vm.createFork(mainnetFork);
}
