# 
#  TITLE:      MegaHAL interface
#  CREATED:    Downloaded from (http://subbot.org/megahal/megahal.txt) on 3/29/2009 and slightly modified by Brian Larkin.
#  COPYRIGHT:  Robert Scott Mitchell (subbot.org)
#  NOTES:      Reads and writes to MegaHAL.
#


class MegaHAL 

  def initialize
    # We are using megahal-personal so that the megahal files will go into the rbot's user folder.
    @megahal = IO.popen("megahal-personal -wb", "r+")
    while line = @megahal.gets
      puts "#{line}"
      # look for the end of the line that immediately precedes the first prompt 
      if line =~ /(?:\.|\?|!)$/ then break end
    end
  end

  def putstr(s = '')
    s.strip!
    @megahal.puts("#{s}\n\n")
    getstr
  end
  
  # The Save function pushes data from megahal's memory to the storage files.
  def save
    @megahal.puts("#SAVE\n\n")
  end

  def getResponse(s = '')
    return putstr(s)
  end

  def getstr
    full_response = ""
    while (line = @megahal.gets) =~ /^.*/
      if line =~ /^(?: )?(?:\> )*(.*)/ then line = $1 end
      full_response << line.chomp << " "
      c = @megahal.getc # Check the first character of the next line
      if c == nil then break end
      if c.chr == ">" then break end # If it's the first chr of a prompt, break
      @megahal.ungetc(c) #If it's not a prompt, push the chr back on the stream.
    end
    return full_response
  end

end

if $0 == __FILE__
  megahal = MegaHAL.new
  print "\n> "; $stdout.flush
  quitwords = [":q", "quit", "bye", "exit"]
  while (line = gets) !~ /^(#{quitwords.join('|')})+/ and line !~ /^$/
    puts megahal.putstr(line.to_s)
    print "\n> "; $stdout.flush
  end
  megahal.putstr("\#quit\n")
  print "Bye!"
end



