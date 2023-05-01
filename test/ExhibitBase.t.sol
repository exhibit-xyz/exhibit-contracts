// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import "test/BaseTest.sol";
import {ExhibitBase} from "src/nouns/ExhibitBase.sol";
import {ExhibitDescriptor} from "src/nouns/ExhibitDescriptor.sol";
import {ExhibitArt} from 'src/nouns/ExhibitArt.sol';

contract NounsBaseTest is BaseTest {
    ExhibitBase nb;
    ExhibitArt ea;

    address ALICE = 0x2573C60a6D127755aA2DC85e342F7da2378a0Cc5;

    bytes mcdonald_hat = hex"00041a0a0703000b5606000f560300085601270156012706560200075601270156012701560127055602000156018a055601270156012701560127055602000156018a0f5602000156018a01561039";

    function setUp() public {
        vm.selectFork(mainnet);
        nb = new ExhibitBase();
        ea = new ExhibitArt();
        nb.setArt(ea);

        // ea.addMask(0, mcdonald_hat);

        startHoax(ALICE);
    }

    function testApplyMask() public {
        nb.applyMask(620, 1, mcdonald_hat);


        console.log(nb.tokenURI(620));
        // nb.genSVGTest(620);

    }

}
