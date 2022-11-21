#!/bin/sh
$CHAIN_A = "<chain-name>"
$CHAIN_B = "<chain-name>"
$PORT_A = "transfer"
$PORT_B = "transfer"

hermes keys add --chain $CHAIN_A --mnemonic-file "alice.json"
hermes keys add --chain $CHAIN_B --mnemonic-file "bob.json"

hermes create channel --a-chain $CHAIN_A --b-chain $CHAIN_B --a-port $PORT_A --b-port $PORT_B --new-client-connection
hermes start