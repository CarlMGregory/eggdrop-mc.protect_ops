##
# Protect Ops v1.6
#  by MC_8 - Carl M. Gregory <mc8@purehype.net>
#  This script will only run on eggdrop 1.5.5 or greater.
#
# My SVS Website - http://mc.purehype.net:81/
# Have a bug?  http://mc.purehype.net:81/bugzilla/
# TCL Mailing list - http://mc.purehype.net:81/maillist/
##

##
# This script basiclly does what 'chanset''s 'protectops' and 
# 'dontkickops' does, but with more options and customized reactions.  
# A "super protectops" as someone called it, wording in relation to 
# slennox's script "super bitch".
##

##
# HISTORY  ( <Fixed by> - [Found by] - <Info> )
##
# v1.6 (02.18.02)
#  MC_8 -        - Upgraded chanflag procedure from v1.0 to v2.0, more 
#                  effecent.
#  MC_8 -        - Upgraded replace procedure from v1.0 to v1.1, more 
#                  effecent.
#  MC_8 -        - Added a better error output system, for debugging 
#                  purposes.
#  MC_8 - Pr|muS - Added a 10 second buffer database for kicks.  If a 
#                  user is kicked he will be stored in this buffer zone 
#                  ... if a ban is established the buffer will be 
#                  evaluated too.  Here is why I did this, I would get 
#                  kicked, then banned.  But since I was kicked (not in 
#                  the channel) when the +b was set... it didn't know 
#                  who the ban was for... there for couldn't reverse 
#                  the ban (if enabled).
#  MC_8 -        - Added vhand as a replacment veriables.
#  MC_8 -        - Rewrote all procs, this is pretty much a totally
#                  rewritten script.
#  MC_8 -        - Removed comment setting.
#  MC_8 -        - Reworte all configs settings.
#  MC_8 -        - Upgraded SVS from v1.2 to v2.0.
#  MC_8 -        - Added ability to set 'exempt' to "" to exempt no 
#                  one.
#
# v1.5.1 (08.30.01)
#  MC_8 -      - Changed *_protect's value for protecting all op'd 
#                users.  Was "", now "-|-".
#  MC_8 - Kitt - Bans were protecting all op'd users regardless of 
#                ban_protect's setting.
# 
# v1.5 (02.07.01)
#  MC_8 -        - Specified the note to send to users based on flags, 
#                  instead of a list of handles.  This will make it 
#                  easier to specify who get's notes... on the fly.
#  MC_8 -        - Replacment veriable %victim for ban's was returning 
#                  %to rather than the victim.
#  MC_8 -        - Added SVS.
#  MC_8 - AZ0R0S - Fixed `Tcl error [mc:po:mode]: can't read 
#                  "mc_po(deop_protet)": no such variable'.
#  MC_8 - Ariesv - "It works properly aginst deop, but it does not work 
#                  against kicking, or banning protected users."
#
# v1.4.1 (11.15.00)
#  MC_8 - JaMeZ - Fixed, "The channel list, in whichs script will work, 
#                 also doesn't work. The only workable option is "", 
#                 aka all channs"
#  MC_8 -       - Fixed, Tcl error [mc:po:mode]: list element in braces 
#                 followed by "bla" instead of space.
#
# v1.4 (05.28.00)
#  MC_8 -           - Fixed problem with exempt users.
#  MC_8 -           - Added mc_po(comment) veriable.
#  MC_8 -           - Fixed bug in %reason for the notes.
#  MC_8 -           - Fixed a minor bug in the exempt flag users.
#  MC_8 -           - Fixed `invalid command name "findip"'
#  MC_8 - Dreamwave - When an op deops a non-registered op the script 
#                     deops the op and ops the non-registered op.
#  MC_8 - Dreamwave - Added a third option to the ban_reverse and 
#                     deop_reverse.
#  MC_8 - Dreamwave - Added the `mc_po(<type>_protect)' veriable.
#
# v1.3.1 (04.14.00)
#  MC_8 -           - Removed it's dependency on moretools. (gosta give 
#                     credits, Dreamwave beta tested it).
#  MC_8 - Dreamwave - Fixed `Tcl error [mc:po:mode]: can't read 
#                     "knick": no such variable'.
#  MC_8 - Dreamwave - Fixed `when you choose creat user entry the 
#                     script creates like 10 user entrys'.
#  MC_8 - Dreamwave - Fixed `Tcl error [mc:po:kick]: can't read 
#                     "type_flagchange": no such variable'.
#
# v1.3 (03.28.00)
#  MC_8 - Dreamwave - Fixed `Tcl error [mc:po:mode]: can't read 
#                     "type_notice": no such variable'.
#  MC_8 - Dreamwave - added new veriable, mc_po(also_protect).
#
# v1.2 (02-07-00)
#  MC_8 - CrAs|-| - The script wasn't changing flags nor, fix
#
# v1.1 (01-20-00)
#  MC_8 - - Added more reaction options.
#
# v1.0 (01-16-00)
#  MC_8 - CrAs|-| - Inital release.
##

