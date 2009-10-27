#
#  TITLE:    Tumble Quote saver
#  CREATED:  3/25/3009, Brian Larkin
#  USAGE:    Used when a user posts something like '"tumble is awesome" -- james'
#  NOTES:    Not exactly excellent code, but it works.
#  USECASES: 1. User makes a quote
#

require 'rubygems'
require 'dbi'

class QuotePlugin < Plugin

  # Class Variables
  @Quote           = ""
  @Author          = ""

  # Change these settings if you're moving tumble
  MYSQL_HOST       = "localhost"
  MYSQL_USER       = "tumble"
  MYSQL_PASSWORD   = ""
  MYSQL_DATABASE   = "tumble"

  def help(plugin,topic="")
    "post a quote in the following format: '<quote> -- crunchy'"
  end   

  def quote(m)
    debug "Beginning Quote parsing... Message: '#{m.message}'"
    if m.message =~ /\"(.+?)\"\s--(.+?)$/
      debug "Message match: '#{$1}'  Author match: #{$2}"
      @Quote = $1
      @Author = $2
    else    # should not ever hit this
      debug "Invalid string used."
      m.reply "Not a valid quote.  Try \"james white is a pergina\" -- everyone"
      exit 
    end
    
    begin
      dbh = DBI.connect("DBI:Mysql:#{MYSQL_DATABASE}:#{MYSQL_HOST}",MYSQL_USER,MYSQL_PASSWORD)
      sql = dbh.prepare("INSERT INTO quote (timestamp, quote, author) VALUES (CURRENT_TIMESTAMP(), ?, ?)")
      sql.execute(@Quote, @Author)
      sql.finish
      dbh.commit
      m.reply "Posted."
      debug "Posted quote."
    rescue DBI::DatabaseError => e
      m.reply "Error inserting link! Error: #{e.error}"
    ensure
      dbh.disconnect if dbh
    end
  end

  def listen(m)
    debug "Quote Listen triggered"
    if m.message =~ /\"(.+?)\"\s--(.+?)$/
      debug "Quote pasted into irc.  Source: #{m.sourcenick}  Message: #{m.message}"
      quote(m)
    end
  end
end

plugin = QuotePlugin.new
plugin.map 'quote'

