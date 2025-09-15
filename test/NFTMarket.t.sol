// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

import {Test,console} from "forge-std/Test.sol";
 
import {NFTMarket} from "../src/998/NFTMarket.sol";
import {MyERC20Token} from "../src/998/MyERC20Token.sol";
import {ERC721Mock} from "./mock/ERC721Mock.sol";

contract NFTMarketTest is Test {
    NFTMarket mkt;
    ERC721Mock nft;
    MyERC20Token erc20;
    
    address alice = makeAddr("alice");
    
    // 运行测试前的执行代码，可用于准备测试数据
    function setUp() public {
       
        nft = new ERC721Mock("S2NFT", "S2");
        erc20 = new MyERC20Token();
        mkt = new NFTMarket(address(nft), address(erc20));
     

        vm.prank(alice);
        nft.mint(alice, 1);
        // nft.mint(address(this), 1) // 将以 `alice` 的身份运行
       
    }
    

    
    // 测试如果没有授权NFT，则无法List成功
    // tokenId nftid
    // price 价格
    function test_RevertWhen_needApproveFirst() public {
        uint256 tokenId = 1;

        vm.prank(alice); // alice 买家
        mkt.list(tokenId, 1000); // 此行将以 `alice` 的身份执行


        // vm.startPrank(alice); // alice 身份运行
        // code。。。   
        // vm.stopPrank(); // alice 身份运行
    }
    function test_needApproveFirst() public {
        uint256 tokenId = 1;

        vm.prank(alice); // alice 买家
        mkt.list(tokenId, 1000); // 此行将以 `alice` 的身份执行

    }
}
