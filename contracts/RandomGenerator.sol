//SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <=0.8.2;

contract RandomGenerator {

    function generate(uint seed, uint maxInt) constant view returns (uint) {
        return (uint(sha3(block.blockhash(block.number - 1), seed)) % (maxInt + 1));
    }
}