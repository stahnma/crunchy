
These plugins are to adapt the current soggies system to rbot.  For more information on writing rbot plugins see (http://ruby-rbot.org/rbot-trac/wiki/RbotPlugins) and (http://ruby-rbot.org/rbot-trac/wiki/OCsDitch).

Paths:
1. /opt/crunchy/messages
2. /usr/local/bin/crunchymail
3. main code for rbot is in /usr/lib/ruby/1.8/rbot/ircbot.rb
4. secondary rbot files are in /usr/share/rbot/
5. rbot log files is in the .rbot directory under whatever user is running it.

ToDo:
1. Figure out what gems are really needed for mysql work.
2. Integrate twitter plugin into the mix.
3. Installer
    a. rbot config files
    b. run init.d under a user
    c. how to create rbot config files?
4. Fix multiple replies to hello.  remove rbot's hello response? 
5. Straighten out piratization so you can avoid it if you want.
6. Get environment variables working
7. Packaging concerns
    a. how to package updates?
    b. how to handle new plugins?  Put them into the package?
    c. Where's the package repo?
    d. Need a key to sign the package...
8. Write facebook plugin?


Possible future plugins:
1. Youtube integration?  Lolcat integration?
    a. Wait on tumblr...
2. Write a world cup plugin
3. Write zomg plugin
    a. d&d, wizards, sca, con, dragoncon

Install process: 
1. Install gems
2. Create user
3. Copy the megahal files
4. set init.d to read user
5. autostart
6. Run berry to set up rbot config

Plugins to remove upon installation:
demauro.rb
fortune.rb
freshmeat.rb
grouphug.rb
quath.rb
quakeauth.rb
quote.rb
quotes.rb
realm.rb
toilet.rb
tube.rb
wow.rb

Completed:
1. Shoutout
2. Post link to tumble
3. Standings
4. Post quote to tumble
5. Piratization
6. Write tell
7. Set up markov bot
   a. finalize crunchy markov setup.
   b. adapt berry to spool up megahal upon init. 
   c. write plugin.
   d. get input from irc going into markov - no reply - just learning.
   e. ensure that all markov file placement is finished and documented.
8. Build script
9. Package it all up and make it easy to install
    a. install file - almost done
    b. remove file
    c. figure out init.d and auto-start
10. Write a "how to write plugins" doc.
11. multiple local paths
12. Modify fortune plugin to not require call to rbot.  We just want "fortune".
13. Add part of install.rb to remove plugins we won't use.

