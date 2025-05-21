// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.7.6;

import {Script} from 'forge-std/Script.sol';
import {UniswapV3Staker} from '../src/UniswapV3Staker.sol';
import '@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol';
import '@uniswap/v3-periphery/contracts/interfaces/INonfungiblePositionManager.sol';

contract CounterScript is Script {
    function setUp() public {}

    function run() public {
        vm.createSelectFork(vm.envString('ALCHEMY_RPC_URL'));
        vm.startBroadcast();

        address factoryAddress = vm.envAddress('V3_FACTORY');
        address nonfungiblePositionManagerAddress = vm.envAddress('V3_POSITION_MANAGER');

        new UniswapV3Staker(
            IUniswapV3Factory(factoryAddress),
            INonfungiblePositionManager(nonfungiblePositionManagerAddress),
            2592000,
            1892160000
        );

        vm.stopBroadcast();
    }
}
