# 
#   TITLE:    Sends an alert out
#   CREATED:  3/20/2009
#   NOTES:    A hacky adaptation of the bash shoutout script.
#   USAGE:    The script sends out alerts via sendmail for users that have a .shoutemail file in their homedir.  
#   USECASES: 1. User does a shoutout
#

class Shoutout < Plugin
  def help(plugin, topic="")
    "Just do a !shoutout <message>."
  end

  def shout(m, params)
    @List = ""
    @Message = params[:message]

    if @Message.nil?
      m.reply "Please provide a message."
      exit
    end

    result = %x[getent passwd | awk -F: '{if(($4>100)){print $6;}}']
    begin
      result.each do |homedir|
        homedir = homedir.gsub(/\n?/,"")
        shoutfile = "#{homedir}/.shoutemail"
        debug "Proposed file: #{shoutfile}"
        if FileTest.exists?(shoutfile)
          debug "#{shoutfile} exists!\n"
          File.open(shoutfile).each_line{ |address|
            name = File.basename(homedir)
            debug "  Name: #{name} Address: #{address}" 
            @List = "#{@List}#{name} "
            command = "echo \"#{@Message}\" | mail -s 'shoutout!' #{address}"
            debug "Command: #{command}"
            system "#{command}"
          }
        end
      end
    rescue Exception => e
      m.reply "Error while trying to shoutout.  #{e.errstr}"
      exit
    end

    m.reply "#{@List}"
  end
end

plugin = Shoutout.new
plugin.map 'shoutout *message', :action => 'shout'
