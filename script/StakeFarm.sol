// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.7.6;
pragma abicoder v2;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {UniswapV3Staker} from "../src/UniswapV3Staker.sol";
import "@uniswap/v3-core/contracts/interfaces/IERC20Minimal.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "../src/interfaces/IUniswapV3Staker.sol";

contract CounterScript is Script {
    UniswapV3Staker staker =
        UniswapV3Staker(0xeB877616063CBc2DF98dF8EBc984FBa5AAE7D60f);

    function setUp() public {}

    function compute(
        IUniswapV3Staker.IncentiveKey memory key
    ) internal pure returns (bytes32 incentiveId) {
        return keccak256(abi.encode(key));
    }

    function run() public {
        vm.createSelectFork(vm.rpcUrl("https://bartio.drpc.org"));
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        IUniswapV3Staker.IncentiveKey memory incentive = IUniswapV3Staker
            .IncentiveKey({
                rewardToken: IERC20Minimal(
                    0xF7ED21281FA1993bD93f57f8D0270A948cC29E1b
                ),
                pool: IUniswapV3Pool(
                    0x2619c1f283934F997023082b89b57B7F633C3169
                ),
                startTime: 1737802657,
                endTime: 1738666647,
                vestingPeriod: 43200,
                refundee: 0xe62A4B251d4e8fac52B08Cc2b88F091548426e4C
            });

        INonfungiblePositionManager(0xC0568C6E9D5404124c8AA9EfD955F3f14C8e64A6)
            .safeTransferFrom(msg.sender, address(staker), 34979);
        // staker.stakeToken(incentive, 34911);
        vm.stopBroadcast();
    }
}
