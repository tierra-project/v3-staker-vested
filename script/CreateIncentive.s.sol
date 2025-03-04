// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;
pragma abicoder v2;

import {Script} from "../lib/forge-std/src/Script.sol";
import {IUniswapV3Staker} from "../src/interfaces/IUniswapV3Staker.sol";
import {IERC20Minimal} from "@uniswap/v3-core/contracts/interfaces/IERC20Minimal.sol";
import {IUniswapV3Pool} from "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import {PoolAddress} from "@uniswap/v3-periphery/contracts/libraries/PoolAddress.sol";
import {MockToken} from "../src/MockToken.sol";
import {IncentiveId} from "../src/libraries/IncentiveId.sol";
import {console} from "forge-std/console.sol";
contract CreateIncentive is Script {
    function run() public {
        vm.createSelectFork(vm.envString("ALCHEMY_RPC_URL"));
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        address _V3_STAKER_ADDRESS = vm.envAddress("V3_STAKER");

        IUniswapV3Staker staker = IUniswapV3Staker(_V3_STAKER_ADDRESS);

        MockToken mockToken = new MockToken();

        mockToken.approve(_V3_STAKER_ADDRESS, 1000000000000000000000000);

        IUniswapV3Staker.IncentiveKey memory key = IUniswapV3Staker
            .IncentiveKey({
                rewardToken: IERC20Minimal(address(mockToken)),
                pool: IUniswapV3Pool(
                    0x2619c1f283934F997023082b89b57B7F633C3169
                ),
                startTime: block.timestamp + 100,
                endTime: block.timestamp + 10 days,
                vestingPeriod: 43200,
                refundee: address(0xe62A4B251d4e8fac52B08Cc2b88F091548426e4C)
            });

        bytes32 incentiveId = IncentiveId.compute(key);

        staker.createIncentive(key, 10000000000000000000000);

        // Convert bytes32 to hex string
        string memory incentiveIdHex = bytes32ToHexString(incentiveId);

        // Write the incentiveId as a hex string to a file
        console.log(incentiveIdHex);

        vm.stopBroadcast();
    }

    // Helper function to convert bytes32 to a hex string
    function bytes32ToHexString(
        bytes32 data
    ) internal pure returns (string memory) {
        bytes memory alphabet = "0123456789abcdef";
        bytes memory str = new bytes(64);
        for (uint256 i = 0; i < 32; i++) {
            str[i * 2] = alphabet[uint8(data[i] >> 4)];
            str[1 + i * 2] = alphabet[uint8(data[i] & 0x0f)];
        }
        return string(str);
    }
}
