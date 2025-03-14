// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import {Script} from "forge-std/Script.sol";
import "../../src/BeBopOFT.sol";
import {ILayerZeroEndpointV2} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/interfaces/IOAppCore.sol";
import {SetConfigParam} from "@layerzerolabs/lz-evm-protocol-v2/contracts/interfaces/IMessageLibManager.sol";
import {UlnConfig} from "@layerzerolabs/lz-evm-messagelib-v2/contracts/uln/UlnBase.sol";
import {ExecutorConfig} from "@layerzerolabs/lz-evm-messagelib-v2/contracts/SendLibBase.sol";

contract BeBop_SetConfig is Script {
    address constant LAYERZERO_ENDPOINT =
        0x6EDCE65403992e310A62460808c4b910D972f10f;

    uint32 public constant EXECUTOR_CONFIG_TYPE = 1;
    uint32 public constant ULN_CONFIG_TYPE = 2;

    uint32 constant HOLESKY_ENDPOINT_ID = 40217;
    uint32 constant SEPOLIA_ENDPOINT_ID = 40161;
    uint32 constant TBNB_ENDPOINT_ID = 40102;

    function run() public {
        address HBB_CA = vm.envAddress("HOLESKY_BEBOP_CA");
        address SBB_CA = vm.envAddress("SEPOLIA_BEBOP_CA");
        address TBB_CA = vm.envAddress("TBNB_BEBOP_CA");

        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        //=========set peers==========
        // BeBopOFT HBB = BeBopOFT(HBB_CA);
        // HBB.setPeer(
        //     SEPOLIA_ENDPOINT_ID,
        //     bytes32(uint256(uint160(SBB_CA)))
        // );
        // HBB.mint(vm.addr(privateKey), 100 ether);

        BeBopOFT SBB = BeBopOFT(SBB_CA);
        SBB.setPeer(
            HOLESKY_ENDPOINT_ID,
            bytes32(uint256(uint160(HBB_CA)))
        );


        // BeBopOFT SBB = BeBopOFT(SBB_CA);
        // SBB.setPeer(TBNB_ENDPOINT_ID, bytes32(uint256(uint160(TBB_CA))));

        // BeBopOFT TBB = BeBopOFT(TBB_CA);
        // TBB.setPeer(
        //     SEPOLIA_ENDPOINT_ID,
        //     bytes32(uint256(uint160(SBB_CA)))
        // );
        //=========set peers==========

     
        vm.stopBroadcast();
    }
}
