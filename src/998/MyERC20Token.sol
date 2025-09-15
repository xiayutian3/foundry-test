// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


// 自定义 ERC20 Token 实现
contract MyERC20Token is ERC20, Ownable {
    constructor() ERC20("MyToken", "MTK") Ownable(msg.sender) {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }
    
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
    
    function transferWithCallback(address to, uint256 amount, bytes calldata data) external returns (bool) {
        require(to != address(0), "Invalid address");
        require(amount > 0, "Amount must be greater than 0");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        
        // 先调用接收者的回调函数（如果是合约）
        if (to.code.length > 0) {
            try IERC20Receiver(to).onTokenTransfer(msg.sender, amount, data) returns (bool success) {
                require(success, "Callback failed");
            } catch {
                revert("Callback reverted");
            }
        }
        
        // 回调成功后，再转移代币
        _transfer(msg.sender, to, amount);
        
        return true;
    }
}

// ERC20 接收者接口
interface IERC20Receiver {
    function onTokenTransfer(address from, uint256 amount, bytes calldata data) external returns (bool);
}
