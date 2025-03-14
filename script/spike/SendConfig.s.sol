// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

// Forge imports
import "forge-std/console.sol";
import "forge-std/Script.sol";

import {Script} from "forge-std/Script.sol";
import "../../src/BeBopOFT.sol";
import {ILayerZeroEndpointV2} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/interfaces/IOAppCore.sol";
import {SetConfigParam} from "@layerzerolabs/lz-evm-protocol-v2/contracts/interfaces/IMessageLibManager.sol";
import {UlnConfig} from "@layerzerolabs/lz-evm-messagelib-v2/contracts/uln/UlnBase.sol";
import {ExecutorConfig} from "@layerzerolabs/lz-evm-messagelib-v2/contracts/SendLibBase.sol";

contract SendConfig is Script {
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

        //=========set SBB SendConfig ==========
        BeBopOFT SBB = BeBopOFT(SBB_CA);
        ILayerZeroEndpointV2 endpoint = ILayerZeroEndpointV2(
            address(SBB.endpoint())
        );

        SetConfigParam[] memory setConfigParams = new SetConfigParam[](2);

        // ExecutorConfig  这个可以不该，只是链上执行合约的配置
        ExecutorConfig memory executorConfig = ExecutorConfig({
            maxMessageSize: 10000,
            executor: address(0x718B92b5CB0a5552039B593faF724D182A881eDA) //配置 sepolia test excute
        });
        setConfigParams[0] = SetConfigParam({
            eid: SEPOLIA_ENDPOINT_ID,
            configType: EXECUTOR_CONFIG_TYPE,
            config: abi.encode(executorConfig)
        });
        // ExecutorConfig

        address[] memory requiredDVNs = new address[](2);
        //!! 配置 sepolia test  LZ DVN
        requiredDVNs[0] = address(0x8eebf8b423B73bFCa51a1Db4B7354AA0bFCA9193);

        //!! 配置 sepolia test google cloud DVN
        requiredDVNs[1] = address(0x4F675c48FaD936cb4c3cA07d7cBF421CeeAE0C75);

        address[] memory optionalDVNs;

        // UlnConfig
        UlnConfig memory ulnConfig = UlnConfig({
            confirmations: 5,
            requiredDVNCount: 2,
            optionalDVNCount: 0,
            optionalDVNThreshold: 0,
            requiredDVNs: requiredDVNs,
            optionalDVNs: optionalDVNs
        });

        setConfigParams[1] = SetConfigParam({
            eid: TBNB_ENDPOINT_ID, //!! 配置 目标链EID
            configType: ULN_CONFIG_TYPE,
            config: abi.encode(ulnConfig)
        });

        endpoint.setConfig(
            address(SBB),
            0xcc1ae8Cf5D3904Cef3360A9532B477529b177cCE, //!! 配置 sepolia sendUln302
            setConfigParams
        );

        //=========set SBB SendConfig ==========

        vm.stopBroadcast();
    }
}
