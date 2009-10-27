#
#  TITLE:   Berry fortune plugin
#  CREATED: 4/23/2009, Brian Larkin 
#  NOTES:   Use this instead of the standard fortune plugin that rbot comes with
#           so we don't have to include rbot in the call.  Most of this code was 
#           stolen from the original fortune code.
#

class FortuneBerryPlugin < Plugin

  #
  # Users just have to type "fortune" to trigger it.
  #
  def help(plugin, topic="")
    "fortune => get a (short) fortune"
  end

  #
  # Does the heavy lifting for us.  Checks to make sure fortune exists and calls it
  #
  def fortune(m)
    db = "fortunes"
    fortune = nil
    ["/usr/games/fortune", "/usr/bin/fortune", "/usr/local/bin/fortune"].each {|f|
      if FileTest.executable? f
        fortune = f
        break
      end
    }
    m.reply "fortune binary not found" unless fortune
    ret = Utils.safe_exec(fortune, "-n", "255", "-s", db)
    m.reply ret.gsub(/\t/, "  ").split(/\n/).join(" ")
    return
  end

  #
  # Listens in IRC for someone to say "fortune"
  #
  def listen(m)
   debug "Fortune Plugin Triggered"
   if m.message =~ /^fortune$/
      fortune(m)
   end 
  end
end
plugin = FortuneBerryPlugin.new
plugin.map 'fortune', :requirements => /^fortune$/
