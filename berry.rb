#!/usr/bin/ruby -w
#
#  TITLE:    Rbot Wrapper (Berry)
#  CREATED:  3/25/2009
#  NOTES:    This is a hack to allow for piratizing of rbot.
#

#  We've basically copied over all the rbot code.  Then we call on the
#  ircbot_berry.rb code rather than the ircbot code.  We're doing this so
#  that we can piratize the output of rbot.
$LOAD_PATH << File.join(File.dirname(__FILE__), "lib")
$LOAD_PATH << File.join(File.dirname(__FILE__), "/usr/lib/berry/")

require 'ircbot_berry.rb'

# Copyright (C) 2002 Tom Gilbert.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies of the Software and its documentation and acknowledgment shall be
# given in the documentation and software packages that this Software was
# used.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

$KCODE = 'u'

$VERBOSE=true

require 'etc'
require 'getoptlong'
require 'fileutils'

$version="0.9.10"
$opts = Hash.new

orig_opts = ARGV.dup

opts = GetoptLong.new(
  ["--background", "-b", GetoptLong::NO_ARGUMENT],
  ["--debug", "-d", GetoptLong::NO_ARGUMENT],
  ["--help",  "-h", GetoptLong::NO_ARGUMENT],
  ["--loglevel",  "-l", GetoptLong::REQUIRED_ARGUMENT],
  ["--trace",  "-t", GetoptLong::REQUIRED_ARGUMENT],
  ["--version", "-v", GetoptLong::NO_ARGUMENT]
)

$debug = false
$daemonize = false

opts.each {|opt, arg|
  $debug = true if(opt == "--debug")
  $daemonize = true if(opt == "--background")
  $opts[opt.sub(/^-+/, "")] = arg
}

$cl_loglevel = $opts["loglevel"].to_i

if ($opts["trace"])
  set_trace_func proc { |event, file, line, id, binding, classname|
    if classname.to_s == $opts["trace"]
      printf "TRACE: %8s %s:%-2d %10s %8s\n", event, File.basename(file), line, id, classname
    end
  }
end

defaultlib = File.expand_path(File.dirname($0) + '/../lib')

if File.directory? "#{defaultlib}/rbot"
  unless $:.include? defaultlib
    $:.unshift defaultlib
  end
end
  
begin
  require 'rbot/ircbot'
rescue LoadError => e
  puts "Error: couldn't find the rbot/ircbot module (or one of its dependencies)\n"
  puts e
  exit 2
end

if ($opts["version"])
  puts "rbot #{$version}"
  exit 0
end

if ($opts["help"])
  puts "usage: rbot [options] [config directory]"
  puts "  -h, --help         this message"
  puts "  -v, --version      version information"
  puts "  -d, --debug        enable debug messages"
  puts "  -b, --background   background (daemonize) the bot"
  puts "config directory defaults to ~/.rbot"
  exit 0
end

#
# Here is where we diverge from the core rbot functionality.
#
#if(bot = Irc::IrcBot.new(ARGV.shift, :argv => orig_opts))
if(bot = Berry_ircbot.new(ARGV.shift, :argv => orig_opts))
  # just run the bot
  bot.mainloop
end

