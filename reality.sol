// SPDX-License-Identifier: GNU AFFERO GENERAL PUBLIC LICENSE Version 3
import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v5.0.0/contracts/token/ERC20/ERC20.sol";
pragma solidity 0.8.26;

contract Reality is ERC20 {

    mapping(uint256 => IFreedomOfSpeech) public speeches; 

    uint256 public speechCounter = 0;

    struct IFreedomOfSpeech {
        address from; 
        uint256 timestamp;
        string message;
    }

    error CheckInput();
    error TransferFailed();   
 
    constructor() ERC20("Reality", "REAL") {
        _mint(msg.sender, 2 * 7 * 73 * 293339 * (10 ** decimals())); 
    }

    function speak(string memory message) public {
        speeches[speechCounter] = IFreedomOfSpeech(msg.sender, block.timestamp, message);
        speechCounter++;
    }    

    function distributeBaseCurrency(uint256 amountPerWallet, address[] memory receivers) public payable {
        if ((amountPerWallet * receivers.length) != msg.value) { revert CheckInput(); }
        for (uint256 i = 0; i < receivers.length; i++) {
            (bool sent, ) = receivers[i].call{value: amountPerWallet}("Geo Cash");
            if (sent == false || amountPerWallet == 0) { revert TransferFailed(); }
        }
    }

    function distribute(uint256 amountPerWallet, address[] memory receivers) public {
        if (IERC20(address(this)).allowance(msg.sender, address(this)) < (receivers.length * amountPerWallet)) {
            revert CheckInput();
        } 
        for (uint256 i = 0; i < receivers.length; i++) {
            IERC20(address(this)).transferFrom(msg.sender, receivers[i], amountPerWallet);
        }
    }
}