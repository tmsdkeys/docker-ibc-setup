# Generalized Docker setup to test IBC between two chains with a relayer

The setup below offers an straightforward way to setup a Docker test environment where two chain binaries can be tested for IBC functionality with a relayer inbetween.

## Build Docker images

To build the **Docker image for the chains**, clone the repository and run:

- When the chain's files are stored locally (folder in root directory):
    ```
    $ cd docker-ibc-setup/dockerfiles
    $ docker build -f Dockerfile.local_chain . -t $CHAIN-NAME --no-cache
    ```
- When the chain's files are stored in a GitHub repo:
    ```
    $ cd docker-ibc-setup/dockerfiles
    $ docker build -f Dockerfile.gh_chain . -t $CHAIN-NAME -build-arg github-url=$GITHUB-URL --no-cache
    ```

In addition, you will need to build the **relayer image**:

Again from the `docker-ibc-setup/dockerfiles` folder:
```
# For Hermes
$ docker build -f Dockerfile.hermes . -t hermes-relayer --no-cache
```
or
```
# For Go Relayer
$ docker build -f Dockerfile.rly . -t go-relayer --no-cache
```

## Start the network

You can use the provided compose file (`ibc-network.yml`) to spin up a network with two chains and a relayer (at least one or both):

```
# from root directory
$ docker-compose -f ibc-network.yml up
```

Observe the output of `docker-compose` until the chains are ready - it will take some time for the chains to be ready. 

## Start the relayer (TO DO)

If the chains are ready, you can start the relayer process:

```
$ docker exec relayer ./run-relayer.sh 
```

wait till the connection is etablished and a channel is created. 

## Create a game and play it till ende (TO DO)

The easiest way to do so is to start the test script, jump into container:

```
$ docker exec -it checkers bash
```

and run:

```
$ ./test.sh 1 cosmos14y0kdvznkssdtal2r60a8us266n0mm97r2xju8 cosmos1n4mqetruv26lm2frkjah86h642ts84qyd5uvyz
```

this will crate and play a game in the checkers chain. The number `1` indicates the game index. You can increase it for the next test if you want it to play another game. It lets win the second address.

After a game is over, you can query the player information:

```
$ checkersd query leaderboard list-player-info
```

You can send the score of the player to leaderboard chain. In the checkers chain container:

```
$ checkersd tx leaderboard send-candidate leaderboard channel-0 foo --from cosmos14y0kdvznkssdtal2r60a8us266n0mm97r2xju8
```

After a while, you can jump into the leaderboard chain:

```
$ docker exec -it leaderboard bash
```

to query the received player information:

```
$ leaderboardd q leaderboard list-player-info
```

