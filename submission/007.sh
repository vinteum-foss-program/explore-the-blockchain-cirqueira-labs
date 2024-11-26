#!/bin/bash

# Bloco alvo
block_height=123321

# Obter o hash do bloco
block_hash=$(bitcoin-cli getblockhash $block_height)

# Obter todas as transações do bloco
txids=$(bitcoin-cli getblock $block_hash | jq -r '.tx[]')

echo "Searching for unspent outputs in block $block_height..."

# Lista para armazenar os UTXOs
utxos=()

# Iterar sobre as transações no bloco
for txid in $txids; do
    # Obter os detalhes da transação
    raw_tx=$(bitcoin-cli getrawtransaction $txid true)
    
    # Iterar sobre os outputs da transação
    outputs=$(echo "$raw_tx" | jq -c '.vout[]')

    for output in $outputs; do
        # Verificar se o output está na lista de UTXOs
        is_spent=$(bitcoin-cli gettxout $txid $(echo "$output" | jq -r '.n'))
        
        if [[ -n "$is_spent" ]]; then
            # Adicionar o UTXO à lista
            utxos+=("$output")
        fi
    done
done

# Verificar se exatamente um UTXO foi encontrado
if [[ ${#utxos[@]} -ne 1 ]]; then
    echo "Expected exactly one unspent output, but found ${#utxos[@]}."
    exit 1
fi

# Obter o endereço do único UTXO encontrado
utxo=${utxos[0]}
address=$(echo "$utxo" | jq -r '.scriptPubKey.addresses[0]')

# Exibir o resultado
echo "The single unspent output from block $block_height was sent to address: $address"

