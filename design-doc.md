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

#### MUD

- software stack for
- client and smart contact state is always in sync
- system vs state - like ECS
- central world control and everything is an entity

- full-nodes - get direct access of on-chain data
- normally dapps can't simulate tx, rely on infura and depend on events
- cache state and need custom code to be kept in sync
- mAke slow network requests
- no remote indexers

- can we do better?
- standalone apps - need to be standalone with no external dependencies
- namespaced full-nodes

- MUD is a key value online db - contextialized data for each app
- ships with local evm, make tx -> runs evm and inject ecs state and registers sideeffects
- match with predicted local state - Ok()
- prediction and rollbacks
- add new extnesions but don't need a client and indexer
- 1st party and third party code

- single entry point contract
- anyone can register components and entities and found easily
- augmented reality - create layers for a subset of players, not breaching a rules "experiencing the world in different realities"



