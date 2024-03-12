const optimism = require("@eth-optimism/sdk")
const ethers = require("ethers")

const INFURA_KEY = '';
const PROVER_PRIVATE_KEY = '' //used to sign withdrawal transactions on L1

const l1RpcUrl = `https://sepolia.infura.io/v3/${INFURA_KEY}`
const l2RpcUrl = "https://sepolia.base.org"

const address = '0x8FeEAAae1DB031E5F980F5E63fDbb277731e500e'

const l1Provider = new ethers.providers.StaticJsonRpcProvider(l1RpcUrl)
const l1Signer = new ethers.Wallet(PROVER_PRIVATE_KEY, l1Provider)

const l2Provider = new ethers.providers.StaticJsonRpcProvider(l2RpcUrl)

const messenger = new optimism.CrossChainMessenger({
  l1ChainId: 11155111, // 11155111 for Sepolia, 1 for Ethereum
  l2ChainId: 84532, // 11155420 for OP Sepolia, 10 for OP Mainnet
  l1SignerOrProvider: l1Signer,
  l2SignerOrProvider: l2Provider,
})


const main = async () => {
  const deposits = await messenger.getDepositsByAddress(address, {

  })
  console.log(deposits)

  console.log("-----")

  const withdrawals = await messenger.getWithdrawalsByAddress(address, {
    fromBlock: 7214700,
    toBlock: 7215000,
  })
  console.log(withdrawals)

  const recentWithdrawal = withdrawals[0]
  const withdrawalHash = recentWithdrawal.transactionHash

  // https://docs.optimism.io/builders/dapp-developers/tutorials/cross-dom-bridge-erc20#withdraw-tokens

  const withdrawalStatus = await messenger.getMessageStatus(withdrawalHash)
  console.log("Withdrawal Status", withdrawalStatus) // https://sdk.optimism.io/enums/messagestatus

  if (withdrawalStatus === optimism.MessageStatus.READY_TO_PROVE) {
    //this costs gas
    //https://sepolia.etherscan.io/tx/0xf643aeb40c22fa41be4849e620774f1d52a7789ddfba31e114490ee6670dc750
    //calls proveWithdrawalTransaction on OptimismPortal
    //const proveResult = await messenger.proveMessage(withdrawalHash, {})
    //console.log("proveResult", proveResult)

    //now the status can be fault proven, which takes 7d on mainnet ...
  }

  //this is the final step to withdraw tokens on L1
  //this triggers yet another transaction on L1...
  //but finally unlocks the tokens: https://sepolia.etherscan.io/tx/0xd8690a7eba65ed926fdd1398a8b07c4a32c645000d02366a3494ef474c912d03
  if (withdrawalStatus === optimism.MessageStatus.READY_FOR_RELAY) {
    const finalizeWithdrawal = await messenger.finalizeMessage(withdrawalHash)
    console.log("finalize withdrawal", finalizeWithdrawal)
  }

  const withdrawalReceipt = await messenger.getMessageReceipt(withdrawalHash)
  console.log("Withdrawal Receipt",  withdrawalReceipt)
  if(withdrawalReceipt) {
    const withdrawalTx = await l1Provider.getTransaction(withdrawalReceipt.transactionReceipt.transactionHash)
    console.log("Withdrawal Transaction", withdrawalTx)
  }

}

main()