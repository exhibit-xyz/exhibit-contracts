// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import "test/BaseTest.sol";

import {NounsToken} from "@nouns-contracts/NounsToken.sol";
import {SVGRenderer} from "@nouns-contracts/SVGRenderer.sol";

import {ExhibitBase} from "src/nouns/ExhibitBase.sol";
import {ExhibitDescriptor} from "src/nouns/ExhibitDescriptor.sol";
import {ExhibitArt} from 'src/nouns/ExhibitArt.sol';

contract NounsBaseTest is BaseTest {
    NounsToken nouns;

    ExhibitDescriptor descriptor;
    ExhibitBase nb;
    ExhibitArt ea;
    SVGRenderer renderer;

    address ALICE = 0xD9e424871cdf9cA51FCdaf694495c00Aa39ceF4b;

    bytes mcdonald_hat = hex"00041a0a0703000b5606000f560300085601270156012706560200075601270156012701560127055602000156018a055601270156012701560127055602000156018a0f5602000156018a01561039";

    function setUp() public {
        vm.selectFork(mainnet);

        nouns = NounsToken(0x9C8fF314C9Bc7F6e59A9d9225Fb22946427eDC03);

        renderer = new SVGRenderer();
        descriptor = new ExhibitDescriptor(renderer);
        nb = new ExhibitBase(nouns, descriptor);
        ea = new ExhibitArt(0x48A7C62e2560d1336869D6550841222942768C49);
        nb.setArt(ea);

        // ea.addMask(0, mcdonald_hat);

        startHoax(ALICE);
    }

    function testApplyMask() public {
        nb.upgrade(ALICE, 701);
        nb.applyMask(701, 1, mcdonald_hat);


        console.log(nb.tokenURI(701));
        // nb.genSVGTest(620);

    }

}
