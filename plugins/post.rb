#
#   TITLE:    Post to tumble plugin
#   CREATED:  3/16/2009, Brian Larkin
#   NOTES:    To deploy, copy to /usr/share/rbot/plugins/.
#             To configure, change connection information below.
#   USAGE:    1. User posts a valid link.
#             2. User posts an invalid link.
#             3. User posts a valid pre-existing link.
#
require 'net/http'
require 'uri'
require 'rubygems'
require 'dbi'

class PostToTumble < Plugin
 
  # Change these settings if you're moving tumble 
  MYSQL_HOST       = "localhost"
  MYSQL_USER       = "tumble"
  MYSQL_PASSWORD   = "" 
  MYSQL_DATABASE   = "tumble"
  IRCLINK_ADDRESS  = "http://tumble.wcyd.org/ircLink?"

  @User           = ""
  @Title          = ""
  @Link           = ""
  
  def help(plugin, topic="")
    "Just post a link into irc and it will be put onto tumble."
  end

  def post (m, link)
    if m.sourcenick
      @User = m.sourcenick
    else
      m.reply "No source nickname specified."
      exit
    end

    @Link = link

    debug "From: #{m.sourcenick} To: #{m.target} Message: #{m.message}"
    if @Link
      Thread.start do
      begin
        ###################################################################################### 
        # Try to resolve URL so we know it's valid
       
        begin
          response = Net::HTTP.get_response(URI.parse(@Link))
          found = case response
            when Net::HTTPSuccess : true
            #when Net::HTTPRedirection : true
            else false
          end

          if found == false 
            m.reply "Could not validate address!"
            exit
          end
          
          @Title = response.body[ %r{<title(?:\s*|\s+.*?)>(.*?)</title\s*>}mi, 1 ]
          debug "Parsed Title: #{@Title}"
        rescue
          m.reply "Invalid address!"
          exit
        end

        ###################################################################################### 
        # Check to make sure it hasn't been posted before.
        debug "Checking previous posting of #{@Link}"
        begin
          dbh = DBI.connect("DBI:Mysql:#{MYSQL_DATABASE}:#{MYSQL_HOST}",MYSQL_USER,MYSQL_PASSWORD)
          sql = "
            SELECT
              CASE
                WHEN timestampdiff(minute,timestamp,now()) <= 120
                  THEN CONCAT(timestampdiff(minute,timestamp,now()), ' minutes')
                WHEN timestampdiff(minute,timestamp,now()) > 120 AND timestampdiff(minute,timestamp,now()) <= 2880
                  THEN CONCAT(timestampdiff(hour,timestamp,now()), ' hours')
                WHEN timestampdiff(minute,timestamp,now()) > 2880
                  THEN CONCAT(timestampdiff(day,timestamp,now()), ' days')
              END AS Previous
            FROM ircLink
            WHERE url = ?
            LIMIT 1;"
          sth = dbh.prepare(sql)
          sth.execute(@Link)
          
          while row = sth.fetch do
            previous = row[0]
            m.reply "welcome to #{previous} ago\n"
            exit
          end
          sth.finish
        rescue DBI::DatabaseError => e
          m.reply "Error querying tumble! Error: #{e.error}"
          exit
        ensure
          dbh.disconnect if dbh
        end

        ###################################################################################### 
        # Post to tumble, retrieve link, and post to irc
         debug "Posting link to tumble"
         begin
           dbh = DBI.connect("DBI:Mysql:#{MYSQL_DATABASE}:#{MYSQL_HOST}",MYSQL_USER,MYSQL_PASSWORD)
           sql = dbh.prepare("INSERT INTO ircLink (user,title,url) VALUES (?, ?, ?)")
           sql.execute(@User,@Title,@Link) 
           sql.finish
           
           id = dbh.func(:insert_id)
           dbh.commit
           m.reply "Posted.  #{IRCLINK_ADDRESS}#{id}"
         rescue DBI::DatabaseError => e
           dbh.rollback
           m.reply "Error inserting link! Error: #{e.error}"
         ensure
           dbh.disconnect if dbh
         end
      rescue StandardError => e
        m.reply "Error while posting link to tumble!  #{e.errstr}"
      end
      end   # of thread
    end
  end

  def listen(m)
    # The listen method is what is triggered by the bot when someone pasts something into irc
    if m.message =~ /(https?:\/\/\S*)/
      debug "Link pasted into irc. Source: '#{m.sourcenick}' URL: #{m.message} Captured: " + $1 
      post(m,$1)
    end
  end

end


plugin = PostToTumble.new
plugin.map 'post :link', :action       => 'post',
                         :requirements => {:link => /(https?):\/\/\S*/ }    
