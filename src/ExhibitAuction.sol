// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract ExhibitAuction {
    uint16 constant TIME_BUFFER = 15 minutes;

    uint32 constant MIN_MASK_DURATION = 1 days;
    uint32 constant MAX_MASK_DURATION = 30 days;

    uint16 constant MIN_BID_INCREMENT = 500;

    struct Auction {
        address seller;
        uint96 highestBid;
        address highestBidder;
        uint32 highestBidDuration;
        uint32 endTime;
    }

    /// @notice The auction for a given NFT, if one exists
    /// @dev ERC-721 token contract => ERC-721 token id => Auction
    mapping(address => mapping(uint256 => Auction)) public auctionForNFT;


    function createAuction(
        address _tokenContract,
        uint256 _tokenId
    ) public {
        address tokenOwner = IERC721(_tokenContract).ownerOf(_tokenId);

        auctionForNFT[_tokenContract][_tokenId] = Auction({
            seller: tokenOwner,
            highestBid: 0,
            highestBidder: address(0),
            highestBidDuration: 1,      // divide by zero
            endTime: uint32(block.timestamp + TIME_BUFFER)
        });
    }

    function createBid(
        address _tokenContact,
        uint256 _tokenId,
        uint256 _duration,
        bytes memory _maskData
    ) public payable {
        Auction storage auction = auctionForNFT[_tokenContact][_tokenId];

        // first bidder, auction not created yet
        if (auction.seller == address(0)) {
            createAuction(_tokenContact, _tokenId);
        } else {
            require(block.timestamp < auction.endTime, "Auction has ended");
            require(_duration >= MIN_MASK_DURATION && _duration <= MAX_MASK_DURATION, "Duration invalid");

            // cached
            uint256 highestBidRate = auction.highestBid / auction.highestBidDuration;
            uint256 minValidBidRate = highestBidRate + ((highestBidRate * MIN_BID_INCREMENT) / 10000);

            uint256 bidRate = msg.value / _duration;
            require(bidRate >= minValidBidRate, "Bid too low");

            // refund previous bidder
            address highestBidder = auction.highestBidder;
            if (highestBidder != address(0)) {
                payable(highestBidder).transfer(auction.highestBid);
            }

            auction.endTime = uint32(block.timestamp + TIME_BUFFER);
        }

        auction.highestBid = uint96(msg.value);
        auction.highestBidder = msg.sender;
        auction.highestBidDuration = uint32(_duration);
    }

    function settleAuction(address _tokenContact, uint256 _tokenId) external {
        Auction memory auction = auctionForNFT[_tokenContact][_tokenId];

        require(block.timestamp >= auction.endTime, "Auction not ended");

        // TODO: add as mask to exhibitMask {}
        // ExhibitMask(msg.sender).addPotentialMask();
    }
}
