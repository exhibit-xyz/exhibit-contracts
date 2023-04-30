// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {ExhibitAuction} from "./ExhibitAuction.sol";
import {ExhibitBase} from "./ExhibitBase.sol";


contract ExhibitMask {
    uint256 constant INCLUSION_BUFFER = 1 hours;

    ExhibitAuction public auction;
    ExhibitBase public baseToken;

    uint48 public nextMaskId = 1;

    constructor(ExhibitAuction _auction, ExhibitBase _baseToken) {
        auction = _auction;
        baseToken = _baseToken;
    }

    struct Mask {
        bytes data;
        address benefitor;
        uint96 payout;
        uint32 duration;
        uint32 inclusionDeadline;
    }

    mapping(address => mapping(uint256 => Mask)) public nextMasks;

    function pickWinner(
        address _tokenContract,
        uint256 _tokenId
    ) public {
        (uint96 payout, uint32 duration, bytes memory maskData) = auction.settleAuction(_tokenContract, _tokenId);

        nextMasks[_tokenContract][_tokenId] = Mask({
            data: maskData,
            benefitor: msg.sender,
            payout: payout,
            duration: duration,
            inclusionDeadline: uint32(block.timestamp + INCLUSION_BUFFER)
        });
    }

    function acceptMask(
        address _tokenContract,
        uint256 _tokenId
    ) external {
        require(
            block.timestamp <= nextMasks[_tokenContract][_tokenId].inclusionDeadline,
            "Mask inclusion deadline passed"
        );
        _applyMask(_tokenContract, _tokenId, nextMasks[_tokenContract][_tokenId].data);

        // start streaming payout
    }

    function _applyMask(
        address /*_tokenContract*/,
        uint256 _tokenId,
        bytes memory _maskData
    ) internal {
        if (baseToken.ownerOf(_tokenId) != msg.sender) {
            baseToken.upgrade(msg.sender, _tokenId);
        }
        // apply mask to base
        baseToken.applyMask(_tokenId, nextMaskId, _maskData);
        nextMaskId += 1;
    }
}
