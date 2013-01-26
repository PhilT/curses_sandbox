# Gets and stores codes for special keys as Curses does not list all combinations
# Creates a keys.rb file that contains the resultant constants
# These can be used when in Curses.raw mode
# Some terminals (e.g. terminator) intercept some key codes (e.g. ALT keys) so
# best to run this in xterm (or remove ALT key requests).

# Keys not included have found not to be recognised by Curses.
# Press ESC to abort (does not save file)

require 'curses'

Curses.init_screen
Curses.ESCDELAY = 50
win = Curses.stdscr
win.clear
Curses.raw
win.idlok true
win.scrollok true
win.keypad true
Curses.noecho

Curses.stdscr << "Press ESC to exit\n\n"

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
ENTER
)

def key_name key
  key + %w(HOME END).include?(key) ? '_KEY' : ''
end

contents = []

contents <<  "# GENERATED FROM keycodes.rb"
contents << "module Key"
contents << '  ESC = 27'
keys.each do |key|
  win.addstr("#{key} = ")
  code = win.getch.ord
  exit if code == 27
  contents << "  #{key_name(key)} = #{code}"
  win.addstr("#{code}\n")
end

('A'..'Z').each do |letter|
  contents << "  CTRL_#{letter} = #{letter.ord - 'A'.ord + 1}"
end
contents << "end"

File.open('keys.rb', 'w') do |f|
  f.puts contents.join("\n") + "\n"
end

Curses.close_screen

puts 'Keycodes saved to keys.rb. Press ENTER.'
gets
