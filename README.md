# Cerebrum DAO

- Name: Cerebrum DAO token 
- Symbol: NEURON
- Initial Supply: 86,000,000,000
- Cerebrum DAO multisig address: 0xb35d6796366B93188AD5a01F60C0Ba45f1BDf11d
- Should be mintable

## Addresses

### Sepolia

- Token: 0x75F1B6d34BA2e0e3AaC2bc46f1Df071f10EE4879
- L2 (Base): 0x1b1ea374351c53b5ab032737ab66d714b0a08f83
- Token Vesting: 0x79Ea691Ee2d1810FFb8300CD9d1B9Ba2A0EC15D1

### Mainnet

## Create standard L2 token

https://docs.optimism.io/builders/dapp-developers/tutorials/standard-bridge-standard-token

`OptimismMintableERC20Factory` is predeployed for testnets [on Optimism](https://docs.optimism.io/chain/addresses#op-sepolia-l2) and [on Base](https://docs.base.org/base-contracts) at `0x4200000000000000000000000000000000000012`

`cast send 0x4200000000000000000000000000000000000012 "createOptimismMintableERC20(address,string,string)" $DAO_TOKEN_L1_ADDRESS "Cerebrum DAO Token" "NEURON" --private-key $PRIVATE_KEY --rpc-url $BASE_RPC_URL --json | jq -r '.logs[0].topics[2]' | cast parse-bytes32-address`



### Deploy Token Vesting

- deploy
`forge create --rpc-url $RPC_URL --private-key $PRIVATE_KEY  --etherscan-api-key --chain-id=11155111 --verify contracts/TokenVesting.sol:TokenVesting --constructor-args "0x" "Virtual Cerebrum DAO Token" "vNEURON"`

- verify
`ETHERSCAN_API_KEY= forge verify-contract --chain sepolia 0x TokenVesting --constructor-args $(cast abi-encode "constructor(address,string,string)" "0x" "Virtual Cerebrum DAO Token" "vNEURON")`

### Bridging Demo

see client/query.js for demo code that triggers the L1 withdrawal tx  

Bridged 31_400 NEURON from Sepolia to Base Sepolia
- IN https://sepolia.etherscan.io/tx/0xbc3662aed33159efff45847372151529cab2cd785ec18b64219070fe4f836fb8
- OUT https://sepolia.basescan.org/tx/0xe54f5fc397cf11a7aced453bb4e54ec7735717f6083071c141754939967e342f

Withdraw 1_400 NEURON from Base Sepolia to Sepolia
- IN (burn) https://sepolia.basescan.org/tx/0x1fa07bf3c7fb8b91d91bb548e0a68e8712716a9b59ca384b5357fa873e6d22cc
- OUT Prove tx on L1: https://sepolia.etherscan.io/tx/0xf643aeb40c22fa41be4849e620774f1d52a7789ddfba31e114490ee6670dc750
- ... 7 days pass for fraud proofs ...
- OUT Finalize tx on L1: https://sepolia.etherscan.io/tx/0xd8690a7eba65ed926fdd1398a8b07c4a32c645000d02366a3494ef474c912d03