##
# Commands
##
# DCC:
#  chanset <#channel> <+/->mc.protectops
#     This will enable (+) or disable (-) the script for the specific 
#     channel.
##

##
# Settings
##


## Kick protection settings.

# What op'd users do you want to protect from op kick's?  If you want 
# to protect every op that is currently op'd, regardless if there a 
# registered op in the bot, then set this to "-|-".  Set this to "" to 
# disable kick protection.  Flag syntax: <global>|<channel>
set mc_po(kick:protect) "o|o"

# If an op kicks another op, what would you like the script to say to 
# that the abusive op?  Set to "" to disable.
set mc_po(kick:msg) "You just kicked an op, that's against the op rules."

# [0=Privage Message/1=Private Notice] If the above, kick:msg, is not 
# set to "" (disabled); how do you want to go about sending that text?
set mc_po(kick:msg:method) 0

# [0=no/1=yes] If an op kicks another op, do you want the script to 
# deop the abusive op?
set mc_po(kick:deop) 1

# [0=no/1=yes] If an op kicks another op, do you want the script to 
# kick the abusive op?
set mc_po(kick:kick) 0

# If an op kicks another op, do you want the script to ban the abusive 
# op?
#   -2 = Server ban (sets the ban on the channel, 
#        but not in the bots internal banlist).
#   -1 = Permanente ban.
#    0 = Do not ban.
#   Any number greater than 0 will be considered the duration of the
#   ban (in min.s).  If you want the ban to be "sticky" (read up on 
#   '.help stick') then append this with a '!' (exclimation point).
#   Ie: set mc_po(kick:ban) 1440!
set mc_po(kick:ban) 0

# If an op kicks another op, what flag changes (if any) do you want to 
# give the abusive op?  Set to "-|-" to disable this.  You can even go 
# as far as setting this to "+dk|-", with would mean to auto deop and 
# kick the abusive op everytime (s)he enters the channel (check out 
# '.help whois' for a listing of flags and what they do).
# Flag syntax: <global>|<channel>
set mc_po(kick:flgchg) "-mtfo|-mtfo"

# [0=no/1=yes] If the above, kick:flgchg, isn't disabled and the user 
# doesn't exist, do you want to auto add the user to the bot's userfile 
# so that the flag changes do take place?  This is usefull if your 
# setting the flag changes to something like +dk, not to usefull for a 
# flag change such as -mtfo|-mtfo because that would just create a 
# useless/flagless userfile entry.  The auto added users will go into 
# one userfile entry named 'kickAuto'.  Each new abusive op will be 
# added to this entry (via +host).  If one of these handless already 
# exists in the userfile, it will be appended with a number ranging 
# from 0 to 9 (ie: kickAuto1).
set mc_po(kick:adduser) 0


## Ban protection settings.

# What op'd users do you want to protect from op ban's?  If you want to 
# protect every op that is currently op'd, regardless if there a 
# registered op in the bot, then set this to "-|-".  Set this to "" to 
# disable ban protection.  Flag syntax: <global>|<channel>
set mc_po(ban:protect) "o|o"

# If an op bans another op, what would you like the script to say to 
# that the abusive op?  Set to "" to disable.
set mc_po(ban:msg) "You just banned an op, that's against the op rules."

# [0=Privage Message/1=Private Notice] If the above, ban:msg, is not 
# set to "" (disabled); how do you want to go about sending that text?
set mc_po(ban:msg:method) 0

# [0=no/1=yes] If an op bans another op, do you want the script to deop 
# the abusive op?
set mc_po(ban:deop) 1

