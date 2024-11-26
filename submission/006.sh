#!/bin/bash

source_block=256128
target_block=257343

source_block_hash=$(bitcoin-cli getblockhash $source_block)

target_block_hash=$(bitcoin-cli getblockhash $target_block)

source_coinbase_txid=$(bitcoin-cli getblock $source_block_hash | jq -r '.tx[0]')

source_coinbase_vout=$(bitcoin-cli getrawtransaction $source_coinbase_txid true | jq -r '.vout[0].value')

target_txs=$(bitcoin-cli getblock $target_block_hash | jq -r '.tx[]')

for txid in $target_txs; do
    inputs=$(bitcoin-cli getrawtransaction $txid true | jq -r '.vin[]?.txid')

    if [[ "$inputs" == *"$source_coinbase_txid"* ]]; then
        echo "$txid"
        exit 0
    fi
done


