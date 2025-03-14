// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

// Forge imports
import "forge-std/console.sol";
import "forge-std/Script.sol";

// LayerZero imports
import {ILayerZeroEndpointV2} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/interfaces/IOAppCore.sol";
import {SetConfigParam} from "@layerzerolabs/lz-evm-protocol-v2/contracts/interfaces/IMessageLibManager.sol";
import {UlnConfig} from "@layerzerolabs/lz-evm-messagelib-v2/contracts/uln/UlnBase.sol";
import "../../src/BeBopOFT.sol";

contract ReceiveConfig is Script {
 

    uint32 public constant RECEIVE_CONFIG_TYPE = 2;

    uint32 constant HOLESKY_ENDPOINT_ID = 40217;

    function run() external {

        address SBB_CA = vm.envAddress("SEPOLIA_BEBOP_CA");
      
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        BeBopOFT SBB = BeBopOFT(SBB_CA);

        ILayerZeroEndpointV2 endpoint = ILayerZeroEndpointV2(
            address(SBB.endpoint())
        );

        SetConfigParam[] memory setConfigParams = new SetConfigParam[](1);

        address[] memory requiredDVNs = new address[](1);
        requiredDVNs[0] = address(0x8eebf8b423B73bFCa51a1Db4B7354AA0bFCA9193);

        address[] memory optionalDVNs;

        UlnConfig memory ulnConfig = UlnConfig({
            confirmations: 1,
            requiredDVNCount: 1,
            optionalDVNCount: 0,
            optionalDVNThreshold: 0,
            requiredDVNs: requiredDVNs,
            optionalDVNs: optionalDVNs
        });

        setConfigParams[0] = SetConfigParam({
            eid: HOLESKY_ENDPOINT_ID,
            configType: RECEIVE_CONFIG_TYPE,
            config: abi.encode(ulnConfig)
        });

        endpoint.setConfig(
            address(SBB),
            0xdAf00F5eE2158dD58E0d3857851c432E34A3A851,
            setConfigParams
        );
        vm.stopBroadcast();
    }
}
