#!/bin/bash

# Defina o txid da transação que você forneceu
TXID="37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517"

# Use bitcoin-cli para obter os detalhes da transação
TX_DETAILS=$(bitcoin-cli getrawtransaction $TXID 1)

# Extraia as chaves públicas dos inputs da transação
# Aqui assumimos que cada input tem um campo "pubkey" no JSON da transação
# Isso pode variar dependendo de como a transação foi criada (precisa ajustar dependendo do formato real)
PUBKEYS=()
for input in $(echo $TX_DETAILS | jq -r '.vin[].scriptSig.hex'); do
    PUBKEY=$(echo $input | cut -d ' ' -f 2)  # Ajuste isso para extrair a chave pública corretamente
    PUBKEYS+=($PUBKEY)
done

# Verifique se você obteve as 4 chaves públicas
if [ ${#PUBKEYS[@]} -ne 4 ]; then
    echo "Erro: Número incorreto de chaves públicas encontradas. Esperado 4, encontrado ${#PUBKEYS[@]}."
    exit 1
fi

# Exiba as chaves públicas para garantir que estão corretas
echo "Chaves públicas extraídas:"
for pubkey in "${PUBKEYS[@]}"; do
    echo $pubkey
done

# Criar o comando para o multisig 1-of-4
# O comando createmultisig aceita o número de assinaturas necessárias e um array de chaves públicas
MULTISIG_COMMAND="bitcoin-cli createmultisig 1 '[${PUBKEYS[0]},${PUBKEYS[1]},${PUBKEYS[2]},${PUBKEYS[3]}]'"

# Execute o comando para gerar o endereço P2SH multisig
echo "Gerando endereço P2SH..."
$MULTISIG_COMMAND

