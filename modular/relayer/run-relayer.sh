#!/bin/sh

rly config init
rly chains add-dir configs
rly paths add-dir paths

rly keys restore checkers alice "cinnamon legend sword giant master simple visit action level ancient day rubber pigeon filter garment hockey stay water crawl omit airport venture toilet oppose"
rly keys restore checkers bob "stamp later develop betray boss ranch abstract puzzle calm right bounce march orchard edge correct canal fault miracle void dutch lottery lucky observe armed"

rly keys restore leaderboard colt "train okay curtain host enact attend boring phone chest news always dress renew buyer empower toss grape vacuum lion squeeze fly fluid surge kiss"
rly keys restore leaderboard dave "define envelope federal move soul panel purity language memory illegal little twin borrow menu mule vote alter bright must deal sight muscle weather rug"

rly tx link checkers -d -t 3s --src-port leaderboard --dst-port leaderboard --version leaderboard-1
rly start checkers