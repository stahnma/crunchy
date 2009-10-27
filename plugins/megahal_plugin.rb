#
#  TITLE:   Megahal plugin for berry
#  CREATED: 3/31/2009, Brian Larkin
#  USAFE:   It interacts with the megahal instance that berry starts up.
#

class MegahalPlugin < Plugin

  def help(plugin,topic="")
    "Just talk to the bot"
  end

  def reply(m)
    if !@bot.nil?
      reply = @bot.markov_getreply(m.message)
      debug "Message: '#{m.message}' Reply: '#{reply}'"
      m.reply reply
    else
      m.reply "Something is broken because I can't contact the bot."
    end
  end

  #def put(m)
  #  if !@bot.nil?
  #    reply = @bot.markov_put(m.message)
  #    debug "Markov put reply: #{reply}"
  #  else
  #    m.reply "Something is broken because I can't contact the bot."
  #  end
  #end

  def listen(m)
    # The following regex was written to meet several scenarios.
    # capture "<nick> how are you?"
    # capture "how are you <nick>
    # capture "hey <nick> how are you?"
    # not capture "<nick>: foo"
    
    r = "^.*#{@bot.nick}(?!:).*$"
    if m.message.match(r)
      debug "Megahal plugin triggered."
      reply(m)
    #else
    #  put(m)
    end 
  end
  
end

plugin = MegahalPlugin.new
plugin.map 'megahal'
