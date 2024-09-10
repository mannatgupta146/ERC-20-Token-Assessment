# ERC-20 Hello Token Contract

This Solidity program is a demonstration of ERC-20 Token with support of transfer, minting, and burning of coins.

## Description

This Solidity program defines an ERC20 token with essential functionalities. It includes functions for minting, where only the founder of the token can create new tokens, and burning, which allows any holder to destroy their tokens. Additionally, the contract supports standard ERC20 transfer and allowance operations, enabling tokens to be transferred between any accounts on the blockchain. It imports the IERC20 interface from [OpenZeppelin](https://www.openzeppelin.com/)

## Video Tutorial

For a detailed walkthrough of the code and how the project works, check out the [Loom video](https://www.loom.com/share/1db86fba3ca844b3bdc53fc089a479e5?sid=f72380ad-b293-4832-8c4c-4c2ef1d4dd47).


# Contract Overview
The Token contract is a basic implementation of an ERC20-like token. It features the following components:

1) owner : The address of owner which gets assigned when the contract is deployed

# Usage
Constructor
The contract constructor initializes the contract with an initial supply of tokens. The deploying address becomes the founder of the contract and holds the entire initial supply.

solidity
constructor(uint _initialSupply);


# Functions

solidity
mint(address recipient, uint256 amount);
// Allows the founder to mint new tokens and add them to a specified address's balance.


solidity
burn(uint256 amount);
// Allows users to burn (destroy) a specific amount of their tokens.


solidity
transferTo(address recipient, uint256 amount);
// Transfer amount of tokens from sender to recipient


## Getting Started

### Installation
[Open in Remix](https://remix.ethereum.org/?code=Ly8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IE1JVApwcmFnbWEgc29saWRpdHkgXjAuOC4yNjsKCmltcG9ydCB7RVJDMjB9IGZyb20gIkBvcGVuemVwcGVsaW4vY29udHJhY3RzL3Rva2VuL0VSQzIwL0VSQzIwLnNvbCI7Cgpjb250cmFjdCBteVRva2VuIGlzIEVSQzIwIHsKCiAgICBhZGRyZXNzIG93bmVyOwoKICAgIGNvbnN0cnVjdG9yKHVpbnQgX2luaXRpYWxTdXBwbHkpIEVSQzIwKCJLaXR0eSIsICJLVFkiKSB7CiAgICAgICAgb3duZXIgPSBtc2cuc2VuZGVyOwogICAgICAgIF9taW50KG93bmVyLCBfaW5pdGlhbFN1cHBseSk7CiAgICB9CgogICAgbW9kaWZpZXIgb3duZXJPbmx5ewogICAgICAgIHJlcXVpcmUobXNnLnNlbmRlcj09b3duZXIsICJOb3QgYXV0aG9yaXplZCIpOwogICAgICAgIF87CiAgICB9CgogICAgZnVuY3Rpb24gbWludChhZGRyZXNzIHRvLCB1aW50MjU2IGFtb3VudCkgcHVibGljIG93bmVyT25seSB7CiAgICAgICAgX21pbnQodG8sIGFtb3VudCk7CiAgICB9CgogICAgZnVuY3Rpb24gYnVybih1aW50MjU2IGFtb3VudCkgcHVibGljIHsKICAgICAgICBfYnVybihtc2cuc2VuZGVyLCBhbW91bnQpOwogICAgfQogICAgCiAgICBmdW5jdGlvbiB0cmFuc2ZlclRvKGFkZHJlc3MgcmVjaXBpZW50LCB1aW50MjU2IGFtb3VudCkgcHVibGljIHsKICAgICAgICByZXF1aXJlKGJhbGFuY2VPZihtc2cuc2VuZGVyKSA+PSBhbW91bnQsICJJbnN1ZmZpY2llbnQgYmFsYW5jZSIpOwogICAgICAgIHRyYW5zZmVyKHJlY2lwaWVudCwgYW1vdW50KTsKICAgIH0KfQ=)

### Executing Program
To run this program, you can use Remix, an online Solidity IDE. To get started, go to the Remix website at [Remix Ethereum](https://remix.ethereum.org/).

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract myToken is ERC20 {
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

## Help
To compile the code, click on the "Solidity Compiler" tab in the left-hand sidebar. Make sure the "Compiler" option is set to "0.8.26" (or another compatible version), and then click on the "Compile Token.sol" button.

Once the code is compiled, you can deploy the contract by clicking on the "Deploy & Run Transactions" tab in the left-hand sidebar. Select the "Token" contract from the dropdown menu, and then click on the "Deploy" button.

## Authors
Mannat Gupta

## License
This project is licensed under the MIT License - see the LICENSE.md file for details
