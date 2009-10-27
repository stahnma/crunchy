

Investigate the possibility of creating a package for berry to make install easy.

We are doing a debian package (rather than a gem) because this is supposed to be an end-user system, not necessarily something just for ruby developers.

Resources:
1. http://www.thesatya.com/blog/2005/07/makingadeb.html
2. http://www.linuxdevices.com/articles/AT8047723203.html
3. http://www.debian.org/doc/FAQ/ch-pkg_basics
4. https://help.ubuntu.com/6.10/ubuntu/packagingguide/C/index.html


Package would have to:
1. Dependencies
    a. megahal
    b. Ruby
    c. Ruby Gems
    d. Rbot
2. Create berry user
3. Create berry dir structure
    a. /usr/bin/berry          executible file
    b. /usr/lib/berry/         all of the library files & plugins
    c. /usr/share/doc/berry/   all documentation
3. Deploy files
    a. plugin files to /usr/share/rbot/plugins
    b. megahal files to user/.megahal
4. Create simlinks
5. Created init.d script.


File List:
/usr/bin/berry
/usr/lib/berry/ircbot_berry.rb
/usr/lib/berry/megahal.rb
/usr/lib/berry/pirate.rb
/usr/doc/berry/readme.txt
/home/berry/.megahal/megahal.ban
/home/berry/.megahal/megahal.trn
/home/berry/.megahal/megahal.dic
/usr/share/rbot/plugins/megahal_plugin.rb
/usr/share/rbot/plugins/post.rb
/usr/share/rbot/plugins/quote.rb
/usr/share/rbot/plugins/shoutout.rb
/usr/share/rbot/plugins/standings.rb
/usr/share/rbot/plugins/tell.rb
/etc/init.d/berry

files will be created by rbot in /home/berry/.rbot upon the first run & subsequent setup of rbot.
