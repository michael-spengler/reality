
// File: https://raw.githubusercontent.com/moniquebaumann/freedomswaps/v1.9.2/solidity/ILightSpeedSwaps.sol



// We fund freedom.
// We stop state criminals.
// We make crypto cypherpunk again.
// We love Geo Caching with Geo Cash.
// We foster Freedom, Justice and Peace.
// We foster sustainable liquidity infrastructures.
// We combine Crypto Education with Geo Caching.
// We separate money from state criminals like religion has been separated from state.
// We foster ever emerging architectures of freedom by rewarding those who help themselves and others to be free.

pragma solidity 0.8.19;
interface ILightSpeedSwaps {
    function swapExactInputSingle(address tokenIn, address tokenOut, uint256 amountIn, uint24 poolFee, uint24 slippage) external returns (uint256 amountOut);
    function swapBaseCurrency(address tokenIn, address tokenOut, uint24 poolFee, uint24 slippage) external payable returns (uint256 amountOut);
    function swapExactOutputSingle(address tokenIn, address tokenOut, uint256 amountOut, uint24 poolFee, uint24 slippage) external returns (uint256 amountIn);
    function swapBaseCurrencyExactOut(address tokenIn, address tokenOut, uint256 amountOut, uint24 poolFee, uint24 slippage) external payable returns (uint256 amountIn);
    function getAmountOutMin(uint256 amountIn, uint256 price, uint256 slippage) external pure returns(uint256);
    function getAmountInMaximum(uint256 amountOut, uint256 price, uint256 slippage) external pure returns(uint256);
    function getPrice(address token0, address token1, uint24 poolFee) external view returns(uint256);
    function getSqrtPriceX96FromPool(address token0, address token1, uint24 fee) external view returns(uint256);
    function getAmount0(uint256 liquidity, uint256 sqrtPriceX96) external  pure returns(uint256);
    function getAmount1(uint256 liquidity, uint256 sqrtPriceX96) external pure returns(uint256);
    function getPriceFromAmounts(uint256 t0Decimals, uint256 t1Decimals, address t0, uint256 amount0, uint256 amount1, address asset) external pure returns(uint256);
    function getLiquidityFromPool(address token0, address token1, uint24 fee) external view returns(uint256);
}

// File: cost-average.sol



pragma solidity 0.8.19;


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