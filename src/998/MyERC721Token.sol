// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";



// 自定义 ERC721 Token 实现
contract MyERC721Token is ERC721, Ownable {
    uint256 private _nextTokenId;
    
    constructor() ERC721("MyNFT", "MNFT") Ownable(msg.sender) {}
    
    function mint(address to) public onlyOwner returns (uint256) {
        require(to != address(0), "Invalid address");
        uint256 tokenId = _nextTokenId++;
        _mint(to, tokenId);
        return tokenId;
    }
    
    function safeMint(address to) public onlyOwner returns (uint256) {
        require(to != address(0), "Invalid address");
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        return tokenId;
    }
    
    function totalSupply() public view returns (uint256) {
        return _nextTokenId;
    }
}
