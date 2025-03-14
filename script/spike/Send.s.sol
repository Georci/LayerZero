// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
//@layerzerolabs/lz-evm-oapp-v2/contracts/oft/interfaces/IOFT.sol
import {IOFT, SendParam, OFTReceipt} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oft/interfaces/IOFT.sol";
import {IOAppCore} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/interfaces/IOAppCore.sol";
import {MessagingFee} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oft/OFTCore.sol";
import {OptionsBuilder} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/libs/OptionsBuilder.sol";

import {BeBopOFT} from "../../src/BeBopOFT.sol";

contract SendOFT is Script {
    using OptionsBuilder for bytes;
    uint32 constant HOLESKY_ENDPOINT_ID = 40217;
    uint32 constant SEPOLIA_ENDPOINT_ID = 40161;
    uint32 constant TBNB_ENDPOINT_ID = 40102;
    /**
     * @dev Converts an address to bytes32.
     * @param _addr The address to convert.
     * @return The bytes32 representation of the address.
     */
    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }

    function run() public {
        // Fetching environment variables
        //    address oftAddress = vm.envAddress("HOLESKY_BEBOP_CA");// !!注意
        address oftAddress = vm.envAddress("SEPOLIA_BEBOP_CA"); // !!注意
        address toAddress = vm.envAddress("TO_ADDRESS");
        uint256 _tokensToSend = 1 ether;

        // Fetch the private key from environment variable
        uint256 privateKey = vm.envUint("PRIVATE_KEY");

        // Start broadcasting with the private key
        vm.startBroadcast(privateKey);

        BeBopOFT sourceOFT = BeBopOFT(oftAddress);

        console.log(
            "source_BEBOP_balance",
            sourceOFT.balanceOf(toAddress) / 10 ** 18
        );

        bytes memory _extraOptions = OptionsBuilder
            .newOptions()
            .addExecutorLzReceiveOption(200000, 0);

        SendParam memory sendParam = SendParam(
            TBNB_ENDPOINT_ID, // !!注意
            addressToBytes32(toAddress),
            _tokensToSend,
            (_tokensToSend * 9) / 10,
            _extraOptions,
            "",
            ""
        );

        MessagingFee memory fee = sourceOFT.quoteSend(sendParam, false);

        console.log("Fee amount: ", fee.nativeFee);

        sourceOFT.send{value: fee.nativeFee}(sendParam, fee, msg.sender);

        // Stop broadcasting
        vm.stopBroadcast();
    }
}
