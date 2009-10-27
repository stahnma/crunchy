#!/usr/bin/ruby -w
#
# Test script for megahal wrapper
#
#

require 'megahal.rb'

def acceptInput
  print "Say:\n"
  foo = gets.chomp
  get_response(foo)
end

def get_response(input)

  if input == "exit"
    exit
  end

  print @wrapper.getResponse(input)
  print "\n"
  acceptInput
end

@wrapper = MegaHAL.new

print "Beginning Conversation...\n"
acceptInput
