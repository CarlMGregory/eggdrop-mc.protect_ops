##
# Protect Ops v1.5 by MC_8 - Carl M. Gregory <gregory@worldinter.net>
#  For eggdrop 1.5.0 and above only.
#
# My SVS Website - http://mc.purehype.net/
##

##
# Why have this script - one may ask, it was requested by an op in #wareznorth at undernet.
# Basiclly does what .chanset #channel +protectops +dontkickops does, but you can customize
# it's reaction.  And it utalizes to botnet and IRC lag to the best of it's ability to
# stop takeover attacks via a flood deop (very usefull if deop flood settings 3:60 or so).
##

##
# HISTORY  ( <Fixed by> - <Found by> - <Info> )
##
# v1.5 (02.07.01)
#  MC_8 - Specified the note to send to users based on flags, insted of a list of handles.
#         This will make it easier to specify who get's notes... on the fly.
#  MC_8 - Replacment veriable %victim for ban's was returning %to rather than the victim.
#  MC_8 - Added SVS
#  MC_8 - AZ0R0S - Fixed `Tcl error [mc:po:mode]: can't read "mc_po(deop_protet)": no such variable'
#  MC_8 - Aries - "It works properly aginst deop, but it does not work against
#                 kicking, or banning protected users."
#
# v1.4.1 (11.15.00)
#  MC_8 - JaMeZ - Fixed, "The channel list, in whichs script will work, also 
#                 doensnt work. The only workable option is "", aka all channs"
#  MC_8 - Fixed, Tcl error [mc:po:mode]: list element in braces followed by
#         "bla" instead of space
#
# v1.4 (05.28.00)
#       - Fixed problem with exempt users.
#       - Added mc_po(comment) veriable.
#       - Fixed bug in %reason for the notes.
#       - Fixed a minor bug in the exempt flag users.
#       - fixed `invalid command name "findip"'
#  MC_8 - Dreamwave - When an op deops a non-registered op the script deops the
#                     op and ops the non-registered op.
#                   - Added a third option to the ban_reverse and deop_reverse.
#                   - Added the `mc_po(<type>_protect)' veriable.
#
# v1.3.1 (04.14.00)
#  MC_8 - MC_8 - Removed it's dependency on moretools. (gosta give credits, Dreamwave beta
#                tested it)
#  MC_8 - Dreamwave - Fixed `Tcl error [mc:po:mode]: can't read "knick": no such variable'.
#                   - Fixed `when you choose creat user entry the script creates like 10
#                     user entrys'.
#                   - Fixed `Tcl error [mc:po:kick]: can't read "type_flagchange": no such
#                     variable'.
#
# v1.3 (03.28.00)
#  MC_8 - Dreamwave - Fixed `Tcl error [mc:po:mode]: can't read "type_notice": no such
#                     variable'
#                   - added new veriable, mc_po(also_protect).
#
# v1.2 (02-07-00)
#  MC_8 - CrAs|-| - The script wasn't changing flags nor, fix
#
# v1.1 (01-20-00)
#  MC_8 - added more reaction options
#
# v1.0 (01-16-00)
#  MC_8 - CrAs|-| - inital release
##

# Note:
#  There is one setting you set from dcc chat with the bot using .chanset.
#   <+/->mc.protectops  Setting this to +mc.protectops will enable the
#                       script for the particular channel.
#
#  Example from dcc chat with the bot:
#   .chanset #channel +mc.protectops

#mc_po(exempt) defines what flaged users you want to exempt from any reactions.
set mc_po(exempt) "b|"

# Do you want to react even though I'm not op'd?  
#  0=only reacts when bot is op'd
#  1=reacts with bot is op'd or not op'd (usefull if all you want to do is get the 
#    notice to the user)
set mc_po(bigtalker) 0

#mc_po(create_user) defines wether or not to create a user entry if one does not 
# exist.  Good if you are going to change the users flags to something with 
# punishment (like +d or +k).
#  0=will not create a user entry if one does not already exist
#  1=create user entry if one does not already exist
# note:  This setting only used if you are going to change user flags durring a
#        reaction.  If you don't plan to, then don't worry about this setting,
#        leave it alone.
set mc_po(create_user) 0

# I will (the script) send you a note upon my reaction to better keep you, or anyone
# you chose, informed on the situation.  Please specify the flags the user is to have
# to be considered worthy of the note.  Set this to "-|-" if you would like to 
# disable this feature.  You can create a user defined (A-Z) flag if you like, you can
# also use standard eggdrop flags.  The flag system is always in this format:
# <global>|<channel>
set mc_po(note) "n|n"

