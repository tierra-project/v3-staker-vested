// SPDX-License-Identifier: MIT
pragma solidity =0.7.6;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract MockToken is ERC20, Ownable {
    constructor() ERC20('MockToken', 'MTK') {
        // Mint initial supply to the contract deployer
        _mint(msg.sender, 1000000 * 10 ** 18);
    }
}