# [0=no/1=yes] If an op bans another op, do you want the script to kick
# the abusive op?
set mc_po(ban:kick) 0

# If an op bans another op, do you want the script to ban the abusive 
# op?
#   -2 = Server ban (sets the ban on the channel, 
#        but not in the bots internal banlist).
#   -1 = Permanente ban.
#    0 = Do not ban.
#   Any number greater than 0 will be considered the duration of the
#   ban (in min.s).  If you want the ban to be "sticky" (read up on 
#   '.help stick') then append this with a '!' (exclimation point).
#   Ie: set mc_po(ban:ban) 1440!
set mc_po(ban:ban) 0

# [0=no/1=yes/2=yes (read)] If an op bans another op, do you want to
# reverse (remove) the ban set by the abusive op?  If this is set to 2, 
# it will only reverse the ban if the banned op is a registered op
# (has +o in the userfile).
set mc_po(ban:reverse) 2

# If an op bans another op, what flag changes (if any) do you want to 
# give the abusive op?  Set to "-|-" to disable this.  You can even go 
# as far as setting this to "+dk|-", with would mean to auto deop and 
# kick the abusive op everytime (s)he enters the channel (check out 
# '.help whois' for a listing of flags and what they do).
# Flag syntax: <global>|<channel>
set mc_po(ban:flgchg) "-mtfo|-mtfo"

# [0=no/1=yes] If the above, ban:flgchg, isn't disabled and the user 
# doesn't exist, do you want to auto add the user to the bot's userfile 
# so that the flag changes do take place?  This is usefull if your 
# setting the flag changes to something like +dk, not to usefull for a 
# flag change such as -mtfo|-mtfo because that would just create a 
# useless/flagless userfile entry.  The auto added users will go into 
# one userfile entry named 'banAuto'.  Each new abusive op will be 
# added to this entry (via +host).  If one of these handless already 
# exists in the userfile, it will be appended with a number ranging 
# from 0 to 9 (ie: banAuto1).
set mc_po(ban:adduser) 0


## Deop protection settings.

# What op'd users do you want to protect from op deop's?  If you want 
# to protect every op that is currently op'd, regardless if there a 
# registered op in the bot, then set this to "-|-".  Set this to "" to 
# disable deop protection.  Flag syntax: <global>|<channel>
set mc_po(deop:protect) "o|o"

# If an op deop's another op, what would you like the script to say to 
# that the abusive op?  Set to "" to disable.
set mc_po(deop:msg) "You just deop'd an op, that's against the op rules."

# [0=Privage Message/1=Private Notice] If the above, deop:msg, is not 
# set to "" (disabled); how do you want to go about sending that text?
set mc_po(deop:msg:method) 0

# [0=no/1=yes] If an op deop's another op, do you want the script to 
# deop the abusive op?
set mc_po(deop:deop) 1

# [0=no/1=yes] If an op deop's another op, do you want the script to 
# kick the abusive op?
set mc_po(deop:kick) 0

# If an op deop's another op, do you want the script to ban the abusive 
# op?
#   -2 = Server ban (sets the ban on the channel, 
#        but not in the bots internal banlist).
#   -1 = Permanente ban.
#    0 = Do not ban.
#   Any number greater than 0 will be considered the duration of the
#   ban (in min.s).  If you want the ban to be "sticky" (read up on 
#   '.help stick') then append this with a '!' (exclimation point).
#   Ie: set mc_po(deop:ban) 1440!
set mc_po(deop:ban) 0

# [0=no/1=yes/2=yes (read)] If an op deop's another op, do you want to
# reverse (reop) the victim op?  If this is set to 2, it will only 
# reverse the deop if the victim op is a registered op (has +o in the 
# userfile).
set mc_po(deop:reverse) 2

# If an op deop's another op, what flag changes (if any) do you want to 
# give the abusive op?  Set to "-|-" to disable this.  You can even go 
# as far as setting this to "+dk|-", with would mean to auto deop and 
# kick the abusive op everytime (s)he enters the channel (check out 
# '.help whois' for a listing of flags and what they do).
# Flag syntax: <global>|<channel>
set mc_po(deop:flgchg) "-mtfo|-mtfo"

