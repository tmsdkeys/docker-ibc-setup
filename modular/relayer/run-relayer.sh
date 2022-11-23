#!/bin/sh

rly config init
rly chains add-dir configs
rly paths add-dir paths/checkers

rly keys restore checkers alice "cinnamon legend sword giant master simple visit action level ancient day rubber pigeon filter garment hockey stay water crawl omit airport venture toilet oppose"
rly keys restore checkers bob "stamp later develop betray boss ranch abstract puzzle calm right bounce march orchard edge correct canal fault miracle void dutch lottery lucky observe armed"

rly keys restore leaderboard colt "train okay curtain host enact attend boring phone chest news always dress renew buyer empower toss grape vacuum lion squeeze fly fluid surge kiss"
rly keys restore leaderboard dave "define envelope federal move soul panel purity language memory illegal little twin borrow menu mule vote alter bright must deal sight muscle weather rug"

# create client, connnection, channel
rly tx link checkers -d -t 3s --src-port leaderboard --dst-port leaderboard --version leaderboard-1

# add path for ics20 (including already the client and connection info
# and create an extra channel on top of the connection
rly paths add-dir paths/transfer
rly tx channel ics20 --src-port transfer --dst-port transfer --order unordered --version ics20-1


rly start ics20