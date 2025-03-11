pragma solidity ^0.8.22;

import "forge-std/Script.sol";
import {MyOFT} from "../src/MyOFT.sol";

contract DebugScript is Script {
    MyOFT myOFT;

    function setUp() public {
        myOFT = MyOFT(0xaE650Ec03e807e640580540d7c2DF615badF7C22);
    }

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        address signer = vm.addr(privateKey);

        console.log("MyOFT name:", myOFT.name());

        uint256 balance = myOFT.balanceOf(signer);
        console.log("MyOFT balance:", balance);

        uint256 totalSupply = myOFT.totalSupply();
        console.log("totalSupply: ", totalSupply);

        vm.stopBroadcast();
    }
}
