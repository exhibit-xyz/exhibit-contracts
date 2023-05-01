# Design doc (brainstorming)

One-line description: Embedding ads into existing NFTs to help a product or a brand get to the right audience.

## Problem

## Solution

## Plan

### Implementation details

- Can we add a attribute in a NFT’s metadata acting like an ad for specific time period?
- Maybe follow Liquid delegate style of escrowing NFTs for a period of time?


#### Indexing

- Instead of using Graph's subgraph, we may need to spin up our own indexing tool?
  - Need to pull from two different projects Nouns and Exhibit (both with multiple contracts) which maye be on different networks
  - example, Nouns data is on Mainnet and say we test it on Sepolia, we need to query from Mainnet, replicate nouns contracts on Sepolia and then only we can use exhibit
  - plus, testing locally with anvil has been an issue with the Graph
  - either try subsquid or rollup our own indexer

- Basic requirements
  - Nouns - tokenURI, current owner
  - Exhibit
    - Auction - current bid, ended or not
    - Mask - potential mask
    - Base - tokenURI, when expiry, owner, advertiser, redirect link
