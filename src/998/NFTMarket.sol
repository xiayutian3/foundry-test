// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import './MyERC20Token.sol';
import './MyERC721Token.sol';

// NFT 市场合约
contract NFTMarket is IERC20Receiver, ERC721Holder {
    // 上架信息结构体
    struct Listing {
        address seller;
        uint256 price;
        bool isActive;
    }
    
    // 状态变量
    MyERC721Token public nftToken;
    MyERC20Token public erc20Token;
    
    // tokenID => 上架信息
    mapping(uint256 => Listing) public listings;
    
    // 事件
    event NFTListed(uint256 indexed tokenId, address indexed seller, uint256 price);
    event NFTSold(uint256 indexed tokenId, address indexed seller, address indexed buyer, uint256 price);
    event NFTDelisted(uint256 indexed tokenId, address indexed seller);
    
    constructor(address _nftToken, address _erc20Token) {
        require(_nftToken != address(0), "Invalid NFT token address");
        require(_erc20Token != address(0), "Invalid ERC20 token address");
        nftToken = MyERC721Token(_nftToken);
        erc20Token = MyERC20Token(_erc20Token);
    }
    
    // 上架 NFT
    function list(uint256 tokenId, uint256 price) external {
        require(nftToken.ownerOf(tokenId) == msg.sender, "Not the owner");
        require(price > 0, "Price must be greater than 0");
        require(nftToken.isApprovedForAll(msg.sender, address(this)) || 
                nftToken.getApproved(tokenId) == address(this), "Market not approved");
        
        listings[tokenId] = Listing({
            seller: msg.sender,
            price: price,
            isActive: true
        });
        
        emit NFTListed(tokenId, msg.sender, price);
    }
    
    // 购买 NFT
    function buyNFT(uint256 tokenId, uint256 amount) public {
        Listing memory listing = listings[tokenId];
        require(listing.isActive, "NFT not for sale");
        require(amount >= listing.price, "Insufficient payment");
        require(msg.sender != listing.seller, "Cannot buy your own NFT");
        
        // 检查买家是否已批准市场合约使用其 ERC20 代币
        require(erc20Token.allowance(msg.sender, address(this)) >= listing.price, 
                "Insufficient allowance");
        
        // 转移 ERC20 代币从买家到卖家
        require(erc20Token.transferFrom(msg.sender, listing.seller, listing.price), 
                "Token transfer failed");
        
        // 转移 NFT 从卖家到买家
        nftToken.safeTransferFrom(listing.seller, msg.sender, tokenId);
        
        // 更新上架信息
        listings[tokenId].isActive = false;
        
        emit NFTSold(tokenId, listing.seller, msg.sender, listing.price);
    }
    
    // 下架 NFT
    function delist(uint256 tokenId) external {
        require(listings[tokenId].isActive, "NFT not listed");
        require(listings[tokenId].seller == msg.sender, "Not the seller");
        
        listings[tokenId].isActive = false;
        
        emit NFTDelisted(tokenId, msg.sender);
    }
    
    // ERC20 代币转移回调函数
    function onTokenTransfer(address from, uint256 amount, bytes calldata data) 
        external returns (bool) {
        require(msg.sender == address(erc20Token), "Only accept token from specified ERC20 contract");
        require(from != address(0), "Invalid from address");
        
        // 解析数据：假设数据包含 tokenId
        require(data.length == 32, "Invalid data");
        uint256 tokenId = abi.decode(data, (uint256));
        
        // 购买 NFT
        buyNFT(tokenId, amount);
        
        return true;
    }
    
    // 获取上架信息
    function getListing(uint256 tokenId) external view returns (address seller, uint256 price, bool isActive) {
        Listing memory listing = listings[tokenId];
        return (listing.seller, listing.price, listing.isActive);
    }
    
    // 支持接收 ERC721 代币
    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }
}





// 题目要求：
// 1. 发行一个 ERC721 Token（用自己的名字）
// 铸造几个 NFT
// 在测试网上发行
// 在 Opensea 上查看

// 2. 编写市场合约 NFTMarket
// 使用自己发行的 ERC20 Token 来购买 NFT

// 功能要求：
// NFT 持有者可上架 NFT：list() 设置价格（多少个 TOKEN 购买 NFT）
// 编写购买NFT方法：buyNFT(uint tokenID, uint amount)
// 转入对应的 TOKEN
// 获取对应的 NFT

// 3. ERC20 Token 特殊要求
// 实现 transferWithCallback(address to, uint amount, bytes32 data) 方法
// 内部调用：ToTokenReceived(msg.sender, to, amount, data)
// 注意：应该是 bytes 而不是 bytes32

// 核心功能点：
// ✅ 自定义 ERC721 Token
// ✅ 自定义 ERC20 Token（用于交易）
// ✅ NFT市场合约
// ✅ list() 上架功能
// ✅ buyNFT() 购买功能
// ✅ transferWithCallback() 回调功能
// ✅ ERC721 安全转账支持

// 流程操作图

// 用户（交易的真正发起人）
//     ↓
//    调用 ERC20合约.transferWithCallback(市场地址, 金额, 数据)
//     ↓
// 在 ERC20 合约内部：
//    - msg.sender = 用户地址
//    - 先调用 市场合约.onTokenTransfer(用户地址, 金额, 数据)
//         ↓
//        在 onTokenTransfer 中：
//           - msg.sender = ERC20合约地址（调用者）
//           - from参数 = 用户地址（真正的交易发起人）
//         ↓
//        调用 buyNFT(代币ID, 金额)
//             ↓
//            在 buyNFT 中：
//               - msg.sender = 市场合约地址（调用者）
//               - 但实际执行代币转移的是原始用户



// 各阶段的 msg.sender：
    // 用户发起交易时：msg.sender = 用户地址

    // 在 ERC20 合约内部：msg.sender = 用户地址

    // 当 ERC20 合约调用市场合约时：msg.sender = ERC20合约地址

    // 在市场合约的 onTokenTransfer 中：msg.sender = ERC20合约地址

    // 在市场合约的 buyNFT 中：msg.sender = 市场合约地址

// 为什么需要 from 参数？ function onTokenTransfer(address from, uint256 amount, bytes calldata data) 
    // 因为当执行到 onTokenTransfer 时，msg.sender 已经变成了 ERC20 合约地址，我们需要通过参数来传递原始的用户地址。

// 所以这个判断：

// solidity
    // require(msg.sender == address(erc20Token), "Only accept token from specified ERC20 contract");
    // 是在确保：只有我们信任的 ERC20 合约才能触发这个回调函数，而不是任何其他合约或用户直接调用。

    // 用户确实是整个交易的最终发起人，但在合约间的调用链中，msg.sender 会随着调用层级而变化。