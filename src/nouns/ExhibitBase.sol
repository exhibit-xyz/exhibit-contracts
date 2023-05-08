// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Ownable} from '@openzeppelin/contracts/access/Ownable.sol';
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import {INounsSeeder} from '@nouns-contracts/interfaces/INounsSeeder.sol';
import {NounsToken} from "@nouns-contracts/NounsToken.sol";

import {IExhibitBase} from '../lib/IExhibitBase.sol';
import {ExhibitDescriptor} from './ExhibitDescriptor.sol';
import {IExhibitUtils} from './interfaces/IExhibitUtils.sol';
import {ExhibitArt} from './ExhibitArt.sol';

import "forge-std/console.sol";


contract ExhibitBase is  IExhibitBase, Ownable, ERC721 {
    address public FREE_NOUNS;

    mapping (uint256 => IExhibitUtils.Attributes) public attributes;
    mapping (uint256 => bool) public activeMasks;

    // @dev trying to keep everything Nouns specific in this contract for now
    ExhibitArt public art;
    ExhibitDescriptor public descriptor;

    constructor(address _nounsContract) ERC721("Exhibit Nouns", "NOUNS") {
        descriptor = new ExhibitDescriptor();
        FREE_NOUNS = _nounsContract;
    }

    function upgrade(address owner, uint256 tokenId) external {
        // ONLY FOR TESTING
        if (true || NounsToken(FREE_NOUNS).ownerOf(tokenId) == owner) {
            _mint(owner, tokenId);
            console.log("minted %s to %s", tokenId, owner);
            (uint48 background, uint48 body, uint48 accessory, uint48 head, uint48 glasses) = NounsToken(FREE_NOUNS).seeds(tokenId);
            console.log("attributes: ", background, " ", body);
            attributes[tokenId] = IExhibitUtils.Attributes(background, body, accessory, head, glasses, 0);
        }
    }

    function applyMask(uint256 _tokenId, uint48 maskIndex, bytes calldata data) external {
        art.addMask(maskIndex, data);
        attributes[_tokenId].mask = maskIndex;
    }

    function isValidMask() external view returns (bool) {
        return true;
    }
    /**
     * @notice A distinct Uniform Resource Identifier (URI) for a given asset.
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(ownerOf(tokenId) == msg.sender, 'NounsToken: URI query for nonexistent token');
        return descriptor.dataURI(tokenId, attributes[tokenId]);
    }

    // function setDescriptor(ExhibitDescriptor _descriptor) external onlyOwner {
    //     descriptor = _descriptor;
    // }

    function setArt(ExhibitArt _art) external onlyOwner {
        art = _art;
        descriptor.setArt(_art);
    }

    function genSVGTest(uint256 tokenId) external view returns (string memory) {
        return descriptor.generateSVGImage(attributes[tokenId]);
    }
}
