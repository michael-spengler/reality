// SPDX-License-Identifier: GNU AFFERO GENERAL PUBLIC LICENSE Version 3

pragma solidity 0.8.19;
import "https://raw.githubusercontent.com/moniquebaumann/freedomswaps/v1.9.2/solidity/ILightSpeedSwaps.sol";

contract CostAverage {

    address private constant SWAPROUTER      = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    address private constant BASECURRENCY    = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
    address private constant LIGHTSPEEDSWAPS = 0xf97F48B7b985F2389Aa2540B53757Ee0A92886B7;
    uint256 public depositsCounter = 0;
    mapping(uint256 => IDeposit) public deposits; 
    mapping(address => uint256[]) depositIDs; 

    struct IDeposit {
        address from; // msg.sender of deposit tx
        uint256 input; // contains the amount of base currency deposited 
        address token; // token to be bought
        uint256 swapped; // contains the total amount of base currency already swapped 
        uint256 perPurchaseAmount; // defines how much shall be bought per purchase
    }

    error CheckInput();
    error DepositAlreadySwapped();

    function deposit(uint256 perPurchaseAmount, address token) public payable {
        deposits[depositsCounter] = IDeposit(msg.sender, msg.value, token, 0, perPurchaseAmount);
        depositIDs[msg.sender].push(depositsCounter);
        depositsCounter++;
    }
    function trigger(uint256 depositID, uint24 poolFee, uint24 slippage) public {
        if (deposits[depositID].from != msg.sender) { revert CheckInput(); }
        if (deposits[depositID].input > deposits[depositID].swapped) {
            uint256 price = ILightSpeedSwaps(LIGHTSPEEDSWAPS).getPrice(BASECURRENCY, deposits[depositID].token, poolFee);
            uint256 maxInputAmount = ILightSpeedSwaps(LIGHTSPEEDSWAPS).getAmountInMaximum(deposits[depositID].perPurchaseAmount, price, slippage);
            deposits[depositID].swapped = deposits[depositID].swapped + 
            ILightSpeedSwaps(LIGHTSPEEDSWAPS).swapBaseCurrencyExactOut{value: maxInputAmount}(BASECURRENCY, deposits[depositID].token, deposits[depositID].perPurchaseAmount, poolFee, slippage);
        } else {
            revert DepositAlreadySwapped();
        }
    }
    function getDepositIDs() public view returns(uint256[] memory) {
        return depositIDs[msg.sender];
    }
}