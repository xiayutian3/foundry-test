## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

部署合约时需要做的事情

部署命令

    使用 froge create 来部署合约。

指定链包（身份验证方式）

    private key：直接使用私钥。

    keystore：指定加密私钥文件路径，执行时输入密码。

    account：从默认文件夹中获取 Keystore，执行时输入密码。

选择链

    使用 --chain 参数指定目标链。

选择 RPC 节点

    https://chainlist.org

    自有节点

    付费节点（如 infura.io、alchemy.io）

    本地节点


    命令
    0x0f702ef8F8FC8Ea24c7D2e74c4bd45a3D18cBAE3（本地生成的用户的地址）
    cast wallet new  （创建一个钱包）
    cast wallet import -i s2admin (a123456，保存到本地)
    cast wallet address --account s2admin （解压地址）
    anvil      （启动本地区块链）
    forge build  （编译合约） 
    forge create --account s2admin MyERC20Token --broadcast     (部署合约)
    cast send -i --rpc-url 127.0.0.1:8545 --value 2ether 0x0f702ef8F8FC8Ea24c7D2e74c4bd45a3D18cBAE3 --from <你的地址>
    cast balance 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 --rpc-url 127.0.0.1:8545   （查看该地址的余额）

    <!-- 本地测试网 -->
    0xaaF460a552bb545340C1e686846fbD3D53fe9c5B （部署的合约）
    cast call 0xaaF460a552bb545340C1e686846fbD3D53fe9c5B "name()returns(string)"  (调用合约方法)
    cast call 0xaaF460a552bb545340C1e686846fbD3D53fe9c5B "totalSupply()returns(uint256)"  （查看合约token总的发行量）
    cast send --account s2admin 0xaaF460a552bb545340C1e686846fbD3D53fe9c5B "mint(address,uint256)" 0x0f702ef8F8FC8Ea24c7D2e74c4bd45a3D18cBAE3 1000    （给某个用户铸造币）
    cast call 0xaaF460a552bb545340C1e686846fbD3D53fe9c5B "balanceOf(address user)returns(uint256)" 0x0f702ef8F8FC8Ea24c7D2e74c4bd45a3D18cBAE3   （查看某个用户的token数量）


    <!-- sepolia 测试网
        Deployer: 0x0f702ef8F8FC8Ea24c7D2e74c4bd45a3D18cBAE3
        Deployed to: 0xaaF460a552bb545340C1e686846fbD3D53fe9c5B
        Transaction hash: 0x46864ab5be829e3a998c9340b98db8a2ca0b806dd5dbb74ee3f3765b0dbd7240
     -->

    cast balance --rpc-url https://1rpc.io/sepolia 0x0f702ef8F8FC8Ea24c7D2e74c4bd45a3D18cBAE3  （查看该地址的余额）
    forge create --account s2admin MyERC20Token --broadcast   (部署合约)
    cast send 0xaaF460a552bb545340C1e686846fbD3D53fe9c5B "mint(address,uint256)" "0x0f702ef8F8FC8Ea24c7D2e74c4bd45a3D18cBAE3" 1000ether  (铸造币)
    forge flatten ./src/998/MyERC20Token.sol    (扁平化合约代码，用于部署合约的合约验证)



    forge v 0xaaF460a552bb545340C1e686846fbD3D53fe9c5B src/998/MyERC20Token.sol:MyERC20Token (MyERC20Token:MyERC20Token 文件名：合约名字， 发布验证合约，开源合约代码，这只一种更高级的方式。部署的时候我是省略了第二个MyERC20Token才部署成功，文件名，合约名一样的化可以省略第二个名字)
    <!-- Response: `OK`
        GUID: `dc1e64n4fsj5ue8rfasgyb7xiwnkc51qvq5wphrzmpjgichfui`
        URL: https://sepolia.etherscan.io/address/0xaaf460a552bb545340c1e686846fbd3d53fe9c5b
    -->
    




    