# If you did not set mc_po(note) to "-|-", you might want to specify what you want me
# to say.  Set this to what you want the note to read.  Replacment data accepted,
# legend below.
#  %botnick = My current irc nick.
#  %to      = The handle the note is going to.
#  %type    = The type of reaction.  deop, kick, or ban
#  %nick    = The person that caused the reaction.
#  %uhost   = The person that caused the reaction's user host.
#  %hand    = The handle of the person that caused the reaction.
#  %chan    = The cannel it happened on.
#  %victim  = The victim, the op that got deop/kick/ban'd.
#  %reason  = The reason.  This will only show data for kicks, anything else it
#             will be "" (nothing).
set mc_po(note_msg) "Attention %to, %nick (handle: %hand) %type'd %victim in %chan.  (%reason)"

# If a non exempt user kicks another op, what do you want to do?
#  0=Notice user                         (notice message supplied below)
#  1=Deop user
#  2=Deop user and Notice user
#  3=Kick user                           (Kick message is same as user notice)
#  4=Kick user and Notice user
#  5=Deop user and Change users flags    (flags are specified in mc_po(kick_flagchange))
#  6=Deop user and Notice user and Change users flags
#  7=Kick user and Change users flags
#  8=Kick user and Notice user and Change users flags
# default is 2, To turn the kick response off all together set this to 0, and set
# kick_notice to ""
set mc_po(kick_reaction) 6

# Who do you really want to protect?  You can specify there flags below.  If you want
# to protect everyone that is op'd, set this to "".  If you only want to protect
# the masters (global|channel) then set it to "m|m".  You can set to what ever you like,
# but remember, it's "<global_flag>|<channel_flag>"
set mc_po(kick_protect) "o|o"

#mc_po(kick_notice) defines the message to be noticed to the user and/or the message
# to displayed on a kick.  
set mc_po(kick_notice) "You just kicked an OP.  That is against the OP rules!  You have now lost your OP access."

#mc_po(kick_flagchange) will be where you set what flag changes to do upon reaction to
# a kick of an op.  Please specify the | character, for those that don't know what it 
# is, it's <global>|<channel> flag system.  If you just put in "-o" .. it's going to 
# think that's global, so do "-|-o" instead.
set mc_po(kick_flagchange) "-mto|-mto"

# If a non exempt user bans another op, what do you want to do?
#  0=Notice user              (notice message supplied below)
#  1=Deop user
#  2=Deop user and Notice user
#  3=Kick user                (Kick message is same as user notice)
#  4=Kick user and Notice user
#  5=Deop user and Change users flags    (flags are specified in mc_po(ban_flagchange))
#  6=Deop user and Notice user and Change users flags
#  7=Kick user and Change users flags
#  8=Kick user and Notice user and Change users flags
# default is 2, To turn the kick response off all together set this to 0, and 
# set ban_notice to ""
set mc_po(ban_reaction) 6

# Who do you really want to protect?  You can specify there flags below.  If you want
# to protect everyone that is op'd, set this to "".  If you only want to protect
# the masters (global|channel) then set it to "m|m".  You can set to what ever you like,
# but remember, it's "<global_flag>|<channel_flag>"
set mc_po(ban_protect) "o|o"

#mc_po(ban_notice) defines the message to be noticed to the user and/or the message to be
# displayed on a kick.  
set mc_po(ban_notice) "You just Banned an OP.  That is against the OP rules!  You have now lost your OP access."

# If a non exempt user sets a ban that matches an op, do you want to reverse the ban? 
#  0=no  
#  1=yes  - But only if that user is a registerd op (has +o in the userfile).
#  2=yes  - Will unban the ban'd user regardless if the user is registered or not.
set mc_po(ban_reverse) 1

#mc_po(ban_flagchange) will be where you set what flag changes to do upon reaction
# to a ban of an op.  Please specify the | character, for those that don't know what 
# it is, it's <global>|<channel> flag system.  If you just put in "-o" .. it's going
# to think that's global, so do "-|-o" instead.
set mc_po(ban_flagchange) "-mto|-mto"

# If a non exempt user deops another op, what do you want to do?
#  0=Notice user              (notice message supplied below)
#  1=Deop user
#  2=Deop user and Notice user
#  3=Kick user                (Kick message is same as user notice)
#  4=Kick user and Notice user
#  5=Deop user and Change users flags    (flags are specified in mc_po(deop_flagchange))
#  6=Deop user and Notice user and Change users flags
#  7=Kick user and Change users flags
#  8=Kick user and Notice user and Change users flags
# default is 2, To turn the kick response off all together set this to 0, and 
# set deop_notice to ""
set mc_po(deop_reaction) 6

