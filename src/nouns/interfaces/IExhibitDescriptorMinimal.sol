// SPDX-License-Identifier: GPL-3.0
/// @title Common interface for NounsDescriptor versions, as used by NounsToken and NounsSeeder.
pragma solidity ^0.8.6;

import { IExhibitUtils } from './IExhibitUtils.sol';

interface IExhibitDescriptorMinimal {
    ///
    /// USED BY TOKEN
    ///

    function dataURI(uint256 tokenId, IExhibitUtils.Attributes memory attributes) external view returns (string memory);

    function generateSVGImage(IExhibitUtils.Attributes memory attributes) external view returns (string memory);

    ///
    /// USED BY SEEDER
    ///

    // function backgroundCount() external view returns (uint256);

    // function bodyCount() external view returns (uint256);

    // function accessoryCount() external view returns (uint256);

    // function headCount() external view returns (uint256);

    // function glassesCount() external view returns (uint256);
}
