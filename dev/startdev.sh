#!/bin/bash

# I got really tired of setting up my screen session.  Hence the following 
# script.

# Need to:
# 0. rbot dir
# 1. rbot dir
# 2. berry
# 3. /root/.rbot/ tail log file
# 4. irc

screen -d -m -S berry_dev -t berry_dev 
cd /irc/wcyd/devel/ircbot/rbot
screen -X eval screen "stuff 'cd `eval echo ~$1`/irc/wcyd/devel/ircbot/rbot'\012"
#screen -X eval screen "stuff 'cd `eval echo ~$1`/irc/wcyd/devel/ircbot/rbot'\012"


screen -X eval screen "stuff 'sudo `eval echo ~$1`/irc/wcyd/devel/ircbot/berry.rb'"
screen -X eval screen "stuff 'cd /root/.rbot/'\012"
screen -X eval screen "stuff 'cd `eval echo ~$1`/irc'\012"
#screen -p 5 -X eval screen "stuff './irc'\012"