# Who do you really want to protect?  You can specify there flags below.  If you want
# to protect everyone that is op'd, set this to "".  If you only want to protect
# the masters (global|channel) then set it to "m|m".  You can set to what ever you like,
# but remember, it's "<global_flag>|<channel_flag>"
set mc_po(deop_protect) "o|o"

#mc_po(deop_notice) defines the message to be noticed to the user and/or the message
# to be displayed on a kick.  
set mc_po(deop_notice) "You just DE-OP'D an OP.  That is against the OP rules!  You have now lost your OP access."

# If a non exempt user deops an op, do you want reop that op? 
#  0=no
#  1=yes  - But only if that user is a registerd op (has +o in the userfile).
#  2=yes  - Will reop the deop'd user regardless if the user is registered or not.
set mc_po(deop_reverse) 1

#mc_po(deop_flagchange) will be where you set what flag changes to do
# upon reaction to a deop of an op.  Please specify the | character, for
# those that don't know what it is, it's <global>|<channel> flag system.
# If you just put in "-o" .. it's going to think that's global, so do 
# "-|-o" instead.
set mc_po(deop_flagchange) "-mto|-mto"

# Ok, let's say there not op'd, what flag'd users would you like to protect also?
# Please specify the | character, for those that don't know what it is, it's
# <global>|<channel> flag system.  If you just put in "o" .. it's going to think 
# that's global, so do "-|o" instead.
set mc_po(also_protect) "ov|ov"

# On any reaction that requires flag changes, the script will write a 
# comment in the users' record. What do you want he comment field to say?
set mc_po(comment) "%nick (hand: %hand) %type'd %victim in %chan \[%date@%time\]"

## MC SVS (Script Version Server) v1.2 ##
# Do you want the bot to connection to MC_8's SVS to see if there are newer versions
# of this script avilable?  It will only tell you -- It's up to you to get the newest
# version (I decided not to auto update the code, there may be new features in the
# newest script that may require your attention).
# 0=no/1=yes
set mc_po(svs:enabled) 1

# Once a day the script will check with the SVS -- this specifies when
# that should happen.  The setting should be the hour (military).
# examples:
#  set mc_po(svs:check) 0  ;#This is at Midnight
#  set mc_po(svs:check) 5  ;#This is at 5am
#  set mc_po(svs:check) 13  ;#This is at 1pm
#  set mc_po(svs:check) 23  ;#This is at 11pm
set mc_po(svs:check) 3

# Upon finding a newer version, who do you want to notify via note?
# Only the admin of the bot should really be worried about these notes,
# there the ones that keep everything up to par on the bots.
# Seperate each user with a " " (space).
set mc_po(svs:notify) "MC_8"

# Do you want even beta version notified to whomever you have set?  Or just
# stable releases of the script?
#  0 = Tell me about all version, even beta versions.
#  1 = Just tell me about new stable versions.
set mc_po(svs:stableonly) 0





###### Do not edit past this point (unless you know TCL) ######
set mc_po(version) 1.5
set mc_po(svs:script) "protectops 001005000000"
set mc_po(svs:server) "mc.purehype.net 8085"

if {$numversion < "1050000"} {
 putlog "Protect Ops $mc_po(version) by MC_8 is for eggdrop 1.5+ series only."
 putlog "Protect Ops $mc_po(version) will not work with eggdrop $version."
 putlog "Protect Ops $mc_po(version) not loaded."
 return 1
};setudef flag mc.protectops

proc mc:po:kick {nick uhost hand chan knick reason} {
 global mc_po botnick
 if {(![mc:po:inter:chanon $chan mc.protectops]) ||
     ($nick == "") || ((!$mc_po(bigtalker)) && (![isop $botnick $chan])) ||
     (![isop $knick $chan]) || (![matchattr [nick2hand $knick] $mc_po(also_protect)]) ||
     ($nick == $botnick) || ($nick == $knick) ||
     ([matchattr $hand $mc_po(exempt) $chan])} {return 0}
 if {((($mc_po(kick_protect) != "") && 
     ([matchattr [nick2hand $knick] $mc_po(kick_protect) $chan])) || 
     ($mc_po(kick_protect) == ""))} {
  mc:po:reaction $nick $uhost $hand $chan kick "$knick (handle: [nick2hand $knick])"
  foreach user [userlist $mc_po(note) $chan] {
   set msg [mc:pom:replace $mc_po(note_msg) "%botnick $botnick %to $user %type kick %nick $nick %uhost $uhost %hand $hand %chan $chan %victim {$knick (handle: [nick2hand $knick])} %reason {$reason}"]
   storenote ProtectOps $user $msg -1
  }
 }
}

