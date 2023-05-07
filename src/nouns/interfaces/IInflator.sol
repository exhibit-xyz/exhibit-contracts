// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.6;

import { Inflate } from '../../lib/Inflate.sol';

/// @title Interface for Inflator contract.
interface IInflator {
    function puff(bytes memory source, uint256 destlen) external pure returns (Inflate.ErrorCode, bytes memory);
}
