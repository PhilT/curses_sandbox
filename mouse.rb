# Attempt to read mouse events such as location and buttons pressed. Works well with first three
# buttons but has trouble with scroll wheel and other buttons
# Also seems to work okay with clicked and pressed events but not released
# Press ESC to exit

require "curses"

Curses.init_screen
Curses.ESCDELAY = 50
Curses.noecho
Curses.stdscr.keypad(true)
Curses.stdscr.scrollok true
Curses.raw

ESC = 27

Curses.stdscr << "Press ESC to exit\n\n"


def bstate m
  (1..4).map do | button |
    button = "BUTTON#{button}_"
    states = {
      eval("Curses::#{button}CLICKED") => "#{button}CLICKED",
      eval("Curses::#{button}DOUBLE_CLICKED") => "#{button}DOUBLE_CLICKED",
      eval("Curses::#{button}PRESSED") => "#{button}PRESSED",
      eval("Curses::#{button}RELEASED") => "#{button}RELEASED",
      eval("Curses::#{button}TRIPLE_CLICKED") => "#{button}TRIPLE_CLICKED"
    }

    states.map{|k, v| m.bstate & k != 0 ? v : nil}
  end.flatten.compact.join(', ')
end


begin
  Curses.mousemask(Curses::ALL_MOUSE_EVENTS)
  Curses.refresh
  while( true )
    c = Curses.getch
    case c
    when Curses::KEY_MOUSE
      m = Curses.getmouse
      Curses.stdscr << "x=#{m.x}, y=#{m.y}, buttons (#{'0x%x' % m.bstate}): #{bstate(m)}\n"
    end
    break if c.ord == ESC
  end
  Curses.refresh
ensure
  Curses.close_screen
end