proc mc:po:mode {nick uhost hand chan mode victim} {
 global mc_po botnick
 if {(![mc:po:inter:chanon $chan mc.protectops]) || ($nick == "") ||
     ($nick == $botnick) || ((!$mc_po(bigtalker)) && (![isop $botnick $chan])) ||
     ([matchattr $hand $mc_po(exempt) $chan])} {return 0}
 if {$mode == "+b"} {
  foreach user [split [mc:pom:findchanuser $victim $chan]] {
   if {$nick == $user} {continue}
   if {([isop $user $chan]) || ([matchattr [nick2hand $user] $mc_po(also_protect) $chan]) ||
       ((($mc_po(ban_protect) != "") && 
       ([matchattr [nick2hand $user] $mc_po(ban_protect) $chan])) || 
       ($mc_po(ban_protect) == ""))} {
    mc:po:reaction $nick $uhost $hand $chan ban "$victim (irc-nick: $user  handle: [nick2hand $user])"
    switch -- $mc_po(ban_reverse) {
     1 {if {[matchattr $user +o $chan]} {pushmode $chan -b $victim}}
     2 {pushmode $chan -b $victim}
    }
    foreach nuser [userlist $mc_po(note) $chan] {
     set msg [mc:pom:replace $mc_po(note_msg) "%botnick $botnick %to $nuser %type ban %nick $nick %uhost $uhost %hand $hand %chan $chan %victim {$victim (irc-nick: $user  handle: [nick2hand $user])} %reason {}"]
     storenote ProtectOps $nuser $msg -1
    } ; return 0
   }
  }
 }
 if {$mode == "-o"} {
  if {$nick == $victim} {return 0}
  if {([matchattr [nick2hand $victim] $mc_po(also_protect) $chan]) ||
      ((($mc_po(deop_protect) != "") &&
      ([matchattr [nick2hand $victim] $mc_po(deop_protect) $chan])) ||
      ($mc_po(deop_protect) == ""))} {
   mc:po:reaction $nick $uhost $hand $chan deop "$victim (handle: [nick2hand $victim])"
   switch -- $mc_po(deop_reverse) {
    1 {if {[matchattr $victim +o $chan]} {pushmode $chan +o $victim}}
    2 {pushmode $chan +o $victim}
   }
   foreach user [userlist $mc_po(note) $chan] {
    set msg [mc:pom:replace $mc_po(note_msg) "%botnick $botnick %to $user %type deop %nick $nick %uhost $uhost %hand $hand %chan $chan %victim {$victim (handle: [nick2hand $victim])} %reason {}"]
    storenote ProtectOps $user $msg -1
   } 
  }
 }
}

