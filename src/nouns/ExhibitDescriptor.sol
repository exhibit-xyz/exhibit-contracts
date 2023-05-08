// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import {Strings} from '@openzeppelin/contracts/utils/Strings.sol';
import {Ownable} from '@openzeppelin/contracts/access/Ownable.sol';

import {SVGRenderer} from '@nouns-contracts/SVGRenderer.sol';
import {ISVGRenderer} from '@nouns-contracts/interfaces/ISVGRenderer.sol';
import {NFTDescriptorV2} from "@nouns-contracts/libs/NFTDescriptorV2.sol";

import './interfaces/IExhibitUtils.sol';
import {IExhibitDescriptorMinimal} from './interfaces/IExhibitDescriptorMinimal.sol';
import {ExhibitArt} from './ExhibitArt.sol';

import "forge-std/console.sol";

contract ExhibitDescriptor is Ownable, IExhibitDescriptorMinimal {
    using Strings for uint256;

    /// @notice The contract responsible for holding compressed Noun art
    ExhibitArt public art;

    /// @notice The contract responsible for constructing SVGs
    SVGRenderer public renderer;

    constructor(SVGRenderer _renderer) {
        renderer = _renderer;
    }

    /**
     * @notice Given a token ID and seed, construct a base64 encoded data URI for an official Nouns DAO noun.
     */
    function dataURI(uint256 tokenId, IExhibitUtils.Attributes memory attributes) public view returns (string memory) {
        string memory nounId = tokenId.toString();
        string memory name = string(abi.encodePacked('Noun ', nounId));
        string memory description = string(abi.encodePacked('Noun ', nounId, ' is a member of the Nouns DAO'));
        console.log(description);

        return genericDataURI(name, description, attributes);
    }

    /**
     * @notice Given a name, description, and seed, construct a base64 encoded data URI.
     */
    function genericDataURI(
        string memory name,
        string memory description,
        IExhibitUtils.Attributes memory attributes
    ) public view returns (string memory) {
        NFTDescriptorV2.TokenURIParams memory params = NFTDescriptorV2.TokenURIParams({
            name: name,
            description: description,
            parts: getParts(attributes),
            background: art.backgrounds(attributes.background)
        });
        return NFTDescriptorV2.constructTokenURI(renderer, params);
    }

    /**
     * @notice Get all Noun parts for the passed `seed`.
     */
    function getParts(IExhibitUtils.Attributes memory attributes) public view returns (SVGRenderer.Part[] memory) {
        // bytes memory body = art.bodies(attributes.body);
        bytes memory body = hex"0015171f093a0101000d0101000d0101000d0101000d0101000d0101000d0101000b01";
        bytes memory accessory = art.accessories(attributes.accessory);
        bytes memory head = art.heads(attributes.head);
        bytes memory glasses_ = art.glasses(attributes.glasses);

        bytes memory mask = art.masks(attributes.mask);
        console.logBytes(mask);

        ISVGRenderer.Part[] memory parts = new ISVGRenderer.Part[](5);
        parts[0] = ISVGRenderer.Part({ image: body, palette: _getPalette(body) });
        parts[1] = ISVGRenderer.Part({ image: accessory, palette: _getPalette(accessory) });
        parts[2] = ISVGRenderer.Part({ image: head, palette: _getPalette(head) });
        parts[3] = ISVGRenderer.Part({ image: glasses_, palette: _getPalette(glasses_) });
        parts[4] = ISVGRenderer.Part({ image: mask, palette: _getPalette(head) });
        console.log("get parts");
        return parts;
    }

    function generateSVGImage(IExhibitUtils.Attributes memory attributes) external view returns (string memory) {
        ISVGRenderer.SVGParams memory params = ISVGRenderer.SVGParams({
            parts: getParts(attributes),
            background: art.backgrounds(attributes.background)
        });
        console.log(renderer.generateSVG(params));
        return NFTDescriptorV2.generateSVGImage(renderer, params);
    }

    /**
     * @notice Get the color palette pointer for the passed part.
     */
    function _getPalette(bytes memory part) private view returns (bytes memory) {
        return art.palettes(uint8(part[0]));
    }

    /**
     * @notice Set the art contract.
     * @dev Only callable by the owner when not locked.
     */
    function setArt(ExhibitArt _art) external onlyOwner {
        art = _art;
    }
}
