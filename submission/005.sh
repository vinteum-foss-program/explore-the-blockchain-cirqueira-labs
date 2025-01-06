pub_keys=$(bitcoin-cli getrawtransaction 37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517 1 | jq [.vin[].txinwitness[1]])
bitcoin-cli createmultisig 1 "$pub_keys" | jq -r .address
