#!/bin/bash

WALLET_NAME="watchonly_wallet"
XPUB="xpub6Cx5tvq6nACSLJdra1A6WjqTo1SgeUZRFqsX5ysEtVBMwhCCRa4kfgFqaT2o1kwL3esB1PsYr3CUdfRZYfLHJunNWUABKftK2NjHUtzDms2"
INDEX=100
FINGERPRINT="00000000"

DESCRIPTOR_BASE="tr([$FINGERPRINT/84h/0h/0h]$XPUB/0/$INDEX)"

DESCRIPTOR_INFO=$(bitcoin-cli getdescriptorinfo "$DESCRIPTOR_BASE" 2>/dev/null)
if [ $? -ne 0 ]; then
    exit 1
fi

DESCRIPTOR_WITH_CHECKSUM=$(echo "$DESCRIPTOR_INFO" | jq -r '.descriptor')
if [ -z "$DESCRIPTOR_WITH_CHECKSUM" ]; then
    exit 1
fi

bitcoin-cli -rpcwallet="$WALLET_NAME" importdescriptors "[{
    \"desc\": \"$DESCRIPTOR_WITH_CHECKSUM\",
    \"active\": true,
    \"internal\": false,
    \"timestamp\": \"now\"
}]" >/dev/null 2>&1

ADDRESS=$(bitcoin-cli -rpcwallet="$WALLET_NAME" deriveaddresses "$DESCRIPTOR_WITH_CHECKSUM" 2>/dev/null | jq -r '.[0]')
if [ -z "$ADDRESS" ]; then
    exit 1
fi

echo "$ADDRESS"
