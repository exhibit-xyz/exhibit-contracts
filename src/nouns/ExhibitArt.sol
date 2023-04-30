// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import { SSTORE2 } from '@nouns-contracts/libs/SSTORE2.sol';
import {INounsArt} from '@nouns-contracts/interfaces/INounsArt.sol';
import './interfaces/IExhibitArt.sol';

contract ExhibitArt is IExhibitArt {


    address NOUNS_ART_CONTRACT = 0x48A7C62e2560d1336869D6550841222942768C49;

    /// @notice Current inflator address
    IInflator public inflator = IInflator(0xa2acee85Cd81c42BcAa1FeFA8eD2516b68872Dbe);

    /// @notice Noun Masks Trait
    Trait public masksTrait;

    mapping (uint48 => bytes) public masks;

    function backgrounds(uint256 index) external view returns (string memory) {
        return INounsArt(NOUNS_ART_CONTRACT).backgrounds(index);
    }

    function heads(uint256 index) external view returns (bytes memory) {
        return INounsArt(NOUNS_ART_CONTRACT).heads(index);
    }

    function bodies(uint256 index) external view returns (bytes memory) {
        return INounsArt(NOUNS_ART_CONTRACT).bodies(index);
    }

    function accessories(uint256 index) external view returns (bytes memory) {
        return INounsArt(NOUNS_ART_CONTRACT).accessories(index);
    }

    function glasses(uint256 index) external view returns (bytes memory) {
        return INounsArt(NOUNS_ART_CONTRACT).glasses(index);
    }

    function palettes(uint8 paletteIndex) external view returns (bytes memory) {
        return INounsArt(NOUNS_ART_CONTRACT).palettes(paletteIndex);
    }

    function addMask(uint48 index, bytes calldata encodedCompressed) external {
        masks[index] = encodedCompressed;
    }


    function imageByIndex(IExhibitArt.Trait storage trait, uint256 index) internal view returns (bytes memory) {
        (IExhibitArt.NounArtStoragePage storage page, uint256 indexInPage) = getPage(trait.storagePages, index);
        bytes[] memory decompressedImages = decompressAndDecode(page);
        return decompressedImages[indexInPage];
    }

    /**
     * @dev Given an image index, this function finds the storage page the image is in, and the relative index
     * inside the page, so the image can be read from storage.
     * Example: if you have 2 pages with 100 images each, and you want to get image 150, this function would return
     * the 2nd page, and the 50th index.
     * @return IExhibitArt.NounArtStoragePage the page containing the image at index
     * @return uint256 the index of the image in the page
     */
    function getPage(IExhibitArt.NounArtStoragePage[] storage pages, uint256 index)
        internal
        view
        returns (IExhibitArt.NounArtStoragePage storage, uint256)
    {
        uint256 len = pages.length;
        uint256 pageFirstImageIndex = 0;
        for (uint256 i = 0; i < len; i++) {
            IExhibitArt.NounArtStoragePage storage page = pages[i];

            if (index < pageFirstImageIndex + page.imageCount) {
                return (page, index - pageFirstImageIndex);
            }

            pageFirstImageIndex += page.imageCount;
        }

        revert ImageNotFound();
    }

    function decompressAndDecode(IExhibitArt.NounArtStoragePage storage page) internal view returns (bytes[] memory) {
        bytes memory compressedData = SSTORE2.read(page.pointer);
        (, bytes memory decompressedData) = inflator.puff(compressedData, page.decompressedLength);
        return abi.decode(decompressedData, (bytes[]));
    }

    fallback() external payable {
        (bool success, ) = NOUNS_ART_CONTRACT.call(msg.data);
    }
}
