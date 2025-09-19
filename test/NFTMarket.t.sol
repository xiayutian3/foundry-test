// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

// 在测试文件顶部添加导入
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {Test, console} from "forge-std/Test.sol";

import {NFTMarket} from "../src/998/NFTMarket.sol";
import {MyERC20Token} from "../src/998/MyERC20Token.sol";
import {ERC721Mock} from "./mock/ERC721Mock.sol";

contract NFTMarketTest is Test, IERC721Receiver {
    NFTMarket mkt;
    ERC721Mock nft;
    MyERC20Token erc20;

    address alice = makeAddr("alice");

    // 运行测试前的执行代码，可用于准备测试数据
    function setUp() public {
        nft = new ERC721Mock("S2NFT", "S2");

        vm.prank(alice); // alice 铸币
        erc20 = new MyERC20Token();

        mkt = new NFTMarket(address(nft), address(erc20));

        vm.prank(alice);
        nft.mint(alice, 1);
        // nft.mint(address(this), 1) // 将以 `alice` 的身份运行
    }

    // 实现 onERC721Received 函数( 以接收 ERC721 代币)
    function onERC721Received(
        address,    // operator (未使用)
        address,    // from (未使用)
        uint256,    // tokenId (未使用)
        bytes calldata // data (未使用)
    ) external pure override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    // 测试如果没有授权NFT，则无法List成功（ 没写完，就demo而已）
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

    //测试授权
    function test_needApproveFirst() public {
        uint256 tokenId = 1;

        vm.startPrank(alice); // alice 身份运行
        nft.setApprovalForAll(address(mkt), true); // 授权nft合约

        // assertEq(nft.ownerOf(tokenId), alice, "expect nft owner is alice");  //断言 ，这里是举个例子（相应合约中并没有这个函数）

        mkt.list(tokenId, 1000); // 此行将以 `alice` 的身份执行
        vm.stopPrank(); // alice 身份运行
    }

    // 测试模糊边界价格情况
    function testFuzz_ListPrice(uint256 price) public {
        uint256 tokenId = 1;

        vm.startPrank(alice); // alice 身份运行
        nft.setApprovalForAll(address(mkt), true); // 授权nft合约
        mkt.list(tokenId, price); // 此行将以 `alice` 的身份执行
        vm.stopPrank(); // alice 身份运行
    }

    // 测试购买nft
    function test_buyNFT() public {
        uint256 tokenId = 1;
        uint256 price = 1000;

        // Alice 授权市场合约操作她的 NFT
        vm.startPrank(alice);
        nft.setApprovalForAll(address(mkt), true);
        mkt.list(tokenId, price);
        vm.stopPrank();

        // 给测试合约一些 ERC20 代币用于购买
        vm.prank(alice);
        erc20.mint(address(this), 5000);
        assertEq(
            erc20.balanceOf(address(this)),
            5000,
            "Initial ERC20 balance incorrect"
        );

        // 授权市场合约花费 ERC20 代币
        erc20.approve(address(mkt), price);
        nft.setApprovalForAll(address(mkt), true);

        // 购买 NFT （这里测试合约购买，测试合约调用购买方法）
        mkt.buyNFT(tokenId, price);

        // 验证 NFT 所有权已转移   （这里测试合约购买）
        assertEq(
            nft.ownerOf(tokenId),
            address(this),
            "NFT ownership not transferred"
        );

        // 验证 ERC20 代币余额减少  （这里测试合约购买）
        assertEq(
            erc20.balanceOf(address(this)),
            5000 - price,
            "ERC20 balance not deducted correctly"
        );
    }


    // 测试事件
    // ERC-20 标准的 Transfer 事件
    event Transfer(address indexed from, address indexed to, uint256 value);
    function test_TokenTransferEvent() public {
        address bob = makeAddr("bob");

        // 全部匹配
        vm.expectEmit();
        emit Transfer(alice, bob, 1000);
        vm.prank(alice);
        erc20.transfer(bob, 1000);

        // 部分匹配
        vm.expectEmit(true, true, false, false);
        emit Transfer(alice, bob, 1000 * 2);
        vm.prank(alice);
        erc20.transfer(bob, 1000);


        // 测试一次Call中的多个事件，只需要按事件顺序定义即可
        // uint256 times = 10;

        // for (uint256 i = 0; i < times; i++) {
        //     vm.expectEmit();
        //     emit Transfer(address(0), bob, 1000);
        // }

        // //假设有这个方法
        // erc20.batchMint(bob, 1000, times);


    }
}
