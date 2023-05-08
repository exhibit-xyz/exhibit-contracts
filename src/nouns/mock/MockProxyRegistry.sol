// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

import {IProxyRegistry} from "@nouns-contracts/external/opensea/IProxyRegistry.sol";

contract MockProxyRegistry is IProxyRegistry {
    function proxies(address) external view returns (address) {
        return address(0);
    }
}
