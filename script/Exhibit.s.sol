// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {ExhibitBase} from "src/nouns/ExhibitBase.sol";
import {ExhibitArt} from 'src/nouns/ExhibitArt.sol';

contract ExhibitScript is Script {
    uint256 privateKey = vm.envUint("DEPLOYER_KEY");
    address mocktoken = vm.envAddress("MOCK_NOUN_TOKEN");
    address mockArt = vm.envAddress("MOCK_NOUN_ART");

    ExhibitBase baseToken;
    ExhibitArt ea;

    function setUp() public {

    }

    function run() public {
        vm.startBroadcast(privateKey);

        ea = new ExhibitArt(mockArt);
        baseToken = new ExhibitBase(mocktoken);

        baseToken.setArt(ea);

        vm.stopBroadcast();
    }
}
