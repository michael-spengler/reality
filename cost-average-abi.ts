export const costAverageABI = [
    {
        "inputs": [],
        "name": "CheckInput",
        "type": "error"
    },
    {
        "inputs": [
            {
                "internalType": "uint256",
                "name": "perPurchaseAmount",
                "type": "uint256"
            },
            {
                "internalType": "address",
                "name": "token",
                "type": "address"
            }
        ],
        "name": "deposit",
        "outputs": [],
        "stateMutability": "payable",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "DepositAlreadySwapped",
        "type": "error"
    },
    {
        "inputs": [
            {
                "internalType": "uint256",
                "name": "depositID",
                "type": "uint256"
            },
            {
                "internalType": "uint24",
                "name": "poolFee",
                "type": "uint24"
            },
            {
                "internalType": "uint24",
                "name": "slippage",
                "type": "uint24"
            }
        ],
        "name": "trigger",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "uint256",
                "name": "",
                "type": "uint256"
            }
        ],
        "name": "deposits",
        "outputs": [
            {
                "internalType": "address",
                "name": "from",
                "type": "address"
            },
            {
                "internalType": "uint256",
                "name": "input",
                "type": "uint256"
            },
            {
                "internalType": "address",
                "name": "token",
                "type": "address"
            },
            {
                "internalType": "uint256",
                "name": "swapped",
                "type": "uint256"
            },
            {
                "internalType": "uint256",
                "name": "perPurchaseAmount",
                "type": "uint256"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "depositsCounter",
        "outputs": [
            {
                "internalType": "uint256",
                "name": "",
                "type": "uint256"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "getDepositIDs",
        "outputs": [
            {
                "internalType": "uint256[]",
                "name": "",
                "type": "uint256[]"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    }
]