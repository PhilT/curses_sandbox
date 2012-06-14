# Not strictly Curses related but code should handle signals

def onsig(sig)
  Curses.close_screen
  exit sig
end

for i in 1 .. 15  # SIGHUP .. SIGTERM
  if trap(i, "SIG_IGN") != 0 then  # 0 for SIG_IGN
    trap(i) {|sig| onsig(sig) }
  end
end

Curses.init_screen

Curses.getch