# [0=no/1=yes] If the above, deop:flgchg, isn't disabled and the user 
# doesn't exist, do you want to auto add the user to the bot's userfile 
# so that the flag changes do take place?  This is usefull if your 
# setting the flag changes to something like +dk, not to usefull for a 
# flag change such as -mtfo|-mtfo because that would just create a 
# useless/flagless userfile entry.  The auto added users will go into 
# one userfile entry named 'deopAuto'.  Each new abusive op will be 
# added to this entry (via +host).  If one of these handless already 
# exists in the userfile, it will be appended with a number ranging 
# from 0 to 9 (ie: deopAuto1).
set mc_po(deop:adduser) 0


## Miscellaneous settings.

# What flaged users do you want to exempt from this script?  Set to "" 
# to exempt no one.
set mc_po(exempt) "b|"

# What other flagged users do you want to protect as well?  This is 
# usefull if the matching flagged user is not op'd, the script will 
# still protect him/her.  Set this to "" to disable.
#  Flag syntax: <global>|<channel>
set mc_po(also:protect) "ov|ov"

# [0=no/1=yes] If the bot isn't op'd and the appropriate *:msg isn't 
# disabled, do you still want to notice/msg the user?
set mc_po(bigtalker) 0

# What flagged users do you want the script to send a note to upon 
# protecing an op?  Setting this to "-|-" will send a note to everyone 
# in the userfile.  Set this setting to "" if you would like to disable 
# note note sending.  Flag syntax: <global>|<channel>
set mc_po(note:flg) ""

# If the above, note:flg, isn't disabled; what do you want the note to 
# say?
# Replacment veriables are:
#   %botnick = The bot's current irc nickname.
#   %to      = The handle the note is going to.
#              (notes are processed 1 user at a time)
#   %type    = The type of protection triggered (deop, kick, or ban).
#   %nick    = The irc nickname of the abusive op.
#   %ident   = The ident of the abusive op.
#   %host    = The host of the abusive op.
#   %hand    = The handle (userfile entry) of the abusive op.
#   %chan    = The channel this protection was triggered in.
#   %victim  = The victim op.
#   %vhand   = The victim's handle.
#   %reason  = If the protection triggered was for a kick, this will be 
#              replaced with the kick message.  ban and deop's have no 
#              reason, therefor will be replaced with "" (nothing).
set mc_po(note:msg) "Attention %to, %nick (%ident!%host) (handle: %hand) %type'd %victim in %chan.  (%reason)"

# How do you want to mask hosts?  This is used for banning and adding
# a user to the userfile (if either enabled).
#      0 - *!user@host.domain
#      1 - *!*user@host.domain
#      2 - *!*@host.domain
#      3 - *!*user@*.domain
#      4 - *!*@*.domain
#      5 - nick!user@host.domain
#      6 - nick!*user@host.domain
#      7 - nick!*@host.domain
#      8 - nick!*user@*.domain
#      9 - nick!*@*.domain
#     You can also specify a type of 10 to 19 which correspond to masks 
#     0 to 9.  But if the host.domain is a;
#       hostname = Instead of using a * wildcard to replace portions of 
#                  the host.domain, it replaces the numbers in the 
#                  host.domain with a '?' (question mark) wildcard.
#       ip       = It will mask as normal, with no '?' (question mark)
#                  replacments as does hostname.
set mc_po(masktype) 3


## MC SVS (Script Version Service) v2.0 ##
# [0=no/1=yes] Do you want the bot to connection to MC_8's SVS to see
# if there are newer versions of this script avilable?  It will only
# tell you -- It's up to you to get the newest version (I decided not
# to auto update the code, there may be new features in the newest
# script that may require your attention).
set mc_po(svs:enabled) 1

# Once a day the script will check with the SVS -- this specifies when
# that should happen.  The setting should be the hour (military).
# examples:
#  set mc_po(svs:check) 0   ;#This is at Midnight
#  set mc_po(svs:check) 5   ;#This is at 5am
#  set mc_po(svs:check) 13  ;#This is at 1pm
#  set mc_po(svs:check) 23  ;#This is at 11pm
set mc_po(svs:check) 3

# Upon finding a newer version of this script, who do you want this
# script to send a note to telling them of this newer version? If more
# than 1 user is to be notified, seperate each user with a ' ' (space).
set mc_po(svs:notify) "MC_8"

# Do you want even beta version notified to whomever you have set?  Or
# just stable releases of the script?
#  0 = Tell me about all version, even beta versions.
#  1 = Just tell me about new stable versions.
set mc_po(svs:stableonly) 0


