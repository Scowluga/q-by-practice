# runs kdb+ real time demo
# assumes install in default location, otherwise change Q, T
# Terminal|Preferences|New tabs open with must be set to "Default Settings"

global Q, R, T

set R to ""
tell application "Finder" to if exists "/opt/local/bin/rlwrap" as POSIX file then set R to "rlwrap "
set Q to R & "~/q/m64/q"
set T to "~/q/q-by-practice/tickerplant/"

on newcx(name, port)
	newproc(name, "nodes/cx.q " & name & " -p " & (port as text))
	delay (1.0)
end newcx

on newproc(name, cmd)
	tell application "System Events" to tell process "Terminal.app" to keystroke "t" using command down
	tell application "Terminal" to do script "cd " & T & "; " & Q & " " & T & cmd in front window
	setname(name)
end newproc

on setname(name)
	tell front window of application "Terminal"
		tell selected tab
			set title displays device name to false
			set title displays file name to false
			set title displays shell path to false
			set title displays window size to false
			set title displays custom title to true
			set custom title to name
		end tell
	end tell
end setname

tell application "Terminal"
	activate
	my newproc("tick", "tick.q ./out/logs -p 5010")
	delay (3.0)
	my newproc("rdb", "nodes/rdb.q -p 5011")
	delay (3.0)
	my newproc("hdb", "nodes/hdb.q -p 5012")
	delay (2.0)
	my newcx("hlcv", 5014)
	my newcx("last", 5015)
	my newcx("tq", 5016)
	my newcx("vwap", 5017)
	my newcx("show", 0)
	my newproc("feed", "feed.q -p 5009")
	set selected of tab 1 of front window to true
	set number of rows of front window to 50
	set number of columns of front window to 150
end tell
