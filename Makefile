-include .env

# ====================
# Local Anvil Defaults
# ====================

ANVIL_PRIVATE_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
ANVIL_SEPOLIA_RPC_URL := http://127.0.0.1:8545

# ==================================
# User Configuration (Replace These)
# ==================================

PRIVATE_KEY := YOUR_WALLET_PRIVATE_KEY
SEPOLIA_RPC_URL := YOUR_SEPOLIA_RPC_URL
ETHERSCAN_API_KEY := YOUR_ETHERSCAN_API_KEY

# ==================
# Necessary Commands
# ==================

build:
	forge build

deploy-sepolia-localhost:
	forge script script/DeployFundMe.s.sol:DeployFundMe \
	--rpc-url $(ANVIL_SEPOLIA_RPC_URL) \
	--private-key $(ANVIL_PRIVATE_KEY) \
	--broadcast -vvvv

deploy-sepolia-testnet-verify:
	forge script script/DeployFundMe.s.sol:DeployFundMe \
	--rpc-url $(SEPOLIA_RPC_URL) \
	--private-key $(PRIVATE_KEY) \
	--broadcast --verify \
	--etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv

clean:
	forge clean