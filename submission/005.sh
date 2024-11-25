#!/bin/bash

TX_ID="37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517"

RAW_TX=$(bitcoin-cli getrawtransaction $TX_ID 1 2>/dev/null)
if [ $? -ne 0 ]; then
    exit 1
fi

PUBKEYS=$(echo "$RAW_TX" | jq -r '.vin[].txinwitness[] | select(length==66)' | sort -u | jq -R -s -c 'split("\n")[:-1]')
if [ -z "$PUBKEYS" ]; then
    exit 1
fi

MULTISIG_ADDRESS=$(bitcoin-cli createmultisig 1 "$PUBKEYS")
if [ $? -ne 0 ]; then
    exit 1
fi

echo "$MULTISIG_ADDRESS" | jq -r '.address'
