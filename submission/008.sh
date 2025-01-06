pub_key=$(bitcoin-cli getrawtransaction e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163 1 | jq -r .vin[0].txinwitness[2])
bitcoin-cli decodescript $pub_key | jq -r '.asm | split(" ") | .[1]'
