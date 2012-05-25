# Curses does not support viewport scrolling (Although ncurses may have pads support which does)
# It does however allow scrolling of what is on screen. So we can fill in the blank line left at
# the top or bottom after we have scrolled. Note that scrl() does not move the cursor. In other words,
# If the cursor is on line 10 and we scrl(1) the cursor will still be on line 10 over whatever was
# previously on line 11.

require 'curses'

Curses.init_screen
Curses.start_color
@win = Curses.stdscr
@win.clear
Curses.raw
@win.idlok true
@win.scrollok true
@win.keypad true
Curses.noecho

LEFT = 260
RIGHT = 261
UP = 259
DOWN = 258
CTRL_Q = 17

def write y, line
  @win.setpos y, 0
  @win.addstr "%3s" % line
end

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
  elsif c.ord == CTRL_Q
    break
  end
end

