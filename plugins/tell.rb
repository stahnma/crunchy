# 
#   TITLE:    Sends an alert out
#   CREATED:  3/20/2009
#   NOTES:    A hacky adaptation of the bash tell script.
#   USAGE:    The script sends out alerts via sendmail for a user if they have a .pageremail file in their homedir.  
#   USECASES: 1. User does a tell
#

class TellPlugin < Plugin
  #
  # Provides a helpful suggestion when a user asks for help in irc.
  #
  def help(plugin, topic="")
    "Just do a !tell <user> <message>."
  end

  #
  # Does the heavy lifting of taking a user's message and pushing it out to the
  # recipients via their .pageremail file in the home dirs
  #
  def tell(m, params)
    @Recipient = params[:recipient]
    @Message = params[:message]

    if @Message.nil? || @Recipient.nil?
      m.reply "Please provide a recipient and a message."
      exit
    end
    debug "Msg: #{@Message} - Recip: #{@Recipient}"

    result = %x[getent passwd | awk -F: '{if(($4>100)){print $6;}}']
    found = false
    sent = false
    begin
      result.each do |homedir|
        homedir = homedir.gsub(/\n?/,"")
        pagefile = "#{homedir}/.pageremail"
        debug "Proposed file: #{pagefile}"
        if FileTest.exists?(pagefile)
          found = true
          debug "#{pagefile} exists!\n"
          File.open(pagefile).each_line{ |address|
            name = File.basename(homedir)
            debug "  Name: #{name} Address: #{address}" 
            @List = "#{@List}#{name} "
            command = "echo \"#{@Message}\" | mail -s 'shoutout!' #{address}"
            debug "Command: #{command}"
            system "#{command}"
            sent = true
          }
        end
      end
    rescue Exception => e
      m.reply "Error while trying to do a tell.  #{e.errstr}"
      exit
    end

    if sent == true
      m.reply "Page sent!"
    else
      if found == true
        m.reply "Pageremail found, but no page sent!"
      else
        m.reply "No pageremail found for #{@Recipient}"
      end
    end

  end
end

plugin = TellPlugin.new
plugin.map 'tell :recipient *message', :action => 'tell'
