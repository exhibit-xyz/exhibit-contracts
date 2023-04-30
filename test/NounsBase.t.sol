// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import "test/BaseTest.sol";
import {NounsBase} from "src/nouns/NounsBase.sol";
import {ExhibitDescriptor} from "src/ExhibitDescriptor.sol";
import {ExhibitArt} from 'src/ExhibitArt.sol';

contract NounsBaseTest is BaseTest {
    NounsBase nb;
    ExhibitDescriptor ds;
    ExhibitArt ea;

    address ALICE = 0x2573C60a6D127755aA2DC85e342F7da2378a0Cc5;

    bytes mcdonald_hat = hex"00041a0a0703000b5606000f560300085601270156012706560200075601270156012701560127055602000156018a055601270156012701560127055602000156018a0f5602000156018a01561039";

    function setUp() public {
        vm.selectFork(mainnet);
        nb = new NounsBase();
        ds = new ExhibitDescriptor();
        ea = new ExhibitArt();
        ds.setArt(ea);
        nb.setDescriptor(ds);

        ea.addMask(0, mcdonald_hat);

        startHoax(ALICE);
    }

    function testUpgrade() public {

        nb.upgrade(ALICE, 620);
        console.log(nb.tokenURI(620));
    }

    function testApplyMask() public {
        nb.upgrade(ALICE, 620);

        nb.applyMask(620, 0);

        // console.log(nb.tokenURI(620));
        nb.genSVGTest(620);

    }

}