proc mc:po:reaction {nick uhost hand chan type victim} {
 global mc_po
 switch -- $mc_po(${type}_reaction) {
  0 {puthelp "NOTICE $nick :$mc_po(${type}_notice)"}
  1 {pushmode $chan -o $nick}
  3 {putserv "KICK $chan $nick :$mc_po(${type}_notice)"}
  4 {putserv "KICK $chan $nick :$mc_po(${type}_notice)" ; putserv "NOTICE $nick :$mc_po(${type}_notice)"}
  5 {
   pushmode $chan -o $nick
   if {$hand == "*"} {
    if {$mc_po(create_user)} {
     set hand $nick
     while {![adduser $hand [mc:pom:masktype $nick![getchanhost $nick $chan] 3]]} {
      set hand [string range $nick 0 6][rand 100]
     }
     chattr $hand $mc_po(${type}_flagchange) $chan
     setuser $hand COMMENT [mc:pom:replace $mc_po(comment) "%nick $nick %type $type %victim {$victim} %hand $hand %chan $chan %date {[strftime "%b %d, %Y"]} %time {[realtime]}"]
    } {return 0} 
   } {
    chattr $hand $mc_po(${type}_flagchange) $chan
    setuser $hand COMMENT [mc:pom:replace $mc_po(comment) "%nick $nick %type $type %victim {$victim} %hand $hand %chan $chan %date {[strftime "%b %d, %Y"]} %time {[realtime]}"]
   }
  }
  6 {
   pushmode $chan -o $nick ; puthelp "NOTICE $nick :$mc_po(${type}_notice)"
   if {$hand == "*"} {
    if {$mc_po(create_user)} {
     set hand $nick
     while {![adduser $hand [mc:pom:masktype $nick![getchanhost $nick $chan] 3]]} {
      set hand [string range $nick 0 6][rand 100]
     }
     chattr $hand $mc_po(${type}_flagchange) $chan
     setuser $hand COMMENT [mc:pom:replace $mc_po(comment) "%nick $nick %type $type %victim {$victim} %hand $hand %chan $chan %date {[strftime "%b %d, %Y"]} %time {[realtime]}"]
    } {return 0} 
   } {
    chattr $hand $mc_po(${type}_flagchange) $chan
    setuser $hand COMMENT [mc:pom:replace $mc_po(comment) "%nick $nick %type $type %victim {$victim} %hand $hand %chan $chan %date {[strftime "%b %d, %Y"]} %time {[realtime]}"]
   }
  }
  7 {
   putserv "KICK $chan $nick :$mc_po(${type}_notice)"
   if {$hand == "*"} {
    if {$mc_po(create_user)} {
     set hand $nick
     while {![adduser $hand [mc:pom:masktype $nick![getchanhost $nick $chan] 3]]} {
      set hand [string range $nick 0 6][rand 100]
     }
     chattr $hand $mc_po(${type}_flagchange) $chan
     setuser $hand COMMENT [mc:pom:replace $mc_po(comment) "%nick $nick %type $type %victim {$victim} %hand $hand %chan $chan %date {[strftime "%b %d, %Y"]} %time {[realtime]}"]
    } {return 0} 
   } {
    chattr $hand $mc_po(${type}_flagchange) $chan
    setuser $hand COMMENT [mc:pom:replace $mc_po(comment) "%nick $nick %type $type %victim {$victim} %hand $hand %chan $chan %date {[strftime "%b %d, %Y"]} %time {[realtime]}"]
   }
  }
  8 {
   putserv "KICK $chan $nick :$mc_po(${type}_notice)" ; putserv "NOTICE $nick :$mc_po(${type}_notice)"
   if {$hand == "*"} {
    if {$mc_po(create_user)} {
     set hand $nick
     while {![adduser $hand [mc:pom:masktype $nick![getchanhost $nick $chan] 3]]} {
      set hand [string range $nick 0 6][rand 100]
     }
     chattr $hand $mc_po(${type}_flagchange) $chan
     setuser $hand COMMENT [mc:pom:replace $mc_po(comment) "%nick $nick %type $type %victim {$victim} %hand $hand %chan $chan %date {[strftime "%b %d, %Y"]} %time {[realtime]}"]
    } {return 0} 
   } {
    chattr $hand $mc_po(${type}_flagchange) $chan
    setuser $hand COMMENT [mc:pom:replace $mc_po(comment) "%nick $nick %type $type %victim {$victim} %hand $hand %chan $chan %date {[strftime "%b %d, %Y"]} %time {[realtime]}"]
   }
  }
  default {pushmode $chan -o $nick ; puthelp "NOTICE $nick :$mc_po(${type}_notice)"}
 }
}

proc mc:pom:replace {string subs} {
 if {[llength $subs] == "1"} {set subs [lindex $subs 0]}
 for {set i 0} {[lindex $subs $i] != ""} {incr i 2} {
  regsub -all -- [lindex $subs $i] $string [lindex $subs [expr $i+1]] string
 } ; return $string
}

proc mc:pom:findchanuser {hostmask channel} {
 set hostmask [string tolower $hostmask]
 if {![validchan $channel]} {return -code error "no such channel record"} ; set buffer ""
 foreach user [chanlist $channel] {
  if {[string match $hostmask [string tolower $user![getchanhost $user $channel]]]} {
   set buffer "$buffer $user"
  }
 } ; return [join [split $buffer] " "]
}

if {[catch {realtime}]} {
 proc realtime {args} {
  switch -exact [lindex $args 0] {
   time {return [strftime "%H:%M"]}
   date {return [strftime "%d %b %Y"]}
   default {return [strftime "%l:%M %P"]}
  }
 }
}

