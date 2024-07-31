import { ethers } from "./deps.ts"
import { realityABI, costAverageABI } from "./mod.ts"


export class Reality {

	public static readonly realityContractAddress = "0xf0d0de34d35fb646ea6a4d3e92b629e92654d2c5"
	public static readonly costAverageContractAddress = "0x275f85fe97B34528Fa7AFA4B316f4B6729f3bB2F"
	public static instance: Reality
	public static async getInstance(providerURL: string, pkTestWallet: string) {
		if (Reality.instance === undefined) {
			const provider = new ethers.JsonRpcProvider(providerURL)
			const ownerWallet = await new ethers.Wallet(pkTestWallet, provider)
			const signer = await ownerWallet.connect(provider)
			const realityContract = new ethers.Contract(Reality.realityContractAddress, realityABI, signer)
			const costAverageContract = new ethers.Contract(Reality.costAverageContractAddress, costAverageABI, signer)
			Reality.instance = new Reality(realityContract, costAverageContract, ownerWallet, provider)
		}
		return Reality.instance
	}
	private readonly realityContract: any
	private readonly costAverageContract: any
	private readonly ownerWallet: any
	private readonly provider: any
	private constructor(realityContract: any, costAverageContract: any, ownerWallet: any, provider: any) {
		this.realityContract = realityContract
		this.costAverageContract = costAverageContract
		this.ownerWallet = ownerWallet
		this.provider = provider
	}
	public async distributeBaseCurrency(receivers: string[], amountPerWallet: bigint): Promise<void> {
		const baseCurrencyBalanceBefore = await this.provider.getBalance(this.ownerWallet.address)
		console.log(`baseCurrencyBalanceBefore: ${ethers.formatEther(baseCurrencyBalanceBefore)}`)
		const tx = await this.realityContract.distributeBaseCurrency(amountPerWallet, receivers, { value: amountPerWallet * BigInt(receivers.length) })
		console.log(`tx: https://polygonscan.com/tx/${tx.hash}`)
	}
	public async distribute(receivers: string[], amountPerWallet: bigint): Promise<void> {
		const balanceOwnerBefore = await this.realityContract.balanceOf(this.ownerWallet.address)
		console.log(`balanceOwnerBefore: ${ethers.formatEther(balanceOwnerBefore)}`)
		if (await this.realityContract.allowance(this.ownerWallet.address, this.realityContract.address) < amountPerWallet * BigInt(receivers.length)) {
			await this.realityContract.approve(this.realityContract.address, amountPerWallet * BigInt(receivers.length))
		}
		const tx = await this.realityContract.distribute(amountPerWallet, receivers)
		console.log(`tx: https://polygonscan.com/tx/${tx.hash}`)
	}
	public async deposit(perPurchaseAmount: bigint, numberOfBuys: number){
		const tx = await this.costAverageContract.deposit(perPurchaseAmount, Reality.realityContractAddress, { value: perPurchaseAmount * BigInt(numberOfBuys)})
		console.log(`deposit transaction: https://polygonscan.com/tx/${tx.hash}`)
	}
	public async trigger(depositID: number, poolFee: number, slippage: number){
		const tx = await this.costAverageContract.trigger(depositID, poolFee, slippage)
		console.log(`trigger transaction: https://polygonscan.com/tx/${tx.hash}`)
	}
}