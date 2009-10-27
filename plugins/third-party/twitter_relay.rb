# :title: Twitter Relay plugin for Rbot
#
# Copyright John Leach 2008, http://johnleach.co.uk
#
# Licensed under the terms of the GNU General Public License v2 or higher
#
# Follows one users rss feed and announces new twitters into the configured
# channels.  I use it to track a dedicated Twitter user that follows channel
# member's Twitter updated.  This is better than following multiple user rss
# feeds directly because it save bandwidth (and load on Twitter :)
#
# Set twitter_relay.username to the name of the twitter user to follow.
# Set twitter_relay.channels to a list of the channels you want the twits
# announced to (bot must be on the channel)
#
# Thanks to the Rbot Twitter plugin by Carter Parks and Giuseppe "Oblomov"
# Bilotta
#
require 'rexml/rexml'
require 'cgi'

class TwitterRelayPlugin < Plugin
  
  Config.register Config::IntegerValue.new('twitter_relay.sleep',
    :default => 300, :validate => Proc.new{|v| v > 50},
    :desc => "How many seconds between checking the Twitter feed")
  
  Config.register Config::StringValue.new('crunchyircbot',
    :default => '',
    :desc => "The Twitter user to check for friend updates")
  
  Config.register Config::ArrayValue.new('soggies',
    :default => [],
    :desc => "List of channels to announce twits to")

  def initialize
    super
    @http_headers = { 'X-Twitter-Client' => 'rbot twitter relay plugin' }
    @last_updated = Time.now
    @channels = @bot.config['twitter_relay.channels']
    @sleep = @bot.config['twitter_relay.sleep']
    set_twitter_user(@bot.config['twitter_relay.username'])
    if @twitter_user.empty? or @channels.empty?
      error "twitter_relay.user or twitter_relay.channels config is unset!"
    else
      log "Starting twitter_relay timer for #{@sleep} seconds, following user #{@twitter_user} and announcing on channels #{@channels.join(', ')}"
      @timer = @bot.timer.add(@sleep) { update_statuses }
    end
  end

  def set_twitter_user(username)
    @twitter_user = URI.escape(username.to_s)
    @uri = @twitter_user.nil? ? nil : "http://twitter.com/statuses/friends_timeline/#{@twitter_user}.xml"
  end

  def cleanup
    @bot.timer.remove @timer unless @timer.nil?
    super
  end

  def update_statuses
    
    response = @bot.httputil.get(@uri, :headers => @http_headers, :cache => false)

    if response
      begin
        rex = REXML::Document.new(response)
        newest_time = @last_updated
        rex.root.elements.each("status") do |st|
          time = Time.parse(st.elements['created_at'].text)
          next if time <= @last_updated
          newest_time = time if newest_time < time
          now = Time.now
          # Sometimes, time can be in the future; invert the relation in this case
          delta = ((time > now) ? time - now : now - time)
          msg = st.elements['text'].to_s + " (#{Utils.secs_to_string(delta.to_i)} ago via #{st.elements['source'].to_s})"
          author = Utils.decode_html_entities(st.elements['user'].elements['name'].text) rescue ""
          @channels.each do |chan|
            @bot.say chan.strip, "via twitter, #{author} #{Utils.decode_html_entities(msg).ircify_html}"
          end
        end
        @last_updated = newest_time
      rescue
        error $!
        return false
      end
      return true
    else
      return false
    end
  end
end

plugin = TwitterRelayPlugin.new

plugin.map 'twitrelay update', :action => 'update_statuses'
