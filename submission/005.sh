#!/bin/bash

TXID="37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517"

TX_DETAILS=$(bitcoin-cli getrawtransaction $TXID 1)

PUBKEYS=()
for input in $(echo $TX_DETAILS | jq -r '.vin[].scriptSig.hex'); do
    PUBKEY=$(echo $input | cut -d ' ' -f 2)  # Ajuste isso para extrair a chave pública corretamente
    PUBKEYS+=($PUBKEY)
done

if [ ${#PUBKEYS[@]} -ne 4 ]; then
    echo "Erro: Número incorreto de chaves públicas encontradas. Esperado 4, encontrado ${#PUBKEYS[@]}."
    exit 1
fi

echo "Chaves públicas extraídas:"
for pubkey in "${PUBKEYS[@]}"; do
    echo $pubkey
done

MULTISIG_COMMAND="bitcoin-cli createmultisig 1 '[${PUBKEYS[0]},${PUBKEYS[1]},${PUBKEYS[2]},${PUBKEYS[3]}]'"

echo $MULTISIG_COMMAND

