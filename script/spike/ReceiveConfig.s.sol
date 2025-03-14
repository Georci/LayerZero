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
    uint32 constant SEPOLIA_ENDPOINT_ID = 40161;
    uint32 constant TBNB_ENDPOINT_ID = 40102;

    function run() external {
        address TBB_CA = vm.envAddress("TBNB_BEBOP_CA");

        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        BeBopOFT TBB = BeBopOFT(TBB_CA);

        ILayerZeroEndpointV2 endpoint = ILayerZeroEndpointV2(
            address(TBB.endpoint())
        );

        SetConfigParam[] memory setConfigParams = new SetConfigParam[](1);

        address[] memory requiredDVNs = new address[](2);

        requiredDVNs[0] = address(0x0eE552262f7B562eFcED6DD4A7e2878AB897d405);

        //!! 配置 bnb test google cloud DVN
        requiredDVNs[1] = address(0x6f99eA3Fc9206E2779249E15512D7248dAb0B52e);

        address[] memory optionalDVNs;

        UlnConfig memory ulnConfig = UlnConfig({
            confirmations: 5,
            requiredDVNCount: 2,
            optionalDVNCount: 0,
            optionalDVNThreshold: 0,
            requiredDVNs: requiredDVNs,
            optionalDVNs: optionalDVNs
        });

        setConfigParams[0] = SetConfigParam({
            eid: SEPOLIA_ENDPOINT_ID, //!! 配置 源链EID
            configType: RECEIVE_CONFIG_TYPE,
            config: abi.encode(ulnConfig)
        });

        endpoint.setConfig(
            address(TBB),
            0x188d4bbCeD671A7aA2b5055937F79510A32e9683, //!! 配置 BNB_TEST receiveUln302
            setConfigParams
        );
        vm.stopBroadcast();
    }
}
