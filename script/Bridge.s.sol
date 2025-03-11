pragma solidity ^0.8.22;

import "forge-std/Script.sol";
import {IOFT, SendParam} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oft/interfaces/IOFT.sol";
import {IOAppCore} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/interfaces/IOAppCore.sol";
import {MessagingFee} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oft/OFTCore.sol";
import {OptionsBuilder} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/libs/OptionsBuilder.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IAdapter is IOAppCore, IOFT {}

// contract SendOFTScript is Script {
//     using OptionsBuilder for bytes;

//     uint32 constant HOLESKY_ENPOINT_ID = 40217;
//     address constant KROSS_TOKEN = 0xBeb5b2B0B87E3EF336235178f29381219b9094a9;

//     function run() external {
//         address SEPOLIA_ADAPTER_ADDRESS = vm.envAddress(
//             "SEPOLIA_ADAPTER_ADDRESS"
//         );
//         address HOLESKY_OFT_ADDRESS = vm.envAddress("HOLESKY_OFT_ADDRESS");

//         uint256 privateKey = vm.envUint("PRIVATE_KEY");
//         vm.startBroadcast(privateKey);
//         address signer = vm.addr(privateKey);

//         // Get the Adapter contract instance
//         IAdapter sepoliaAdapter = IAdapter(SEPOLIA_ADAPTER_ADDRESS);

//         // Hook up Sepolia Adapter to Berachain's OFT
//         sepoliaAdapter.setPeer(
//             HOLESKY_ENPOINT_ID,
//             bytes32(uint256(uint160(HOLESKY_OFT_ADDRESS)))
//         );

//         console.log("wuxizhi1");
//         // Define the send parameters
//         uint256 tokensToSend = 1 ether; // 0.0001 $UNI tokens

//         bytes memory options = OptionsBuilder
//             .newOptions()
//             .addExecutorLzReceiveOption(200000, 0);

//         console.log("HOLESKY_ENPOINT_ID:", HOLESKY_ENPOINT_ID);
//         console.logBytes32(bytes32(uint256(uint160(signer))));
//         console.log(tokensToSend);
//         console.logBytes(options);

//         SendParam memory sendParam = SendParam(
//             HOLESKY_ENPOINT_ID,
//             bytes32(uint256(uint160(signer))),
//             tokensToSend,
//             tokensToSend,
//             options,
//             "",
//             ""
//         );
//         console.log("wuxizhi2");

//         // Quote the send fee
//         MessagingFee memory fee = sepoliaAdapter.quoteSend(sendParam, false);
//         console.log("Native fee: %d", fee.nativeFee);
//         // bytes memory quoteSend_data = abi.encodeWithSignature("quoteSend(SendParam,bool)", sendParam, false);
//         // console.logBytes(quoteSend_data);
//         // (bool success, bytes memory return_data) = SEPOLIA_ADAPTER_ADDRESS.call(quoteSend_data);
//         // console.log("success:", success);

//         // console.logBytes(return_data);
//         // (uint256 nativeFee, uint256 lzTokenFee) = abi.decode(return_data, (uint256, uint256));
//         // console.log("nativeFee:", nativeFee);
//         //[ quoteSend method Response ]
//         //   msgFee   tuple :  92855794807944,0

//         // Approve the OFT contract to spend UNI tokens
//         IERC20(KROSS_TOKEN).approve(SEPOLIA_ADAPTER_ADDRESS, tokensToSend);

//         // Send the tokens
//         sepoliaAdapter.send{value: fee.nativeFee}(sendParam, fee, signer);
//         console.log("wuxizhi3");

//         console.log("Tokens bridged successfully!");
//     }
// }

// contract SendOFTScript_HOLESKY_TO_SEPOLIA is Script {
//     using OptionsBuilder for bytes;

//     uint32 constant SEPOLIA_ENPOINT_ID = 40161;
//     address constant KROSS_TOKEN_HOLESKY = 0xd60f72149BCB6eCb00C7f0d0bD8F686b0EC15e64;

//     function run() external {
//         address HOLESKY_ADAPTER_ADDRESS = vm.envAddress(
//             "HOLESKY_ADAPTER_ADDRESS"
//         );
//         address SEPOLIA_OFT_ADDRESS = vm.envAddress("SEPOLIA_OFT_ADDRESS");

