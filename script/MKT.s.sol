// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

import {Script} from "forge-std/Script.sol";
import {Counter} from "../src/Counter.sol";

import {NFTMarket} from "../src/998/NFTMarket.sol";
import {MyERC20Token} from "../src/998/MyERC20Token.sol";
import {ERC721Mock} from "../test/mock/ERC721Mock.sol";


// 执行脚本
// forge script --rpc-url http://127.0.0.1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 ./script/MKT.s.sol
// 广播交易
// forge script --rpc-url http://127.0.0.1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 ./script/MKT.s.sol --broadcast
contract CounterScript is Script {
    Counter public counter;
    // address alice = makeAddr("alice");
    address alice = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
    // Anvil 第二个账户的私钥
    uint256 alicePrivateKey = 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d;

    function setUp() public {}

    function run() public {
        vm.startBroadcast(alicePrivateKey);

        ERC721Mock nft = new ERC721Mock("S2NFT", "S2");
        MyERC20Token erc20 = new MyERC20Token();
        NFTMarket mkt = new NFTMarket(address(nft), address(erc20));

        nft.mint(alice, 1);


        //判断条件
        require(erc20.balanceOf(alice) ==1000000 * 10 ** erc20.decimals(), "alice should have 1,000,000 MTK");

        vm.stopBroadcast();
    }
}
