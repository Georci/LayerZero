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

        //=========set HBB SendConfig ==========
        BeBopOFT HBB = BeBopOFT(HBB_CA);
        ILayerZeroEndpointV2 endpoint = ILayerZeroEndpointV2(
            address(HBB.endpoint())
        );

        SetConfigParam[] memory setConfigParams = new SetConfigParam[](2);
      
        address[] memory requiredDVNs = new address[](1);
        requiredDVNs[0] = address(0x3E43f8ff0175580f7644DA043071c289DDf98118);
     
        address[] memory optionalDVNs;

        // ExecutorConfig  这个可以不该，只是链上执行合约的配置
        ExecutorConfig memory executorConfig = ExecutorConfig({
            maxMessageSize:10000,
            executor: address(0xBc0C24E6f24eC2F1fd7E859B8322A1277F80aaD5)
        });
        setConfigParams[0] = SetConfigParam({
            eid: SEPOLIA_ENDPOINT_ID,
            configType: EXECUTOR_CONFIG_TYPE,
            config: abi.encode(executorConfig)
        });
        // ExecutorConfig

        // UlnConfig
        UlnConfig memory ulnConfig = UlnConfig({
            confirmations: 1,
            requiredDVNCount: 1,
            optionalDVNCount: 0,
            optionalDVNThreshold: 0,
            requiredDVNs: requiredDVNs,
            optionalDVNs: optionalDVNs
        });

        setConfigParams[1] = SetConfigParam({
            eid: SEPOLIA_ENDPOINT_ID,
            configType: ULN_CONFIG_TYPE,
            config: abi.encode(ulnConfig)
        });

        endpoint.setConfig(
            address(HBB),
            address(0x21F33EcF7F65D61f77e554B4B4380829908cD076),
            setConfigParams
        );

        //=========set HBB SendConfig ==========



        vm.stopBroadcast();
    }
}
