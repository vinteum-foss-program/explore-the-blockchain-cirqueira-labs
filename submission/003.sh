#!/bin/bash
# How many new outputs were created by block 123,456?

block_hash=$(bitcoin-cli getblockhash 123456)
if [[ -z "$block_hash" ]]; then
  echo "Failed to retrieve block hash!"
  exit 1
fi

txids=$(bitcoin-cli getblock $block_hash | jq -r '.tx[]')
if [[ -z "$txids" ]]; then
  echo "No transactions found in block $block_hash!"
  exit 1
fi
total_outputs=0

for txid in $txids; do
  tx_details=$(bitcoin-cli getrawtransaction $txid true)
  if [[ -z "$tx_details" ]]; then
    echo "Failed to retrieve transaction $txid"
    continue
  fi

  outputs=$(echo "$tx_details" | jq '.vout | length')
  if [[ -z "$outputs" ]]; then
    echo "Failed to count outputs for transaction $txid"
    continue
  fi

  total_outputs=$((total_outputs + outputs))
done

echo $total_outputs

