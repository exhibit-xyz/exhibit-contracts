// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {ExhibitBase} from "src/nouns/ExhibitBase.sol";
import {ExhibitArt} from 'src/nouns/ExhibitArt.sol';

contract ExhibitScript is Script {
    uint256 privateKey = vm.envUint("DEPLOYER_KEY");
    address mainnetToken = vm.envAddress("MAINNET_NOUN_TOKEN");
    address mainnetArt = vm.envAddress("MAINNET_NOUN_ART");

    ExhibitBase baseToken;
    ExhibitArt ea;

    function setUp() public {

    }

    function run() public {
        vm.startBroadcast(privateKey);

        ea = new ExhibitArt(mainnetArt);
        baseToken = new ExhibitBase(mainnetToken);

        baseToken.setArt(ea);

        vm.stopBroadcast();
    }
}
