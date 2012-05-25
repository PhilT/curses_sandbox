# Work with colors and attributes
# Make sure you have env variable set: TERM=xterm-256color
# Don't mess with first 16 colors

require 'curses'
include Curses

Curses.init_screen
Curses.start_color
win = Curses.stdscr
win.clear
Curses.raw
win.keypad true
Curses.noecho

win << "Colors: #{Curses.colors}\n"
win << "Color pairs: #{Curses.color_pairs}\n\n"

# Setup default 8 color palette
if Curses.has_colors?
  init_pair(COLOR_BLACK, COLOR_BLACK, COLOR_BLACK);
  init_pair(COLOR_GREEN, COLOR_GREEN, COLOR_BLACK);
  init_pair(COLOR_RED, COLOR_RED, COLOR_BLACK);
  init_pair(COLOR_CYAN, COLOR_CYAN, COLOR_BLACK);
  init_pair(COLOR_WHITE, COLOR_WHITE, COLOR_BLACK);
  init_pair(COLOR_MAGENTA, COLOR_MAGENTA, COLOR_BLACK);
  init_pair(COLOR_BLUE, COLOR_BLUE, COLOR_BLACK);
  init_pair(COLOR_YELLOW, COLOR_YELLOW, COLOR_BLACK);
end

if Curses.colors < 256
  win << "Available colors less than 256. Colors may not display correctly\n"
  win << "Ensure you have installed ncurses-term and that $TERM returns something like xterm-256color\n"
end

def set_color index, hex
  hex.sub!('#', '')
  r, g, b = hex[0..1], hex[2..3], hex[4..5]
  r, g, b = (r.to_i(16) / 255.0 * 1000).to_i, (g.to_i(16) / 255.0 * 1000).to_i, (b.to_i(16) / 255.0 * 1000).to_i
  Curses.init_color(index, r, g, b)
  Curses.refresh
  stdscr << "Set color #{index} to #{r}, #{g}, #{b}. Reported colors are #{Curses.color_content(index).inspect}\n"
end

set_color(0, '#332811')

set_color(20, "#2b2b2b")
set_color(21, "#000000")
set_color(22, "#4b4b4b")
set_color(23, "#555555")
set_color(24, "#005500")

init_pair(21, 20, 20)
init_pair(22, 22, 21)
init_pair(23, 23, 0)
init_pair(24, 24, 0)

bkgd(color_pair(11))

attron(color_pair(22)) { win << "Should be gray on black\n" }
attron(color_pair(23)) { win << "Dark gray\n" }
attron(color_pair(24)) { win << "Should be green\n" }
attron(color_pair(24) | A_BOLD) { win << "Should be bold green\n" }
attron(color_pair(24) | A_REVERSE) { win << "Should be reversed green\n" }

win << "Press any key to quit\n"

win.getch
clear
close_screen