proc mc:pom:masktype {uhost type} {
 if {![string match "*!*@*.*" $uhost]} {
  set nick [lindex [split $uhost "!"] 0] ; set uhost "$nick![getchanhost $nick]"
  if {$uhost == "$nick!"} {set type "return_nothing"}
 }
 switch -exact $type {
  0 {set ban "*[string range $uhost [string first ! $uhost] e]"}
  1 {set ban "*!*[string trimleft [string range $uhost [expr [string first ! $uhost]+1] e] "~"]"}
  2 {set ban "*!*[string range $uhost [string first @ $uhost] e]"}
  3 {
   set ident [string range $uhost [expr [string first ! $uhost]+1] [expr [string last @ $uhost]-1]]
   set ban "*!*[string trimleft $ident "~"][string range [maskhost $uhost] [string first @ [maskhost $uhost]] e]"
  }
  4 {set ban "*!*[string range [maskhost $uhost] [string last "@" [maskhost $uhost]] e]"}
  5 {set ban $uhost}
  6 {
   set nick [string range $uhost 0 [expr [string first "!" $uhost]-1]]
   set ident [string range $uhost [expr [string first "!" $uhost]+1] [expr [string last "@" $uhost]-1]]
   set ban "$nick!*[string trimleft $ident "~"][string range $uhost [string last "@" $uhost] e]"
  }
  7 {
   set nick [string range $uhost 0 [expr [string first "!" $uhost]-1]]
   set ban "$nick!*[string range $uhost [string last "@" $uhost] e]"
  }
  8 {
   set nick [string range $uhost 0 [expr [string first "!" $uhost]-1]]
   set ident [string range $uhost [expr [string first "!" $uhost]+1] [expr [string last "@" $uhost]-1]]
   set ban "$nick!*[string trimleft $ident "~"][string range [maskhost $uhost] [string last "@" [maskhost $uhost]] e]"
  }
  9 {
   set nick [string range $uhost 0 [expr [string first "!" $uhost]-1]]
   set ban "$nick!*[string range [maskhost $uhost] [string last "@" [maskhost $uhost]] e]"
  }
  10 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[mc:po:inter:findip [string range $host 1 e]] == "0"} {
    set host [mc:pom:replace $host "1 ? 2 ? 3 ? 4 ? 5 ? 6 ? 7 ? 8 ? 9 ? 0 ?"]
    set ident [string range $uhost [expr [string first "!" $uhost]+1] [expr [string last "@" $uhost]-1]]
    set ban "*!$ident$host"
   } {set ban [mc:pom:masktype $uhost 0]}
  }
  11 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[mc:po:inter:findip [string range $host 1 e]] == "0"} {
    set host [mc:pom:replace $host "1 ? 2 ? 3 ? 4 ? 5 ? 6 ? 7 ? 8 ? 9 ? 0 ?"]
    set ident [string range $uhost [expr [string first "!" $uhost]+1] [expr [string last "@" $uhost]-1]]
    set ban "*!*[string trimleft $ident "~"]$host"
   } {set ban [mc:pom:masktype $uhost 1]}
  }
  12 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[mc:po:inter:findip [string range $host 1 e]] == "0"} {
    set host [mc:pom:replace $host "1 ? 2 ? 3 ? 4 ? 5 ? 6 ? 7 ? 8 ? 9 ? 0 ?"]
    set ban "*!*$host"
   } {set ban [mc:pom:masktype $uhost 2]}
  }
  13 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[mc:po:inter:findip [string range $host 1 e]] == "0"} {set ban [mc:pom:masktype $uhost 11]} {set ban [mc:pom:masktype $uhost 3]}
  }
  14 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[mc:po:inter:findip [string range $host 1 e]] == "0"} {set ban [mc:pom:masktype $uhost 12]} {set ban [mc:pom:masktype $uhost 4]}
  }
  15 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[mc:po:inter:findip [string range $host 1 e]] == "0"} {
    set host [mc:pom:replace $host "1 ? 2 ? 3 ? 4 ? 5 ? 6 ? 7 ? 8 ? 9 ? 0 ?"]
    set rest [string range $uhost 0 [expr [string last "@" $uhost]-1]]
    set ban $rest$host
   } {set ban [mc:pom:masktype $uhost 5]}
  }
  16 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[mc:po:inter:findip [string range $host 1 e]] == "0"} {
    set host [mc:pom:replace $host "1 ? 2 ? 3 ? 4 ? 5 ? 6 ? 7 ? 8 ? 9 ? 0 ?"]
    set rest "[string range $uhost 0 [expr [string first "!" $uhost]-1]]!*[string trimleft [string range $uhost [expr [string first "!" $uhost]+1] [expr [string last "@" $uhost]-1]] "~"]"
    set ban $rest$host
   } {set ban [mc:pom:masktype $uhost 6]}
  }
  17 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[mc:po:inter:findip [string range $host 1 e]] == "0"} {
    set host [mc:pom:replace $host "1 ? 2 ? 3 ? 4 ? 5 ? 6 ? 7 ? 8 ? 9 ? 0 ?"]
    set rest "[string range $uhost 0 [expr [string first "!" $uhost]-1]]!*"
    set ban $rest$host 
   } {set ban [mc:pom:masktype $uhost 7]}
  }
  18 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[mc:po:inter:findip [string range $host 1 e]] == "0"} {set ban [mc:pom:masktype $uhost 16]} {set ban [mc:pom:masktype $uhost 8]}
  }
  19 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[mc:po:inter:findip [string range $host 1 e]] == "0"} {set ban [mc:pom:masktype $uhost 17]} {set ban [mc:pom:masktype $uhost 9]}
  }
  return_nothing {set ban ""}
  default {set ban "*!*[string range $uhost [string first "@" $uhost] e]"}
 }
 set _nick [lindex [split $ban !] 0]
 set _ident [string range $ban [expr [string first ! $ban]+1] [expr [string last @ $ban]-1]]
 set _host [string range $ban [expr [string last @ $ban]+1] e]
 if {$_ident != [set temp [string range $_ident [expr [string length $_ident]-9] e]]} {
  set _ident *[string trimleft $temp *]
 }
 if {$_host != [set temp [string range $_host [expr [string length $_host]-63] e]]} {
  set _host *[string trimleft $temp *]
 } ; return $_nick!$_ident@$_host
}

