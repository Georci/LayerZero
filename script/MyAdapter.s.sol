// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import {Script} from "forge-std/Script.sol";
import "../src/MyAdapter.sol";

// contract MyAdapterSepolia_Script is Script {
//     address constant KROSS_TOKEN = 0xBeb5b2B0B87E3EF336235178f29381219b9094a9;
//     address constant LAYERZERO_ENDPOINT =
//         0x6EDCE65403992e310A62460808c4b910D972f10f;

//     function run() public {
//         // Setup
//         uint256 privateKey = vm.envUint("PRIVATE_KEY");
//         vm.startBroadcast(privateKey);

//         // Deploy
//         MyAdapter myAdapter = new MyAdapter(
//             KROSS_TOKEN,
//             LAYERZERO_ENDPOINT,
//             vm.addr(privateKey) // Address of private key
//         );

//         vm.stopBroadcast();
//     }
// }

contract MyAdapterHolesky_Script is Script {
    address constant KROSS_HOLESKY_TOKEN =
        0xd60f72149BCB6eCb00C7f0d0bD8F686b0EC15e64;
    address constant LAYERZERO_ENDPOINT =
        0x6EDCE65403992e310A62460808c4b910D972f10f;

    function run() public {
        // Setup
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        // Deploy
        MyAdapter myAdapter = new MyAdapter(
            KROSS_HOLESKY_TOKEN,
            LAYERZERO_ENDPOINT,
            vm.addr(privateKey) // Address of private key
        );

        vm.stopBroadcast();
    }
}

// contract MyAdapterHolesky_Script is Script {
//     address constant KROSS_HOLESKY_TOKEN =
//         0xd60f72149BCB6eCb00C7f0d0bD8F686b0EC15e64;
//     address constant LAYERZERO_ENDPOINT =
//         0x6EDCE65403992e310A62460808c4b910D972f10f;

//     function run() public {
//         // Setup
//         uint256 privateKey = vm.envUint("PRIVATE_KEY");
//         vm.startBroadcast(privateKey);

//         // Deploy
//         MyAdapter myAdapter = new MyAdapter(
//             KROSS_HOLESKY_TOKEN,
//             LAYERZERO_ENDPOINT,
//             vm.addr(privateKey) // Address of private key
//         );

//         vm.stopBroadcast();
//     }
// }

