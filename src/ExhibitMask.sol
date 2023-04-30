// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


contract ExhibitMask {
    uint256 constant INCLUSION_BUFFER = 1 hours;

    struct Mask {
        bytes data;
        address benefitor;
        uint96 payout;
        uint32 duration;
        uint32 inclusionDeadline;
    }

    mapping(address => mapping(uint256 => Mask)) public nextMasks;

    function bidForMask(
        address _tokenContract,
        uint256 _tokenId,
        uint256 _duration,
        bytes memory _maskData
    ) public payable {
        // TODO: call auction
    }
    function bidForMaskCallback(
        address _tokenContract,
        uint256 _tokenId,
        uint96 payout,
        uint32 _duration,
        bytes calldata _maskData
    ) external {
        nextMasks[_tokenContract][_tokenId] = Mask({
            data: _maskData,
            benefitor: msg.sender,
            payout: payout,
            duration: _duration,
            inclusionDeadline: uint32(block.timestamp + INCLUSION_BUFFER)
        });
    }

    function acceptMask(
        address _tokenContract,
        uint256 _tokenId
    ) external {
        // TODO: check owner of token
        // TODO: check if within timelock

        // start streaming payout

        // apply mask to base
    }

    function _applyMask(
        address _tokenContract,
        uint256 _tokenId,
        bytes memory _maskData
    ) internal {}
}