proc mc:po:inter:findip {args} {
 catch {unset mc_found_ip}
 if {![string match *.*.*.* $args]} {return 0}
 foreach arg $args {
  if {[string match *.*.*.* $arg]} {
   set mc_testa [split $arg "."] ; set i 0
   while {[llength $mc_testa] != $i} {
    set mc_test [lrange $mc_testa $i end]
    if {[string length [lindex $mc_test 1]]<4 && [string length [lindex $mc_test 2]]<4} {
     if {[lindex $mc_test 1] < 256 && [lindex $mc_test 2] < 256 && [lindex $mc_test 1] >= 0 && [lindex $mc_test 2] >= 0} {
      set first "abcdefghi"
      if {[string index [lindex $mc_test 0] [expr [string length [lindex $mc_test 0]] - 1]] <= 9 && [string index [lindex $mc_test 0] [expr [string length [lindex $mc_test 0]] - 1]] >= 0} {
       set first [string range [lindex $mc_test 0] [expr [string length [lindex $mc_test 0]] - 1] end]
       if {[string index [lindex $mc_test 0] [expr [string length [lindex $mc_test 0]] - 2]] <= 9 && [string index [lindex $mc_test 0] [expr [string length [lindex $mc_test 0]] - 2]] >= 0} {
        set first [string range [lindex $mc_test 0] [expr [string length [lindex $mc_test 0]] - 2] end]
        if {[string index [lindex $mc_test 0] [expr [string length [lindex $mc_test 0]] - 3]] <= 9 && [string index [lindex $mc_test 0] [expr [string length [lindex $mc_test 0]] - 3]] >= 0} {
         set first [string range [lindex $mc_test 0] [expr [string length [lindex $mc_test 0]] - 3] end]
        }
       }
      }
      set second [lindex $mc_test 1] ; set third [lindex $mc_test 2] ; set fourth "abcdefghi"
      if {[string index [lindex $mc_test 3] 0] <= 9 && [string index [lindex $mc_test 3] 0] >= 0} {
       set fourth [string index [lindex $mc_test 3] 0]
       if {[string index [lindex $mc_test 3] 1] <= 9 && [string index [lindex $mc_test 3] 1] >= 0} {
        set fourth $fourth[string index [lindex $mc_test 3] 1]
        if {[string index [lindex $mc_test 3] 2] <= 9 && [string index [lindex $mc_test 3] 2] >= 0} {
         set fourth $fourth[string index [lindex $mc_test 3] 2]
        }
       }
      }
      if {($first < 256) && ($second < 256) && ($third < 256) &&
          ($fourth < 256) && ($first > 0) && ($second > 0) &&
          ($third > 0) && ($fourth > 0) && ([string index $first 0] > 0) &&
          ([string index $second 0] > 0) && ([string index $third 0] > 0) &&
          ([string index $fourth 0] > 0)} {
       if {[info exists mc_found_ip]} {
        set mc_found_ip "$mc_found_ip $first.$second.$third.$fourth"
       } {set mc_found_ip $first.$second.$third.$fourth}
      }
     }
    } ; incr i +1
   }
  }
 } ; if {[info exists mc_found_ip]} {return $mc_found_ip} {return 0}
}

