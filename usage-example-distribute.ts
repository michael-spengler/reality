import { Reality } from "./mod.ts"

const receivers = ["0x7B1C1e641d982ddd47C9E6786F3A699078E2d1FC"]
const amountPerWallet = BigInt(10 ** 15)

const reality = await Reality.getInstance(Deno.args[0], Deno.args[1])
await reality.distribute(receivers, amountPerWallet)

