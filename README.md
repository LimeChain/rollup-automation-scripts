# RollupCodes Automation Scripts

This repository includes scripts to test the opcodes, precompiles, and system contracts supported by a rollup.

## Scripts

### Test Precompiles

[`test-precompiles.sh`](./test-precompiles.sh) verifies whether the rollup supports all standard Ethereum precompiles as well as the `P256VERIFY` precompile defined in `RIP-7212`.

### Test Cancun

[`test-cancun.sh`](./test-cancun.sh) verifies whether the rollup supports all opcodes from the Cancun upgrade:
1. `BLOBHASH`
2. `BLOBBASEFEE`
3. `TSTORE` / `TLOAD`
4. `MCOPY`

### Test Beacon Root System Contract

[`test-beacon-root-system-contract.sh`](./test-beacon-root-system-contract.sh) verifies whether the rollup supports the [`BeaconRoot`](https://eips.ethereum.org/EIPS/eip-4788) system contract.

On Ethereum, the contract stores the last 8191 entries. The script also checks if the buffer is modified by the rollup.

### Test History Storage System Contract

[`test-history-storage-system-contract.sh`](./test-history-storage-system-contract.sh) verifies whether the rollup supports the [`HistoryStorage`](https://eips.ethereum.org/EIPS/eip-2935) system contract.

On Ethereum, the contract stores the last 8191 entries. The script also checks if the buffer is modified by the rollup. 

## Setup

Create a `.env` file that contains `RPC_URL` variable.

