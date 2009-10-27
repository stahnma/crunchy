#
#  TITLE:   Berry_IRCBot
#  CREATED: 3/25/2009, Brian Larkin
#  NOTES:   This is a hack of the rbot app to allow for piratizing of the language.  All we're doing is
#           inheriting the sendmsg method of the ircbot, piratizing the language and then handing it back
#            off to ircbot.
#

require 'pirate.rb'
require 'megahal.rb'
require '/usr/lib/ruby/1.8/rbot/ircbot.rb'   # not thrilled about putting this there, but /usr/lib/ruby/.. isn't always in path

class Berry_ircbot < Irc::IrcBot

  #
  # We are overriding the initialize method so that we can interface with the 
  # markov engine.
  #
  def initialize(botclass, params = {})
    @hal = MegaHAL.new
    super
  end

  #
  # SendMsg is triggered whenever the bot is trying to put a message into a queue.  
  # We are overriding it here so we can piratize the speech.
  #
  def sendmsg(type, where, message, chan=nil, ring=0,plain=nil)
    #if !plain
    #  p = PirateTranslator.new
    #  message = p.translate(message)
    #  debug "Piratized message: #{message}"
    #end
    super(type,where,message,chan,ring)
  end

  def say(where, message, mchan="", mring=-1, plain=nil)
    if !plain
      p = PirateTranslator.new
      message = p.translate(message)
      debug "Piratized message: #{message}"
    end
    super(where, message, mchan="", mring=-1)
  end
  
  #
  # getreply puts a string to the markov engine and returns the reply.
  #
  def markov_getreply(input='')
    if !@hal.nil?
      reply = @hal.getResponse(input)

      # We don't want to save every single time someone says something, so this is a hack.
      if (Time.now.sec % 2) == 0
        @hal.save
      end
      return reply
    end
  end

  #
  # Retrieves a value from an environment variable key.  Used so we don't put passwords in config files.
  #
  def get_env(key)

  end
end
