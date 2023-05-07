// SPDX-License-Identifier: GPL-3.0

/// @title Mock NounsToken replicated for testing purposes

pragma solidity ^0.8.6;

import {Ownable} from '@openzeppelin/contracts/access/Ownable.sol';
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {NounsToken} from "@nouns-contracts/NounsToken.sol";
import {INounsSeeder} from "@nouns-contracts/interfaces/INounsSeeder.sol";
import {INounsDescriptorMinimal} from '@nouns-contracts/interfaces/INounsDescriptorMinimal.sol';
import {IProxyRegistry} from "@nouns-contracts/external/opensea/IProxyRegistry.sol";

contract MockNounsToken is NounsToken {

    struct Seed {
        uint48 background;
        uint48 body;
        uint48 accessory;
        uint48 head;
        uint48 glasses;
    }

    // The noun seeds
    mapping(uint256 => Seed) public mockSeeds;

    mapping (uint256 => string) public baseURI;

    // The internal noun ID tracker
    uint256 private _currentNounId;

    constructor(
        INounsDescriptorMinimal _descriptor,
        INounsSeeder _seeder,
        IProxyRegistry _proxyRegistry
    ) NounsToken(
        address(0x0),
        msg.sender,
        _descriptor,
        _seeder,
        _proxyRegistry
        ) {}

    /**
     * @notice Mint a Noun to the minter, along with a possible nounders reward
     * Noun. Nounders reward Nouns are minted every 10 Nouns, starting at 0,
     * until 183 nounder Nouns have been minted (5 years w/ 24 hour auctions).
     * @dev Call _mintTo with the to address(es).
     */
    function mockMint(
        uint48 background,
        uint48 body,
        uint48 accessory,
        uint48 head,
        uint48 glasses
    ) public onlyMinter returns (uint256) {
        INounsSeeder.Seed memory seed = seeds[_currentNounId] = INounsSeeder.Seed({
            background: background,
            body: body,
            accessory: accessory,
            head: head,
            glasses: glasses
        });

        return _mintTo(minter, _currentNounId++, seed);
    }

    /**
     * @notice A distinct Uniform Resource Identifier (URI) for a given asset.
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function mockTokenURI(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), 'NounsToken: URI query for nonexistent token');

        return baseURI[tokenId];
    }

    function setTokenURI(uint256 tokenId, string memory _tokenURI) public onlyMinter {
        require(_exists(tokenId), 'NounsToken: URI set for nonexistent token');

        baseURI[tokenId] = _tokenURI;
    }

    /**
     * @notice Similar to `tokenURI`, but always serves a base64 encoded data URI
     * with the JSON contents directly inlined.
     */
    function mockDataURI(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), 'NounsToken: URI query for nonexistent token');

        return baseURI[tokenId];
    }

    /**
     * @notice Mint a Noun with `nounId` to the provided `to` address.
     */
    function _mintTo(
        address to,
        uint256 nounId,
        INounsSeeder.Seed memory seed
    ) internal returns (uint256) {
        _mint(owner(), to, nounId);
        emit NounCreated(nounId, seed);

        return nounId;
    }
}