bind kick - * mc:po:kick 
bind mode - * mc:po:mode

proc mc:po:inter:chanon {chan flag} {
 set chan [string tolower $chan]
 foreach info [channel info $chan] {
  if {[string tolower [string range $info 1 e]] == [string tolower $flag]} {
   if {[string index $info 0] == "-"} {return 0} {return 1}
  }
 };return 0
}

if {$mc_po(svs:enabled)} {
 if {($mc_po(svs:check) > "23") || ($mc_po(svs:check) < "0")} {set mc_po(svs:check) 00}
 if {[string length $mc_po(svs:check)] == "1"} {set mc_po(svs:check) 0$mc_po(svs:check)}
 if {$mc_po(svs:stableonly)} {
  set mc_po(svs:script) [string range $mc_po(svs:script) 0 [expr [string length $mc_po(svs:script)]-4]]999
 }
 catch {unbind time - "00 $mc_po(svs:oldcheck) * * *" mc:po:svs:time}
 set mc_po(svs:oldcheck) $mc_po(svs:check)
 bind time - "00 $mc_po(svs:check) * * *" mc:po:svs:time
 proc mc:po:svs:time {min hour day month year} {
  global mc_po
  catch {control [connect [lindex $mc_po(svs:server) 0] [lindex $mc_po(svs:server) 1]] mc:po:svs:interface}
 }
}
proc mc:po:svs:interface {idx args} {
 global mc_po;set args [join $args]
 switch -- [lindex $args 0] {
  "" {return 1}
  000 {putdcc $idx q}
  002 {putdcc $idx [lindex $mc_po(svs:script) 0]}
  003 {
   set args [lrange $args 1 e]
   if {[lindex $args 0] != [lindex $mc_po(svs:script) 0]} {return 0}
   putdcc $idx q
   if {[lindex $args 1] > [lindex $mc_po(svs:script) 1]} {
    set note [mc:po:svs:replace [lindex $args 7] "%0 {[lindex $args 0]} %1 {[lindex $args 1]} %2 {[lindex $args 2]}"]
    set note [mc:po:svs:replace $note "%3 {[lindex $args 3]} %4 {[lindex $args 4]} %5 {[lindex $args 5]}"]
    set note [mc:po:svs:replace $note "%6 {[lindex $args 6]} %8 {[lindex $args 8]} %version {$mc_po(version)}"]
    set note [mc:po:svs:replace $note "%9 {[lindex $args 9]} %10 {[lindex $args 10]} %11 {[lindex $args 11]}"]
    set note [mc:po:svs:replace $note "%12 {[lindex $args 12]} %13 {[lindex $args 13]} %14 {[lindex $args 14]}"]
    set note [mc:po:svs:replace $note "%15 {[lindex $args 15]} %16 {[lindex $args 16]} %17 {[lindex $args 17]}"]
    set note [mc:po:svs:replace $note "%18 {[lindex $args 18]} %19 {[lindex $args 19]} %20 {[lindex $args 20]}"]
    foreach notify [join [split $mc_po(svs:notify) ",;"]] {
     set outnote [mc:po:svs:replace $note "%nick {$notify}"]
     if {[string match "*$outnote*" "[notes $notify -[notes $notify]]"]} {
      set cont 0
      foreach unote [notes $notify -[notes $notify]] {
       if {$outnote == [lindex $unote 2]} {set cont 1;break}
      };if {$cont} {continue}
     }
     switch -- [sendnote SVS $notify $outnote] {
      0 {putlog "MC SVS for [lindex $mc_po(svs:script) 0] had some errors updating $notify on current version of script; unknown reason!"}
      3 {putlog "MC SVS for [lindex $mc_po(svs:script) 0] had some errors updating $notify on current version of script; notebox too full!"}
     }
    }
   }
  }
 };return 0
}
proc mc:po:svs:replace {string subs} {
 if {[llength $subs] == "1"} {set subs [lindex $subs 0]}
 for {set i 0} {[lindex $subs $i] != ""} {incr i 2} {
  regsub -all -- [lindex $subs $i] $string [lindex $subs [expr $i+1]] string
 } ; return $string
}

putlog "Protect Ops $mc_po(version) by MC_8 loaded."