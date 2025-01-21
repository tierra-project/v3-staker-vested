// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.7.6;

import {Script} from "forge-std/Script.sol";
import {UniswapV3Staker} from "../src/UniswapV3Staker.sol";
import '@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol';
import '@uniswap/v3-periphery/contracts/interfaces/INonfungiblePositionManager.sol';


contract CounterScript is Script {

    function setUp() public {}

    function run() public {
        vm.createSelectFork(vm.rpcUrl("https://bartio.drpc.org"));
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        new UniswapV3Staker(IUniswapV3Factory(0x217Cd80795EfCa5025d47023da5c03a24fA95356), INonfungiblePositionManager(0xC0568C6E9D5404124c8AA9EfD955F3f14C8e64A6), 2592000, 1892160000);

        vm.stopBroadcast();
    }
}
