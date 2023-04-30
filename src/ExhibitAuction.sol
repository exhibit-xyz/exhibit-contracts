// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract ExhibitAuction {
    uint16 constant TIME_BUFFER = 15 minutes;
    uint16 constant MIN_BID_INCREMENT = 500;

    struct Auction {
        address seller;
        uint96 highestBid;
        address highestBidder;
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
            endTime: uint32(block.timestamp + TIME_BUFFER)
        });
    }

    function createBid(
        address _tokenContact,
        uint256 _tokenId
    ) public payable {
        Auction storage auction = auctionForNFT[_tokenContact][_tokenId];

        // first bidder, auction not created yet
        if (auction.seller == address(0)) {
            createAuction(_tokenContact, _tokenId);
        } else {
            require(block.timestamp < auction.endTime, "Auction has ended");

            // cached
            uint256 highestBid = auction.highestBid;
            uint256 minValidBid = highestBid + ((highestBid * MIN_BID_INCREMENT) / 10000);

            require(msg.value >= minValidBid, "Bid too low");

            // refund previous bidder
            address highestBidder = auction.highestBidder;
            if (highestBidder != address(0)) {
                payable(highestBidder).transfer(highestBid);
            }

            auction.endTime = uint32(block.timestamp + TIME_BUFFER);
        }

        auction.highestBid = uint96(msg.value);
        auction.highestBidder = msg.sender;
    }

    function settleAuction(address _tokenContact, uint256 _tokenId) external {
        Auction memory auction = auctionForNFT[_tokenContact][_tokenId];

        require(block.timestamp >= auction.endTime, "Auction not ended");

        // add as mask to exhibitMask {}
        // add to mask the mapping for payments
    }
}
