# ERC-20 Kitty Token Contract

This Solidity program is a demonstration of ERC-20 Token with support of transfer, minting and burning of coins.

## Description

This Solidity program defines an ERC20 token with essential functionalities. It includes functions for minting, where only the founder of the token can create new tokens, and burning, which allows any holder to destroy their tokens. Additionally, the contract supports standard ERC20 transfer and allowance operations, enabling tokens to be transferred between any accounts on the blockchain. It imports the IERC20 interface from [OpenZeppelin](https://www.openzeppelin.com/)


## Getting Started

### Executing Program

To run this program, you can use Remix, an online Solidity IDE. To get started, go to the Remix website at [Remix Ethereum](https://remix.ethereum.org/).

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract myToken is IERC20 {
    string public name;
    string public symbol;
    address public founder;
    uint256 public tokenTotalSupply;
    mapping(address=>uint256) balances;
    mapping(address => mapping(address => uint256)) allowances;

    constructor(string memory _name, string memory _symbol, uint _tokenTotalSupply) {
        name = _name;
        symbol = _symbol;
        founder = msg.sender;
        tokenTotalSupply = _tokenTotalSupply;
        balances[founder]= tokenTotalSupply;
    }

    function totalSupply() public view override returns (uint256) {
        return tokenTotalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return balances[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(amount>0, "Invalid transfer amount");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        balances[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        require(amount>0, "Invalid allowance amount");

        allowances[msg.sender][spender] = amount;
        
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        require(amount>0, "Invalid allowance amount");
        require(balances[sender] >= amount, "Insufficient supply");
        require(amount<=allowances[sender][recipient], "This amount is not allowed");

        allowances[sender][recipient] -= amount;
        balances[sender] -= amount;
        balances[recipient] +=amount;

        emit Transfer(sender, recipient, amount);
        return true;
    }

    function mint(address recipient, uint256 amount) public returns(bool) {
        require(msg.sender == founder, "Unauthorized");

        balances[recipient] += amount;
        tokenTotalSupply += amount;

        emit Transfer(address(0), recipient, amount);
        return true;
    }

    function burn(uint256 amount) public returns(bool) {
        require(balances[msg.sender]>=amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        tokenTotalSupply -= amount;

        emit Transfer(msg.sender, address(0), amount);
        return true;
    }

}
```
To compile the code, click on the "Solidity Compiler" tab in the left-hand sidebar. Make sure the "Compiler" option is set to "0.8.18" (or another compatible version), and then click on the "Compile Token.sol" button.

Once the code is compiled, you can deploy the contract by clicking on the "Deploy & Run Transactions" tab in the left-hand sidebar. Select the "Token" contract from the dropdown menu, and then click on the "Deploy" button.

## License
This project is licensed under the MIT License - see the LICENSE.md file for details