##
# TCL Coding below, do not proceed.
##

#Script:mc_po

set mc_po(script)      "Protect Ops"
set mc_po(version)     "v1.6"
set mc_po(svs:script)  "protectops"
set mc_po(svs:version) "001006000000"
set mc_po(svs:server)  "mc.purehype.net"
set mc_po(svs:port)    "81"
set mc_po(svs:get)     "/"
set mc_po(svs:query)   "svs=$mc_po(svs:script)&version=$mc_po(svs:version)"

if {$numversion < "1050500"} {
 putlog "$mc_po(script) $mc_po(version) by MC_8 will only work on eggdrop 1.5.5 or greater."
 putlog "$mc_po(script) $mc_po(version)  will not work with eggdrop $version."
 putlog "$mc_po(script) $mc_po(version)  not loaded."
 return 1
}

setudef flag mc.protectops

proc mc:po:error {bindproc error {arg ""}} {
 global mc_po version lastbind
 putlog "Error in script $mc_po(script) $mc_po(version)."
 putlog "       Last bind: $lastbind"
 putlog "       Procedure: $bindproc"
 putlog "            Args: $arg"
 putlog " Eggdrop version: $version"
 putlog "     TCL version: [info tclversion]"
 putlog "*** Please tell MC_8 about this BUG!  Visit        "
 putlog "*** http://mc.purehype.net:81/bugzilla/ to do so.  "
 putlog "*** Please include the next line in the bug report."
 error $error
}

proc mc:po:errchk {command arg} {
 if {[catch {eval $command $arg} return]} {
  mc:po:error $command $return $arg; return 0
 }; return $return
}

bind kick - * mc:po:kick
proc mc:po:kick {nick uhost hand chan knick reason} {
 return [mc:po:errchk mc:po:kick_ [list $nick $uhost $hand $chan $knick $reason]]
}
proc mc:po:kick_ {nick uhost hand chan knick reason} {
 if {[mc:po:return $nick $hand $chan kick]} {return 0}
 mc:po:ial add $chan $knick![getchanhost $knick $chan] [nick2hand $knick $chan]
 mc:po:protectops $nick $uhost $hand $chan kick $knick $reason
}

bind mode - * mc:po:mode
proc mc:po:mode {nick uhost hand chan mode victim} {
 return [mc:po:errchk mc:po:mode_ [list $nick $uhost $hand $chan $mode $victim]]
}
proc mc:po:mode_ {nick uhost hand chan mode victim} {
 global mc_po botnick
 switch -- $mode {
  "+b" {
   if {[mc:po:return $nick $hand $chan ban]} {return 0}
   if {[set user [mc:po:ial find $chan $victim]] != ""} {
    mc:po:protectops $nick $uhost $hand $chan ban @$user $victim
   }
   foreach user [mc:po:findnick $victim $chan] {
    mc:po:protectops $nick $uhost $hand $chan ban [lindex $user 0] $victim
   }
  }
  "-o" {
   if {[mc:po:return $nick $hand $chan deop]} {return 0}
   mc:po:protectops $nick $uhost $hand $chan deop $victim
  }
 }
}

