import { Reality } from "./mod.ts"

const perPurchaseAmount = BigInt(299792458 * 10 ** 9)
const numberOfBuys = 9

const reality = await Reality.getInstance(Deno.args[0], Deno.args[1])
await reality.deposit(perPurchaseAmount, numberOfBuys)

