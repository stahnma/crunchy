#!/bin/bash

#
#  TITLE:   Berry uninstall script
#  CREATED: 4/19/2009, Brian Larkin
#  USAGE:   Removes all berry components from a system.
#  NOTES:   This file does duplicate some functions that the control files perform.  We're doing
#           them here as well to ensure that everything is really removed.
#


# trigger stop of service
sudo /etc/init.d/berry stop

# make sure all files have been removed
sudo rm -rf /usr/lib/berry/
sudo rm /usr/bin/berry
sudo rm -rf /usr/share/doc/berry/

# lastly, make sure the user is deleted
sudo userdel -r berry


