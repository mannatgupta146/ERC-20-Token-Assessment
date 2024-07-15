// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract myToken is ERC20 {

    address owner;

    constructor(uint _initialSupply) ERC20("Kitty", "KTY") {
        owner = msg.sender;
        _mint(owner, _initialSupply);
    }

    modifier ownerOnly{
        require(msg.sender==owner, "Not authorized");
        _;
    }

    function mint(address to, uint256 amount) public ownerOnly {
        _mint(to, amount);
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }
    
    function transferTo(address recipient, uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        transfer(recipient, amount);
    }
}
