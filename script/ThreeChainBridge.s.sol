pragma solidity ^0.8.22;

import "forge-std/Script.sol";
import {IOFT, SendParam} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oft/interfaces/IOFT.sol";
import {IOAppCore} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/interfaces/IOAppCore.sol";
import {MessagingFee} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oft/OFTCore.sol";
import {OptionsBuilder} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/libs/OptionsBuilder.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IAdapter is IOAppCore, IOFT {}

contract SendOFTScript is Script {
    using OptionsBuilder for bytes;

    uint32 constant HOLESKY_ENPOINT_ID = 40217;
    address constant KROSS_TOKEN = 0xBeb5b2B0B87E3EF336235178f29381219b9094a9;

    function run() external {
        address SEPOLIA_ADAPTER_ADDRESS = vm.envAddress(
            "SEPOLIA_ADAPTER_ADDRESS"
        );
        address HOLESKY_OFT_ADDRESS = vm.envAddress("HOLESKY_OFT_ADDRESS");

        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        address signer = vm.addr(privateKey);

        // Get the Adapter contract instance
        IAdapter sepoliaAdapter = IAdapter(SEPOLIA_ADAPTER_ADDRESS);

        // Hook up Sepolia Adapter to Berachain's OFT
        sepoliaAdapter.setPeer(
            HOLESKY_ENPOINT_ID,
            bytes32(uint256(uint160(HOLESKY_OFT_ADDRESS)))
        );

        console.log("wuxizhi1");
        // Define the send parameters
        uint256 tokensToSend = 1 ether; // 0.0001 $UNI tokens

        bytes memory options = OptionsBuilder
            .newOptions()
            .addExecutorLzReceiveOption(200000, 0);

        console.log("HOLESKY_ENPOINT_ID:", HOLESKY_ENPOINT_ID);
        console.logBytes32(bytes32(uint256(uint160(signer))));
        console.log(tokensToSend);
        console.logBytes(options);

        SendParam memory sendParam = SendParam(
            HOLESKY_ENPOINT_ID,
            bytes32(uint256(uint160(signer))),
            tokensToSend,
            tokensToSend,
            options,
            "",
            ""
        );
        console.log("wuxizhi2");

        // Quote the send fee
        MessagingFee memory fee = sepoliaAdapter.quoteSend(sendParam, false);
        console.log("Native fee: %d", fee.nativeFee);

        IERC20(KROSS_TOKEN).approve(SEPOLIA_ADAPTER_ADDRESS, tokensToSend);

        // Send the tokens
        sepoliaAdapter.send{value: fee.nativeFee}(sendParam, fee, signer);
        console.log("wuxizhi3");

        console.log("Tokens bridged successfully!");
    }
}
