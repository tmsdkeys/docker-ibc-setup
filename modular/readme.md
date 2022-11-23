# Test Checkers leaderboard extension

## Build Docker images

To build the **image for the checkers game with the leaderboard**, clone the repository and run:

```
$ cd cosmos-ibc-docker/modular
$ docker build -f Dockerfile-checkers . -t checkers --no-cache
```

And to build the **image for the leaderbaord chain**:

```
$ cd cosmos-ibc-docker/modular
$ docker build -f Dockerfile-leaderboard . -t leaderboard --no-cache
```

In addition, you will need to build the **relayer image**:

```
$ cd cosmos-ibc-docker/modular/relayer
$ docker build -f Dockerfile . -t relayer --no-cache
```

## Start the network

You can use the provided compose file to spin up a network with a checkers blockchain, a leaderboard chain and a relayer:

```
$ cd cosmos-ibc-docker/modular
$ docker-compose -f modular.yaml up

```

Observe the output of `docker-compose` until the chains are ready - it will take some time for the chains to be ready. 

## Start the relayer

If the chains are ready, you can start the relayer process:

```
$ docker exec relayer ./run-relayer.sh 
```

This will initialize the relayer config, populate it with the config files for both of the chains and the path between them, add keys for the accounts we created on source and destination blockchains and finally start building clients, connections and channels for relaying.

We'll create 2 channels for 2 different applications: (fungible) token transfer and a custom IBC application to send player data from a checkers chain to a leaderboard hub.

Wait till the connection is etablished and a channels are created. 

## Some admin

We'll set some environment variables to make it easier to sign transactions (with `--from $NAME` flag instead of having to copy the address):
```bash
export ALICE=cosmos14y0kdvznkssdtal2r60a8us266n0mm97r2xju8
export BOB=cosmos1n4mqetruv26lm2frkjah86h642ts84qyd5uvyz
export COLT=cosmos1a3qmcqgdztx7fctx9asagw8nmj66sr5grg5z97
export DAVE=cosmos173czeq76k0lh0m6zcz72yu6zj8c6d0tf294w5k
```

:warning: Do this after having jumped into the container terminal.

## Send tokens cross-chain via IBC (ICS20)

When building a blockchain with Ignite CLI, the Cosmos SDK chain you end up with, will have the core IBC module included by default, as well as the `transfer` module, allowing to send fungible tokens cross-chain over IBC according to the ICS20 standard.

This means we can try this out without any extra dev work required.

For development and testing purposes, the relayer software (`hermes` or `rly`) can trigger the transfer, but we'll use the chain binary to let a user initiate the transaction as is the case in the real world.

Remember to jump into the `checkers` container:

```
$ docker exec -it checkers bash
```
and send the tokens from the `checkers` to the `leaderboard` chain.
```bash
$ checkersd tx ibc-transfer transfer transfer transfer $DAVE 101token --from $ALICE
```
You can check the balances for Dave on the destination chain, remember to first jump into the `leaderboard` container:
```
$ docker exec -it checkers bash
```
and check the balance:
```bash
$ leaderboardd q bank balances $DAVE
```


## Custom checkers IBC application: Create a game and play it until the end

The easiest way to do so is to start the test script, jump into container:

```
$ docker exec -it checkers bash
```

and run:

```
$ ./test.sh 1 $ALICE $BOB
```

this will crate and play a game in the checkers chain. The number `1` indicates the game index. You can increase it for the next test if you want it to play another game. It lets win the second address.

After a game is over, you can query the player information:

```
$ checkersd query leaderboard list-player-info
```

You can send the score of the player to leaderboard chain. In the checkers chain container:

```
$ checkersd tx leaderboard send-candidate leaderboard channel-0 foo --from $ALICE
```

After a while, you can jump into the leaderboard chain:

```
$ docker exec -it leaderboard bash
```

to query the received player information:

```
$ leaderboardd q leaderboard list-player-info
```