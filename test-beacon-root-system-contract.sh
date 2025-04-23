#!/bin/bash

# Load .env file
set -a && source .env && set +a

if [[ "$BLOCK_NUMBER" == "latest" ]]; then
  BLOCK_NUMBER_HEX=$BLOCK_NUMBER
else
  BLOCK_NUMBER_HEX=$(cast to-hex $BLOCK_NUMBER)
fi

last_block=$(cast rpc eth_getBlockByNumber $BLOCK_NUMBER_HEX "false" --rpc-url $RPC_URL)
last_block_number_hex=$(echo $last_block | jq -r .number | sed 's/^0x//' | tr a-z A-Z)
last_block_timestamp_hex=$(echo $last_block | jq -r .timestamp | sed 's/^0x//' | tr a-z A-Z)

# Get previous block to calculate the block time
prev_block_number_hex=$(echo "obase=16;ibase=16;$last_block_number_hex-1" | bc)
prev_block=$(cast rpc eth_getBlockByNumber "0x$prev_block_number_hex" "false" --rpc-url $RPC_URL)
prev_block_timestamp_hex=$(echo $prev_block | jq -r .timestamp | sed 's/^0x//' | tr a-z A-Z)

block_time=$(echo "obase=16;ibase=16;$last_block_timestamp_hex-$prev_block_timestamp_hex" | bc)

test_beacon_root() {
  local block_offset=$1

  timestamp=$(echo "obase=16;ibase=16;$last_block_timestamp_hex-($block_offset*$block_time)" | bc)
  block_num_dec=$(echo "obase=10;ibase=16;$last_block_number_hex-$block_offset" | bc)
  timestamp_dec=$(echo "obase=10;ibase=16;$timestamp" | bc)
  echo "getting beacon root for block $block_num_dec with timestamp $timestamp_dec and offset 0x$block_offset"

  encodedTimestamp=$(printf "0x%064s" "$timestamp" | sed -e 's/ /0/g')
  result=$(cast call 0x000F3df6D732807Ef1319fB7B8bB8522d0Beac02 "$encodedTimestamp" --rpc-url $RPC_URL --block $BLOCK_NUMBER || echo "failed")
  echo -e "Beacon Root: $result \n"
}

test_beacon_root "1FFC" # 8088d
test_beacon_root "FFC" # 4092d
test_beacon_root "7FC" # 2044d
test_beacon_root "3FC" # 1020d
test_beacon_root "C" # 12d
test_beacon_root "0"
