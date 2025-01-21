// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.7.6;
pragma abicoder v2;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {UniswapV3Staker} from "../src/UniswapV3Staker.sol";
import '@uniswap/v3-core/contracts/interfaces/IERC20Minimal.sol';
import '@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol';
import '../src/interfaces/IUniswapV3Staker.sol';

contract CounterScript is Script {
    UniswapV3Staker staker = UniswapV3Staker(0xeB877616063CBc2DF98dF8EBc984FBa5AAE7D60f);

    address rewardToken = 0x490c68D1D7dB9b5874ECfFDC606D0008259F88c5;
    uint rewardAmount = 100 * 1 ether;
    address rewardPool = 0x2619c1f283934F997023082b89b57B7F633C3169;

    function setUp() public {}

    function compute(IUniswapV3Staker.IncentiveKey memory key) internal pure returns (bytes32 incentiveId) {
        return keccak256(abi.encode(key));
    }

    function run() public {
        vm.createSelectFork(vm.rpcUrl("https://bartio.drpc.org"));
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));



        IUniswapV3Staker.IncentiveKey memory incentive = IUniswapV3Staker.IncentiveKey({
            rewardToken: IERC20Minimal(rewardToken),
            pool: IUniswapV3Pool(rewardPool),
            startTime: block.timestamp + 5,
            endTime: block.timestamp + 12 days,
            vestingPeriod: 24 hours,
            refundee: 0x5D931C88De4F75D1984E83f46534E7169A0Ff839
        });

        IERC20Minimal(rewardToken).approve(address(staker), rewardAmount);
        staker.createIncentive(incentive, rewardAmount);
        vm.stopBroadcast();
    }
}