proc mc:po:protectops {nick uhost hand chan type victim {reason ""}} {
 return [mc:po:errchk mc:po:protectops_ [list $nick $uhost $hand $chan $type $victim $reason]]
}
proc mc:po:protectops_ {nick uhost hand chan type victim {reason ""}} {
 global mc_po botnick
 if {[regexp -- ^@(.*) $victim match temp]} {
  set victim [lindex $temp 0]
  set vhand [lindex $temp 1]
 } else {set vhand [nick2hand $victim $chan]}
 if {!((([matchattr $vhand $mc_po(also:protect) $chan]) &&
        ($mc_po(also:protect) != "")) || ([isop $victim $chan])) ||
     !(([matchattr $vhand $mc_po(${type}:protect) $chan]) ||
       ($mc_po(${type}:protect) == "-|-")) || 
     ([string tolower $nick] == [string tolower $victim])} {return 0}
 if {!(([info exists mc_po(:ignore:${type}:$nick:)]) &&
      ([expr [clock seconds]-$mc_po(:ignore:${type}:$nick:)] <= "2"))} {
  if {($mc_po(${type}:deop)) && ([isop $nick $chan])} {putserv "MODE $chan -o $nick"}
  if {$mc_po(${type}:msg) == ""} {set msg "Protect Ops"} else {set msg $mc_po(${type}:msg)}
  set banmask [mc:po:masktype $nick!$uhost $mc_po(masktype)]
  if {![regexp -- {^0!?$} $mc_po(${type}:ban)]} {
   if {[regexp -- {(.*[^!])!?$} $mc_po(${type}:ban) match time]} {set option "sticky"} \
   else {set option "none"}
   if {$time == "-1"} {set time 0}
   if {$time >= "0"} {newchanban $chan $banmask ProtectOp $msg $time $option}
   if {([mc:po:findnick $banmask $chan] != "") && ([isop $botnick $chan])} {
    putserv "MODE $chan +b $banmask"
   }
  }
  if {($mc_po(${type}:kick)) && ([onchan $nick $chan]) && ([isop $botnick $chan])} {
   putserv "KICK $chan $nick :$msg"
  }
  if {$mc_po(kick:flgchg) != "-|-"} {
   if {[validuser $hand]} {chattr $hand $mc_po(${type}:flgchg) $chan} \
   elseif {$mc_po(${type}:adduser)} {
    for {set i 0; set x ${type}Auto} {
     ([validuser $x]) && ([getuser $x XTRA mc.protectops] != "inuse") && ($i < "10")
    } {incr i} {set x ${type}Auto${i}}
    if {$i == "10"} {putlog "$mc_po(script):  Error creating a userfile entry, ${type}Auto (append 0-9 as well) is already in use."} \
    elseif {![validuser $x]} {adduser $x $banmask} \
    else {
     if {[getuser $x COMMENT] == ""} {setuser $x COMMENT "Abusive ops that $type'd other ops."}
     setuser $x HOSTS $banmask
     chattr $x $mc_po(${type}:flgchg) $chan
    }
   }
  }
  if {$mc_po(${type}:msg) != ""} {
   if {!$mc_po(${type}:msg:method)} {set x "PRIVMSG"} else {set x "NOTICE"}
   if {[isop $botnick $chan] || $mc_po(bigtalker)} {puthelp "$x $nick :$msg"}
  }
  if {$mc_po(note:flg) != ""} {
   scan $uhost {%[^@]@%s} ident host
   foreach user [userlist $mc_po(note:flg) $chan] {
    set vic $victim; set rea $reason
    if {$type == "ban"} {set vic $reason; set rea ""}
    set msg [mc:po:replace $mc_po(note:msg) [list %botnick $botnick %to $user %type $type %nick $nick %ident $ident %host $host %hand $hand %chan $chan %victim $vic %vhand $vhand %reason $rea]]
    switch -- [sendnote ProtectOp $user $msg] {
     0 {
      if {![validuser $user]} {set x "invalid user"} else {set x "unknown error"}
      putlog "$mc_po(script):  Error trying to send note to $user, $x."
     }
     3 {putlog "$mc_po(script):  Error trying to send note to $to, notebox too full!"}
    }
   }
  }
 }; set mc_po(:ignore:${type}:$nick:) [clock seconds]
 switch -- $type {
  ban {
   switch -- $mc_po(ban:reverse) {
    1 {putserv "MODE $chan -b $reason"}
    2 {
     if {[matchattr $vhand "o|o" $chan]} {putserv "MODE $chan -b $reason"}
    }
   }
  }
  deop {
   switch -- $mc_po(deop:reverse) {
    1 {putserv "MODE $chan $chan +o $victim"}
    2 {
     if {[matchattr $vhand "o|o" $chan]} {putserv "MODE $chan +o $victim"}
    }
   }
  }
 }
}

proc mc:po:return {nick hand chan type} {
 return [mc:po:errchk mc:po:return_ [list $nick $hand $chan $type]]
}
proc mc:po:return_ {nick hand chan type} {
 global mc_po botnick
 if {(![mc:po:chanflag $chan mc.protectops]) || ($mc_po(${type}:protect) == "") ||
     ($nick == "") || ([string tolower $botnick] == [string tolower $nick]) ||
     (([matchattr $hand $mc_po(exempt) $chan]) && ($mc_po(exempt) != ""))} {return 1}
 return 0
}

