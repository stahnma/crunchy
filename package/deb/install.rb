??? from here until ???END lines may have been inserted/deleted
#!/usr/bin/ruby
#
#  TITLE:  Post install script
#  CREATED: 4/28/2009
#  USAGE:   Used by the debian package to install the software.  Automating all of 
#  this got to be such a pain in the butt so it's just manual now.
#

  require 'rubygems'
  require 'etc'


  print "\n"
  print "Before installing this package you should have the following already set up:\n" 
  print "  1. A user to run berry under.\n" 
  print "  2. The following Ruby Gems installed: deprecated, mysql, dbd-mysql, dbi, json, twitter4r.\n"
  print "  3. \n"
  print "\n"
  print "Do you meet these requirements? [Yn]  "
  continueinstall = gets.chomp
  if !continueinstall.empty? || continueinstall.casecmp("n")
    print "Configure process aborted!\n"
    print "Please rerun before using berry.\n"
  end
  print "\n"
  print "Beginning configuration script\n"
  print "-------------------------------------------------------\n"
  print "\n"


# Create berry user
  begin
    print "User Configuration\n"
    print "-------------------------------------------------------\n"

    print "\n"
    print "What user would you like to run berry under [berry]? "
    user = gets.chomp

    if user.empty?
      user="berry"
    end

    print "You selected to install under user '#{user}'.\n"
    print "\n"

    File.open('/etc/defaults/berry','w') do |f1|
      f1.puts "USERNAME=#{user}"
    end

  rescue Exception => e
    print "Error while attempting to create and configure berry user.\n"
    print "Error: #{e.message}\n"
    exit
  end
  

# Deploy megahal files to berry's user folder (symlink to /usr/lib/berry/xxxxx)
  begin
    homedir = Etc.getpwnam(user).dir
    
    if homedir.empty?
      print "We couldn't find the home directory for that user.  What is it? "
      homedir = gets.chomp
    end

    print "\nConfiguring megahal AI.\n"
    Dir.mkdir("#{homedir}/.megahal/")
    sban = "ln -s /usr/lib/berry/megahal.ban #{homedir}/megahal.ban"
    sdic = "ln -s /usr/lib/berry/megahal.dic #{homedir}/megahal.dic"
    strn = "ln -s /usr/lib/berry/megahal.trn #{homedir}/megahal.trn" 
    print "Megahal AI deployed.\n" 
  rescue Exception => e
    print "Error while attempting to symlink megahal ai files to berry user's home directory.\n"
    print "Error: #{e.message}\n"
    exit
  end

# Set up rbot files 
  begin
    print "\nConfiguring rbot configuration.\n"
    Dir.mkdir("#{homedir}/.rbot") 
    File.copy("/usr/lib/berry/rbot/conf.yaml","#{homedir}/.rbot/conf.yaml") 
    File.copy("/usr/lib/berry/rbot/levels.rbot","#{homedir}/.rbot/levels.rbot") 
    print "Rbot configuration files deployed.\n"
  rescue Exception => e
    print "Error while attempting to deploy the rbot configuration files.\n"
    print "Error: #{e.message}\n"
    exit
  end

# Autostart?
  begin
    print "\nDo you want berry to auto-start on reboots [Y]?"
    auto = gets.chomp
  
    if auto.empty? || auto == "Y"
      system "sudo update-rc.d berry defaults"
      print "Auto-start configured.\n"
    end
  rescue Exception => e
    print "Error while attempting to set update-rc.d for berry.\n"
    print "Error: #{e.message}\n"
    exit
  end
  
# Delete the unnecessary plugins
  begin
    File.delete("/usr/share/rbot/plugins/demauro.rb") 
    File.delete("/usr/share/rbot/plugins/fortune.rb") 
    File.delete("/usr/share/rbot/plugins/freshmeat.rb") 
    File.delete("/usr/share/rbot/plugins/grouphug.rb") 
    File.delete("/usr/share/rbot/plugins/quath.rb") 
    File.delete("/usr/share/rbot/plugins/quakeauth.rb") 
    File.delete("/usr/share/rbot/plugins/quote.rb") 
    File.delete("/usr/share/rbot/plugins/quotes.rb") 
    File.delete("/usr/share/rbot/plugins/realm.rb") 
    File.delete("/usr/share/rbot/plugins/toilet.rb") 
    File.delete("/usr/share/rbot/plugins/tube.rb") 
    File.delete("/usr/share/rbot/plugins/wow.rb") 
  rescue Exception => e
    print "Error while attempting to delete unused rbot plugins.\n"
    print "Error: #{e.message}\n"
    exit
  end

  print "-------------------------------------------------------\n"

  # Finish up
  print "WARNING: Please configure the plugins for the correct database settings.  They are located in /usr/share/rbot/plugins/.\n"


