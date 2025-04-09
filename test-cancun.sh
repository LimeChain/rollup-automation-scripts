#!/bin/bash

# Load .env file
set -a && source .env && set +a

forge build

test_opcode() {
  local opcode=$1
  data=$(cat out/TestCancunOpcodes.sol/Test$opcode.json | jq -r .bytecode.object)

  result=$(cast rpc eth_call "{\"from\":\"0x656c26608FeB089Ffe4C6B15E6a0Fcb0BB9D9C31\", \"data\":\"$data\"}" \
    --rpc-url $RPC_URL || echo "failed")

  printf "%-15s %s\n" "$opcode" "$result"
}

test_opcode "BlobHash"
test_opcode "BlobBaseFee"
test_opcode "TStoreLoad"
test_opcode "MCopy"
