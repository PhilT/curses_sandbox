# Attempt to read mouse event such as location and buttons pressed. Works well with first three
# buttons but has trouble with scroll wheel and other buttons
# Also seems to work okay with clicked and pressed events but not released
# CTRL+C to quit

require "curses"
include Curses

init_screen
noecho
stdscr.keypad(true)
stdscr.scrollok true
Curses.raw

CTRL_C = 3


def bstate m
  (1..4).map do | button |
    button = "BUTTON#{button}_"
    states = {
      eval("#{button}CLICKED") => "#{button}CLICKED",
      eval("#{button}DOUBLE_CLICKED") => "#{button}DOUBLE_CLICKED",
      eval("#{button}PRESSED") => "#{button}PRESSED",
      eval("#{button}RELEASED") => "#{button}RELEASED",
      eval("#{button}TRIPLE_CLICKED") => "#{button}TRIPLE_CLICKED"
    }

    states.map{|k, v| m.bstate & k != 0 ? v : nil}
  end.flatten.compact.join(', ')
end


begin
  mousemask(ALL_MOUSE_EVENTS)
  refresh
  while( true )
    c = getch
    case c
    when KEY_MOUSE
      m = getmouse
      stdscr << "x=#{m.x}, y=#{m.y}, buttons (#{'0x%x' % m.bstate}): #{bstate(m)}\n"
    end
    break if c.ord == CTRL_C
  end
  refresh
ensure
  close_screen
end

