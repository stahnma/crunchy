#
# TITLE:   Tweet Watcher rbot plugin
# CREATED: 4/22/2009
# USAGE:   Automatically pulls updates from twitter and posts them into IRC every 5 minutes.
#

require 'rubygems'
gem('twitter4r', '0.3.0')
require 'twitter'

class TweetWatch < Plugin

  #
  # Start up the variables and start the timer
  #
  def initialize
    @sleep       = 300                               # how many seconds to sleep
    @botusername = ENV['TwitterCrunchyName']         # the twitter login
    @botpassword = ENV['TwitterCrunchyPassword']     # the twitter password
    @channel     = '#soggies'                        # the irc to reply in
    @lastrun     = Time.now - 120 
 
    super    
    debug "TweetWatch plugin initialized"
    @timer = @bot.timer.add(@sleep) {
      debug "TweetWatch timer event triggered"
      getupdatessince
    }
  end

  #
  # GetUpdatesSince performs the main logic of retrieving the data from twitter and putting it into IRC
  #
  def getupdatessince
    begin
      debug "GetUpdatesSince triggered.  Last run was #{@lastrun}"
      client = Twitter::Client.new(:login => "#{@botusername}", :password => "#{@botpassword}", :host => 'twitter.com')
      # the :since property is not working, so just grab the top 20
      friendstimeline = client.timeline_for(:friends, :count => 10) do |status|
        debug "Status found from #{status.user.screen_name} on #{status.created_at}"
        if status.created_at > @lastrun 
          @bot.say "#soggies", "via twitter, #{status.user.screen_name} on #{status.created_at} said #{status.text}","",-1,1
        else
        end
      end
    rescue Exception => e
      @bot.say "#soggies", "Error while trying to connect to twitter.  Error: #{e.message}"
    ensure
      @lastrun = Time.now
    end 
    
  end


  #
  # Used in case someone wants to manually force a pull (impatient slobs)
  #
  def updates(m, params)
    debug "User requested forced pull of twitter updates."
    getupdatessince
  end


  #
  # Here because rbot handles the timer.  Deallocate it on a rescan.
  #
  def cleanup
   debug "Tweetwatch cleanup"
   @bot.timer.remove @timer unless @timer.nil?
    super
  end
end

plugin = TweetWatch.new
plugin.map 'twupdate', :action => 'updates'