proc mc:po:ial {{command ""} {chan ""} {nuhost ""} {hand ""}} {
 return [mc:po:errchk mc:po:ial_ [list $command $chan $nuhost $hand]]
}
proc mc:po:ial_ {{command ""} {chan ""} {nuhost ""} {hand ""}} {
 global mc_po
 set chan [string tolower $chan]
 set nuhost [string tolower $nuhost]
 if {![info exists mc_po(:ial:)]} {set mc_po(:ial:) ""}
 switch -- $command {
  "" {return $mc_po(:ial:)}
  find {
   foreach user [mc:po:ial] {
    if {([string match $nuhost [lindex $user 1]]) && ([lindex $user 0] == $chan)} {
     scan [lindex $user 1] {%[^!]!%[^@]@%s} nick ident host
     return [list $nick [lindex $user 2]]
    }
   }
  }
  add {
   lappend mc_po(:ial:) [list $chan $nuhost $hand]
   utimer 10 [list mc:po:ial remove $chan $nuhost $hand]
  }
  remove {
   for {
    set i [llength $mc_po(:ial:)]
    set index [lsearch -exact $mc_po(:ial:) [list $chan $nuhost $hand]]
   } {($index != "-1") && ($i)} {
    incr i -1
    set index [lsearch -exact $mc_po(:ial:) [list $chan $nuhost $hand]]
   } {set mc_po(:ial:) [lreplace $mc_po(:ial:) $index $index]}
  }
 }; return ""
}

# v1.1
proc mc:po:replace {text subs} {
 if {![catch {string map -nocase $subs $text} output]} {return $output}
 for {set i 0} {[lindex $subs $i] != ""} {incr i 2} {
  regsub -all -- {([\\\*\+\?\{\}\,\(\)\:\[\]\.\^\$\=\!\|])} [lindex $subs $i] {\\\1} temp(temp)
  regsub -all -- $temp(temp) $text [lindex $subs [expr $i+1]] text
 }; return $text
}

# v1.0
proc mc:po:findnick {hostmask {channel ""}} {
 if {![validchan $channel]} {
  if {$channel != ""} {return -code error "no such channel record"} \
  else {set channel [channels]}
 }; set buffer "" ; set hostmask [string tolower $hostmask]
 foreach chan $channel {
  foreach user [chanlist $chan] {
   if {[string match $hostmask [string tolower $user![getchanhost $user $chan]]]} {
    lappend buffer [list $user $chan]
   }
  }
 }; return $buffer
}

# v1.0
proc mc:po:masktype {hostmask type} {
 set ident_max-length 9
 set host_max-length 63
 scan $hostmask {%[^!]!%[^@]@%s} nick ident host
 set maskhost 1
 if {[regexp -- {^1[0-9]$} $type]} {
  if {!([regexp -- {^([0-9][0-9]?[0-9]?)\.([0-9][0-9]?[0-9]?)\.([0-9][0-9]?[0-9]?)\.([0-9][0-9]?[0-9]?)$} $host temp a b c d] && ($a > 0 && $a < 255 && $b < 255 && $c < 255 && $d < 255))} {
   regsub -all {[0-9]} $host "?" host
   set maskhost 0
  };set type [string index $type 1]
 }
 if {[regexp -- {^[0-4]$} $type]} {set nick "*"}
 if {[regexp -- {^[2479]$} $type]} {set ident "*"}
 if {[regexp -- {^[1368]$} $type]} {set ident "*[string trimleft $ident ~]"}
 if {[regexp -- {^[3489]$} $type]} {if {$maskhost} {scan [maskhost $host] {%[^@]@%s} temp host}}
 if {[string length $ident] > ${ident_max-length}} {
  set ident "*[string range $ident [expr [string length $ident]-${ident_max-length}] end]"
 }
 if {[string length $host] > ${host_max-length}} {
  set host "*[string range $host [expr [string length $host]-${host_max-length}] end]"
 }; return [format "%s!%s@%s" $nick $ident $host]
}

# v2.0
proc mc:po:chanflag {channel flag} {
 if {[lsearch -exact [string tolower [channel info $channel]] +[string tolower $flag]] == "-1"} {return 0}
 return 1
}

## SVS v2.0
if {(![info exists mc_po(svs:enabled)]) ||
    (![regexp -- {^(0|1)$} $mc_po(svs:enabled)])} {set mc_po(svs:enabled) 0}
