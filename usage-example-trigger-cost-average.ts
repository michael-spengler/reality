import { Reality } from "./mod.ts"

const depositID = 0
const poolFee = 10000
const slippage = 3

const reality = await Reality.getInstance(Deno.args[0], Deno.args[1])
await reality.trigger(depositID, poolFee, slippage)

