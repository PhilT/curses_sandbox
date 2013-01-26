# Curses does not support viewport scrolling (Although ncurses may have pads support which does)
# It does however allow scrolling of what is on screen. So we can fill in the blank line left at
# the top or bottom after we have scrolled. Note that scrl() does not move the cursor. In other words,
# If the cursor is on line 10 and we scrl(1) the cursor will still be on line 10 over whatever was
# previously on line 11.
# Press ESC to exit

require 'curses'

Curses.init_screen
Curses.ESCDELAY = 50
@win = Curses.stdscr
@win.clear
Curses.raw
@win.idlok true
@win.scrollok true
@win.keypad true
Curses.noecho
Curses.curs_set 0

LEFT = 260
RIGHT = 261
UP = 259
DOWN = 258
ESC = 27


def write y, line
  @win.setpos y, 0
  @win.addstr "%3s" % line
end

write 0, "       Press ESC to exit\n\n"

Curses.lines.times do |line|
  write line, line
end

@scroll_position = 0

loop do
  c = @win.getch
  if c.ord == UP && @scroll_position > 0
    @scroll_position -= 1
    @win.scrl(-1)
    write 0, @scroll_position
    @win.refresh
  elsif c.ord == DOWN && @scroll_position < 100 - @win.maxy
    @scroll_position += 1
    @win.scrl(1)
    write @win.maxy - 1, @scroll_position + @win.maxy - 1
    @win.refresh
  elsif c.ord == ESC
    break
  end
end

