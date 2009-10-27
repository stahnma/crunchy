#
#  TITLE:    Standings
#  CREATED:  3/24/2009, Brian Larkin
#  USAGE:    Pulls the baseball stats for kevin/heath/teyo/etc... by scraping yahoo sports.
#  NOTES:    Yes, this is an ugly hack.  I just converted the bash/awk script that was 
#            already in use  to the barest ruby.
#  USECASES: 1. User requests data.
#

#require 'net/http'

class StandingsPlugin < Plugin
  def help (plugin, topic="")
    "No parameters - just returns some baseball stats"
  end

  def standings(m, params)
    debug "Standings plugin called"
    url = "http://sports.yahoo.com/mlb/standings"

    # The below url is useful in development - it's an archived version of what the yahoo page should look like
    #url = "http://web.archive.org/web/20070708235346/http://sports.yahoo.com/mlb/standings"
  
    command = "lynx -width=300 -dump #{url}"
    debug "Command: #{command}"
    page = %x[#{command }]

    output = "         W     L     Pct    GB     L10\n"
    page.grep(/Nationals|Mets|Braves/){|entry|
      team = entry.gsub(/.*\]/,'')
      team = team.gsub(/ *[0123456789].*/,'')
      team = team.gsub(/.* /,'')
      team = team.chomp
      debug "Team: #{team} \n"

      data = entry.gsub(/.*#{team}\s/,'')
      debug "Data for #{team}: #{data}"
      datas = data.split(' ')

      team = team.gsub(/Nationals/,'Nattys')
    
      debug team.ljust(9) + datas[0].ljust(6) + datas[1].ljust(5) + datas[2].ljust(8) + datas[3].ljust(7) + datas.last + "\n"
      output = output << team.ljust(9) + datas[0].ljust(6) + datas[1].ljust(5) + datas[2].ljust(8) + datas[3].ljust(7) + datas.last + "\n"
    }
    m.reply output
  end
end

plugin = StandingsPlugin.new
plugin.map 'standings'
