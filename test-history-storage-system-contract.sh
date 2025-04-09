#!/bin/bash

# Load .env file
set -a && source .env && set +a

last_block=$(cast rpc eth_getBlockByNumber "latest" "false" --rpc-url $RPC_URL)
last_block_number_hex=$(echo $last_block | jq -r .number | sed 's/^0x//' | tr a-z A-Z)

test_history_storage() {
  local block_offset=$1

  block_num=$(echo "obase=16;ibase=16;$last_block_number_hex-$block_offset" | bc)
  block_num_dec=$(echo "obase=10;ibase=16;$block_num" | bc)
  echo "getting history storage for block $block_num_dec and offset 0x$block_offset"

  encodedBlock=$(printf "0x%064s" "$block_num" | sed -e 's/ /0/g')
  result=$(cast call 0x0000F90827F1C53a10cb7A02335B175320002935 "$encodedBlock" --rpc-url $RPC_URL || echo "failed")

  expected_block=$(cast rpc eth_getBlockByNumber "0x$block_num" "false" --rpc-url $RPC_URL)
  expected_block_hash=$(echo $expected_block | jq -r .hash)
  echo -e "History:  $result \nexpected: $expected_block_hash \n"
}

test_history_storage "1FFC" # 8088d
test_history_storage "FFC" # 4092d
test_history_storage "7FC" # 2044d
test_history_storage "3FC" # 1020d
test_history_storage "C" # 12d
test_history_storage "1"

echo "finished"