//         uint256 privateKey = vm.envUint("PRIVATE_KEY");
//         vm.startBroadcast(privateKey);
//         address signer = vm.addr(privateKey);

//         // Get the Adapter contract instance
//         IAdapter holeskyAdapter = IAdapter(HOLESKY_ADAPTER_ADDRESS);

//         // Hook up Sepolia Adapter to Berachain's OFT
//         holeskyAdapter.setPeer(
//             SEPOLIA_ENPOINT_ID,
//             bytes32(uint256(uint160(SEPOLIA_OFT_ADDRESS)))
//         );

//         console.log("wuxizhi1");
//         // Define the send parameters
//         uint256 tokensToSend = 1 ether; // 0.0001 $UNI tokens

//         bytes memory options = OptionsBuilder
//             .newOptions()
//             .addExecutorLzReceiveOption(200000, 0);

//         console.log("HOLESKY_ENPOINT_ID:", SEPOLIA_ENPOINT_ID);
//         console.logBytes32(bytes32(uint256(uint160(signer))));
//         console.log(tokensToSend);
//         console.logBytes(options);

//         SendParam memory sendParam = SendParam(
//             SEPOLIA_ENPOINT_ID,
//             bytes32(uint256(uint160(signer))),
//             tokensToSend,
//             tokensToSend,
//             options,
//             "",
//             ""
//         );
//         console.log("wuxizhi2");

//         // Quote the send fee
//         MessagingFee memory fee = holeskyAdapter.quoteSend(sendParam, false);
//         console.log("Native fee: %d", fee.nativeFee);

//         IERC20(KROSS_TOKEN_HOLESKY).approve(HOLESKY_ADAPTER_ADDRESS, tokensToSend);

//         // Send the tokens
//         holeskyAdapter.send{value: fee.nativeFee}(sendParam, fee, signer);
//         console.log("wuxizhi3");

//         console.log("Tokens bridged successfully!");
//     }
// }

contract SendOFTScript_HOLESKY_TO_TBSC is Script {
    using OptionsBuilder for bytes;

    uint32 constant TBSC_ENPOINT_ID = 40102;
    address constant KROSS_TOKEN_HOLESKY =
        0xd60f72149BCB6eCb00C7f0d0bD8F686b0EC15e64;

    function run() external {
        address HOLESKY_ADAPTER_ADDRESS = vm.envAddress(
            "HOLESKY_ADAPTER_ADDRESS"
        );
        address TBSC_OFT_ADDRESS = vm.envAddress("TBSC_OFT_ADDRESS");

        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        address signer = vm.addr(privateKey);

        // Get the Adapter contract instance
        IAdapter holeskyAdapter = IAdapter(HOLESKY_ADAPTER_ADDRESS);

        console.log("wuxizhi");
        // Hook up Sepolia Adapter to Berachain's OFT
        holeskyAdapter.setPeer(
            TBSC_ENPOINT_ID,
            bytes32(uint256(uint160(TBSC_OFT_ADDRESS)))
        );

        console.log("wuxizhi1");
        // Define the send parameters
        uint256 tokensToSend = 1 ether; // 0.0001 $UNI tokens

        bytes memory options = OptionsBuilder
            .newOptions()
            .addExecutorLzReceiveOption(200000, 0);

        console.logBytes32(bytes32(uint256(uint160(signer))));
        console.log(tokensToSend);
        console.logBytes(options);

        SendParam memory sendParam = SendParam(
            TBSC_ENPOINT_ID,
            bytes32(uint256(uint160(signer))),
            tokensToSend,
            tokensToSend,
            options,
            "",
            ""
        );
        console.log("wuxizhi2");

        // Quote the send fee
        MessagingFee memory fee = holeskyAdapter.quoteSend(sendParam, false);
        console.log("Native fee: %d", fee.nativeFee);

        IERC20(KROSS_TOKEN_HOLESKY).approve(
            HOLESKY_ADAPTER_ADDRESS,
            tokensToSend
        );

        // Send the tokens
        holeskyAdapter.send{value: fee.nativeFee}(sendParam, fee, signer);
        console.log("wuxizhi3");

        console.log("Tokens bridged successfully!");
    }
}