if {(![info exists mc_po(svs:check)]) ||
    ([regexp -- {[^0-9]} $mc_po(svs:check)])} {set mc_po(svs:check) 0}
if {![info exists mc_po(svs:notify)]} {set mc_po(svs:notify) $owner}
if {(![info exists mc_po(svs:stableonly)]) ||
    (![regexp -- {^(0|1)$} $mc_po(svs:stableonly)])} {set mc_po(svs:stableonly) 0}
foreach bind [binds mc:po:svs:time] {
 unbind [lindex $bind 0] [lindex $bind 1] [lindex $bind 2] [lindex $bind 4]
}
foreach command [info commands mc:po:svs:time] {rename $command ""}
if {$mc_po(svs:enabled)} {
 if {($mc_po(svs:check) > "23") || ($mc_po(svs:check) < "0")} {set mc_po(svs:check) 00}
 if {[string length $mc_po(svs:check)] == "1"} {set mc_po(svs:check) 0$mc_po(svs:check)}
 bind time - "00 $mc_po(svs:check) *" mc:po:svs:time
 proc mc:po:svs:time {{args ""}} {
  global mc_po
  if {[catch {socket -async $mc_po(svs:server) $mc_po(svs:port)} sid]} {;\
   putlog "SVS Error\[$mc_po(svs:script)/$mc_po(svs:version)\]:  $sid"
   return 1
  }
  fconfigure $sid -blocking 0 -buffering line
  set tout [after 60000 "mc:po:svs:interface $sid timeout"]
  fileevent $sid readable "mc:po:svs:interface $sid $tout"
  puts $sid "GET $mc_po(svs:get)?$mc_po(svs:query) HTTP/1.0\
           \nHost: $mc_po(svs:server)\n"
  flush $sid
 }
}
proc mc:po:svs:interface {sid tout} {
 global mc_po
 if {$tout == "timeout"} {
  putlog "SVS Warning\[$mc_po(svs:script)/$mc_po(svs:version)\]:  SVS Server timed out."
  close $sid
  return 0
 }; after cancel $tout
 set temp 0
 while {![eof $sid]} {
  gets $sid get
  if {$temp < "2"} {
   if {$get == ""} {incr temp; if {$temp == "1"} {set temp 2}}
   continue
  }; if {$get == ""} {continue}
  switch -- [lindex $get 0] {
   003 {
    set reply [lrange $get 1 end]
    if {[lindex $reply 0] != $mc_po(svs:script)} {
     putlog "SVS Error\[$mc_po(svs:script)/$mc_po(svs:version)\]:  SVS Server sent wrong info, got [lindex $reply 0]"
     break   
    }
    if {$mc_po(svs:stableonly)} {
     set temp [string range $mc_po(svs:version) 0 8]999
    } else {set temp [string range $mc_po(svs:version) 0 11]}
    if {[lindex $reply 1] > $temp} {
     set note [lindex $reply 5]
     regsub -- %0 $note [lindex $reply 0] note
     regsub -- %1 $note [lindex $reply 1] note
     regsub -- %2 $note [lindex $reply 2] note
     regsub -- %3 $note [lindex $reply 3] note
     regsub -- %4 $note [lindex $reply 4] note
     regsub -- %version $note $mc_po(version) note
     foreach to [split $mc_po(svs:notify) ",; "] {
      if {$to == ""} {continue}
      regsub -- %nick $note $to outnote
      if {[string match *$outnote* [set unotes [notes $to -[notes $to]]]]} {
       set temp 0
       foreach unote $unotes {
        if {$outnote == [lindex $unote 2]} {set temp 1; break}
       }; if {$temp} {continue}
      }
      switch -- [sendnote SVS $to $outnote] {
       0 {
        if {![validuser $notify]} {set x "invalid user"} else {set x "unknown error"}
        putlog "SVS Error\[$mc_po(svs:script)/$mc_po(svs:version)\]:  Trying to send note to $to, $x."
       }
       3 {putlog "SVS Error\[$mc_po(svs:script)/$mc_po(svs:version)\]:  Trying to send note to $to, notebox too full!"}
      }
     }
    }
   }
  }
 }; close $sid
}
## ^

putlog "$mc_po(script) $mc_po(version) by MC_8 loaded."
