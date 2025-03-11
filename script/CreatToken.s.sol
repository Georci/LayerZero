// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import {ERC20} from "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {KROSS_HOLESKY} from "../src/KROSS_HOLESKY.sol";
import {Script} from "forge-std/Script.sol";

contract creatToken is Script {
    KROSS_HOLESKY kross_holesky;

    function run() public {
        // Setup
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address user = vm.addr(privateKey);
        vm.startBroadcast(privateKey);

        // kross_holesky = new KROSS_HOLESKY("KROSS_HOLESKY", "KRS_HOLESKY");
        kross_holesky = new KROSS_HOLESKY("KROSS_TBSC", "KRS_TBSC");
        kross_holesky.mint(user, 100 ether);
    }
}
