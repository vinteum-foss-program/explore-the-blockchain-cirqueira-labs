#see references
#https://developer.bitcoin.org/reference/rpc/gettxout.html
#https://bitcoin.stackexchange.com/questions/48504/how-to-check-if-an-output-has-been-spent
block_hash=$(bitcoin-cli getblockhash 123321)
utxo_array=$(bitcoin-cli getblock $block_hash 2 | jq -r '.tx[] |.txid as $txid |.vout[] |"\($txid),\(.n),\(.scriptPubKey.address)"')

while IFS=',' read -r txid vout address; do
    gettxout_output=$(bitcoin-cli gettxout "$txid" "$vout")
    
    if [[ -n $gettxout_output ]]; then
        echo $address
        break
    fi
done <<< "$utxo_array"
