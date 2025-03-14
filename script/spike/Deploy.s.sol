// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import {Script} from "forge-std/Script.sol";
import "../../src/BeBopOFT.sol";

contract BeBopOFTS_cript is Script {
    address constant LAYERZERO_ENDPOINT =
        0x6EDCE65403992e310A62460808c4b910D972f10f;

    function run() public {
        
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        // Deploy
        // BeBopOFT myOFT = new BeBopOFT(
        //     "Holesky BeBop",
        //     "HBB",
        //     LAYERZERO_ENDPOINT,
        //     vm.addr(privateKey) // Wallet address of signer
        // );

        BeBopOFT myOFT = new BeBopOFT(
            "Sepolia BeBop",
            "SBB",
            LAYERZERO_ENDPOINT,
            vm.addr(privateKey) // Wallet address of signer
        );


        //  BeBopOFT myOFT = new BeBopOFT(
        //     "TBNB BeBop",
        //     "TBB",
        //     LAYERZERO_ENDPOINT,
        //     vm.addr(privateKey) // Wallet address of signer
        // );
    }
}
