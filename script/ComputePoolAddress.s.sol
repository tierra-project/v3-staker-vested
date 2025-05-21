// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.7.6;
pragma abicoder v2;

import {Script} from 'forge-std/Script.sol';
import {console} from 'forge-std/console.sol';
import {UniswapV3Staker} from '../src/UniswapV3Staker.sol';
import '@uniswap/v3-core/contracts/interfaces/IERC20Minimal.sol';
import '@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol';
import '../src/interfaces/IUniswapV3Staker.sol';
import '@uniswap/v3-periphery/contracts/libraries/PoolAddress.sol';

contract ComputePoolAddress is Script {
    //  function setUp() public {}

    function run() public {
        vm.createSelectFork(vm.envString('ALCHEMY_RPC_URL'));
        vm.startBroadcast(vm.envUint('PRIVATE_KEY'));

        address factoryAddress = vm.envAddress('V3_FACTORY');

        address token0 = 0x38Eb7f09e49b5FeD57f8b52968fb3e9297F1b86C;
        address token1 = 0x6969696969696969696969696969696969696969;
        uint24 fee = 10000;

        PoolAddress.PoolKey memory key = PoolAddress.getPoolKey(token0, token1, fee);

        address poolAddress = PoolAddress.computeAddress(factoryAddress, key);

        console.log('Pool address:', poolAddress);

        vm.stopBroadcast();
    }
}
