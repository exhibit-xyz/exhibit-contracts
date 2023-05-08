// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";


import {NounsToken} from "@nouns-contracts/NounsToken.sol";
import {SVGRenderer} from "@nouns-contracts/SVGRenderer.sol";

import {ExhibitBase} from "src/nouns/ExhibitBase.sol";
import {ExhibitArt} from 'src/nouns/ExhibitArt.sol';
import {ExhibitDescriptor} from "src/nouns/ExhibitDescriptor.sol";

contract ExhibitScript is Script {
    uint256 privateKey = vm.envUint("DEPLOYER_KEY");
    address mocktoken = vm.envAddress("MOCK_NOUN_TOKEN");
    address mockArt = vm.envAddress("MOCK_NOUN_ART");

    NounsToken nouns;
    SVGRenderer renderer;

    ExhibitDescriptor descriptor;
    ExhibitBase baseToken;
    ExhibitArt ea;

    function setUp() public {}

    function run() public {
        vm.startBroadcast(privateKey);

        nouns = NounsToken(mocktoken);

        renderer = new SVGRenderer();
        descriptor = new ExhibitDescriptor(renderer);
        nouns = NounsToken(mocktoken);

        ea = new ExhibitArt(mockArt);
        baseToken = new ExhibitBase(nouns, descriptor);

        descriptor.transferOwnership(address(baseToken));
        baseToken.setArt(ea);

        vm.stopBroadcast();
    }
}
