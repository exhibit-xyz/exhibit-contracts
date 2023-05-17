// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/console.sol";


import {NounsToken} from "@nouns-contracts/NounsToken.sol";
import {SVGRenderer} from "@nouns-contracts/SVGRenderer.sol";

import {ExhibitBase} from "src/nouns/ExhibitBase.sol";
import {ExhibitArt} from 'src/nouns/ExhibitArt.sol';
import {ExhibitDescriptor} from "src/nouns/ExhibitDescriptor.sol";

contract ExhibitScript is Script {
    uint256 privateKey = vm.envUint("DEPLOYER_KEY");
    address mocktoken = vm.envAddress("MAINNET_NOUN_TOKEN");
    address mockArt = vm.envAddress("MAINNET_NOUN_ART");

    NounsToken nouns;
    SVGRenderer renderer;

    ExhibitDescriptor descriptor;
    ExhibitBase baseToken;
    ExhibitArt ea;

    address ALICE = 0xD9e424871cdf9cA51FCdaf694495c00Aa39ceF4b;

    function setUp() public {}

    function run() public {
        vm.startBroadcast(privateKey);

        nouns = NounsToken(mocktoken);

        renderer = new SVGRenderer();
        descriptor = new ExhibitDescriptor(renderer);
        nouns = NounsToken(mocktoken);

        ea = new ExhibitArt(mockArt);
        baseToken = new ExhibitBase(nouns, descriptor);
        // baseToken = 0x3dc9c2725a9068cb08edd9b3f21612524a70170b

        descriptor.transferOwnership(address(baseToken));
        baseToken.setArt(ea);
        // ea - 0xfba3da403716d72da4503825522557f92ee3cabf

        vm.stopBroadcast();
    }

    function deployDescriptor() public {
        // forge script script/ExhibitTenderly.s.sol:ExhibitScript --sig 0xd0a5e6d1 --sender $DEPLOY_ADDRESS --rpc-url $TENDERLY_FORK_RPC --broadcast -vvvv
        vm.startBroadcast(privateKey);

        renderer = new SVGRenderer();
        // 0x9d136eEa063eDE5418A6BC7bEafF009bBb6CFa70
        descriptor = new ExhibitDescriptor(renderer);
        // 0x687bB6c57915aa2529EfC7D2a26668855e022fAE

        descriptor.testRenderer();

        vm.stopBroadcast();
    }

    function deployArt() public {
        // forge script script/ExhibitTenderly.s.sol:ExhibitScript --sig 0xf8015ee4 --sender $DEPLOYER_ADDRESS --rpc-url $TENDERLY_FORK_RPC --broadcast -vvvv
        vm.startBroadcast(privateKey);

        ea = new ExhibitArt(mockArt);
        // 0xAe2563b4315469bF6bdD41A6ea26157dE57Ed94e

        bytes memory head = ea.heads(5);
        console.logBytes(head);

        vm.stopBroadcast();
    }

    function deployBase() public {
        // forge script script/ExhibitTenderly.s.sol:ExhibitScript --sig 0x03faf9c1 --sender $DEPLOYER_ADDRESS --rpc-url $ANVIL_NGROK --broadcast -vvvv
        vm.startBroadcast(privateKey);

        nouns = NounsToken(mocktoken);
        descriptor = ExhibitDescriptor(0x687bB6c57915aa2529EfC7D2a26668855e022fAE);
        ea = ExhibitArt(0xAe2563b4315469bF6bdD41A6ea26157dE57Ed94e);

        baseToken = new ExhibitBase(nouns, descriptor);
        // 0x85495222Fd7069B987Ca38C2142732EbBFb7175D

        bool valid = baseToken.isValidMask();
        console.log(valid);

        descriptor.transferOwnership(address(baseToken));
        baseToken.setArt(ea);

        vm.stopBroadcast();
    }


    function testApplyMask() public {
        // forge script script/ExhibitTenderly.s.sol:ExhibitScript --sig 0x6098e143 --sender $deployer_address --rpc-url $ANVIL_NGROK --broadcast -vvvv
        baseToken = ExhibitBase(0x85495222Fd7069B987Ca38C2142732EbBFb7175D);

        bytes memory mcdonald_hat = hex"00041a0a0703000b5606000f560300085601270156012706560200075601270156012701560127055602000156018a055601270156012701560127055602000156018a0f5602000156018a01561039";

        baseToken.upgrade(ALICE, 701);
        baseToken.applyMask(701, 1, mcdonald_hat);

        console.log(baseToken.tokenURI(701));
    }

}
