// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;
pragma abicoder v2;

import {Script} from '../lib/forge-std/src/Script.sol';
import {IUniswapV3Staker} from '../src/interfaces/IUniswapV3Staker.sol';
import {IERC20Minimal} from '@uniswap/v3-core/contracts/interfaces/IERC20Minimal.sol';
import {IUniswapV3Pool} from '@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol';
import {PoolAddress} from '@uniswap/v3-periphery/contracts/libraries/PoolAddress.sol';
import {INonfungiblePositionManager} from '@uniswap/v3-periphery/contracts/interfaces/INonfungiblePositionManager.sol';
import {IUniswapV3Factory} from '@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol';
import {console2} from 'forge-std/console2.sol';

contract StakeToken is Script {
    function run() public {
        vm.createSelectFork(vm.envString('ALCHEMY_RPC_URL'));
        vm.startBroadcast(vm.envUint('PRIVATE_KEY'));

        address positionManager = vm.envAddress('V3_POSITION_MANAGER');
        address stakerAddress = vm.envAddress('V3_STAKER');

        address token0;
        address token1;
        uint24 fee;
        int24 tickLower;
        int24 tickUpper;
        uint128 liquidity;

        IUniswapV3Staker staker = IUniswapV3Staker(stakerAddress);

        INonfungiblePositionManager nonfungiblePositionManager = INonfungiblePositionManager(positionManager);

        (, , token0, token1, fee, tickLower, tickUpper, liquidity, , , , ) = nonfungiblePositionManager.positions(
            764736
        );

        bytes memory stakeData = abi.encode(
            IUniswapV3Staker.IncentiveKey({
                rewardToken: IERC20Minimal(0x30fA80fB0D4D0c411f35961079C1fc58B3af4F9A),
                pool: IUniswapV3Pool(0xFb0a4f34C80De8Ee5e7eae8dbbAEfe23508fAD6B),
                startTime: 1745130588,
                endTime: 1745994488,
                vestingPeriod: 43200,
                refundee: address(0xe62A4B251d4e8fac52B08Cc2b88F091548426e4C)
            })
        );

        console.log('this address', msg.sender);

        nonfungiblePositionManager.safeTransferFrom(address(msg.sender), address(staker), 764736, stakeData);

        vm.stopBroadcast();
    }
}
