// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import "forge-std/Test.sol";

import {NounsToken} from "@nouns-contracts/NounsToken.sol";
import {SVGRenderer} from "@nouns-contracts/SVGRenderer.sol";

import {ExhibitBase} from "src/nouns/ExhibitBase.sol";
import {ExhibitDescriptor} from "src/nouns/ExhibitDescriptor.sol";
import {ExhibitArt} from 'src/nouns/ExhibitArt.sol';

contract TestnetExhibitTest is Test {
    address mocktoken = vm.envAddress("MOCK_NOUN_TOKEN");
    address mockArt = vm.envAddress("MOCK_NOUN_ART");

    NounsToken nouns;

    ExhibitBase nb;
    ExhibitArt ea;
    ExhibitDescriptor descriptor;
    SVGRenderer renderer;

    address ALICE = 0xD9e424871cdf9cA51FCdaf694495c00Aa39ceF4b;

    bytes mcdonald_hat = hex"00041a0a0703000b5606000f560300085601270156012706560200075601270156012701560127055602000156018a055601270156012701560127055602000156018a0f5602000156018a01561039";

    string testnetFork = vm.envString("TESTNET_RPC");
    uint256 testnet = vm.createFork(testnetFork);

    function setUp() public {
        vm.selectFork(testnet);

        nouns = NounsToken(mocktoken);

        renderer = new SVGRenderer();
        descriptor = new ExhibitDescriptor(renderer);

        nb = new ExhibitBase(nouns, descriptor);
        ea = new ExhibitArt(mockArt);

        descriptor.transferOwnership(address(nb));
        nb.setArt(ea);

        // ea.addMask(0, mcdonald_hat);

        startHoax(ALICE);
    }

    function testApplyMask() public {
        nb.upgrade(ALICE, 701);
        // nb.applyMask(701, 1, mcdonald_hat);


        console.log(nb.tokenURI(701));
        // nb.genSVGTest(620);

    }

}
