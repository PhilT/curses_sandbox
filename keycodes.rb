# Gets and stores codes for special keys as Curses does not list all combinations
# Creates a keys.rb file that contains the resultant constants
# These can be used when in Curses.raw mode
# Some terminals (e.g. terminator) intercept some key codes (e.g. ALT keys) so
# best to run this in xterm (or remove ALT key requests).

# Keys not included have found not to be recognised by Curses.

require 'curses'

Curses.init_screen
Curses.start_color
win = Curses.stdscr
win.clear
Curses.raw
win.idlok true
win.scrollok true
win.keypad true
Curses.noecho

keys = %w(
LEFT
RIGHT
UP
DOWN

CTRL_LEFT
CTRL_RIGHT
CTRL_UP
CTRL_DOWN
ALT_LEFT
ALT_RIGHT
ALT_UP
ALT_DOWN
SHIFT_LEFT
SHIFT_RIGHT
SHIFT_UP
SHIFT_DOWN
CTRL_SHIFT_LEFT
CTRL_SHIFT_RIGHT
CTRL_SHIFT_UP
CTRL_SHIFT_DOWN

HOME
END
PAGE_UP
PAGE_DOWN
CTRL_HOME
CTRL_END
CTRL_PAGE_UP
CTRL_PAGE_DOWN

INSERT
DELETE
BACKSPACE
CTRL_DELETE

TAB
ESC
)

File.open('keys.rb', 'w') do |f|
  f.puts "# GENERATED FROM keycodes.rb"
  f.puts "module Key"
  keys.each do |key|
    win.addstr("#{key} = ")
    code = win.getch.ord
    f.puts "  #{key} = #{code}"
    win.addstr("#{code}\n")
  end

  ('A'..'Z').each do |letter|
    f.puts "  CTRL_#{letter} = #{letter.ord - 'A'.ord + 1}"
  end
  f.puts "end"
end

