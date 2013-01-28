# Work with colors and attributes
# Make sure you have env variable set: TERM=xterm-256color
# Don't mess with first 16 colors
# Press ESC to exit

ENV['TERM'] = 'xterm-256color' # This may need tweaking for other *nixes

require 'curses' # You may want to include Curses in a class to wrap it

ESC = 27

Curses.init_screen
Curses.ESCDELAY = 50
Curses.start_color
win = Curses.stdscr
win.clear
Curses.raw
win.keypad true
Curses.noecho

win << "Colors: #{Curses.colors}\n"
win << "Color pairs: #{Curses.color_pairs}\n\n"

if Curses.colors < 256
  win << "Available colors less than 256. Colors may not display correctly\n"
  win << "Ensure you have installed ncurses-term and that $TERM returns something like xterm-256color\n"
  win << "\n"
end

def set_color index, hex
  hex.sub!('#', '')
  r, g, b = hex[0..1], hex[2..3], hex[4..5]
  r, g, b = (r.to_i(16) / 255.0 * 1000).to_i, (g.to_i(16) / 255.0 * 1000).to_i, (b.to_i(16) / 255.0 * 1000).to_i
  Curses.init_color(index, r, g, b)
  Curses.refresh
  Curses.stdscr << "Set color #{index} to #{r}, #{g}, #{b}. Reported colors are #{Curses.color_content(index).inspect}\n"
end

set_color(0, '#332811')

set_color(20, "#2b2b2b")
set_color(21, "#000000")
set_color(22, "#4b4b4b")
set_color(23, "#555555")
set_color(24, "#005500")

Curses.init_pair(21, 20, 20)
Curses.init_pair(22, 22, 21)
Curses.init_pair(23, 23, 0)
Curses.init_pair(24, 24, 0)

Curses.bkgd(Curses.color_pair(11))

Curses.attron(Curses.color_pair(22)) { win << "Should be gray on black\n" }
Curses.attron(Curses.color_pair(23)) { win << "Dark gray\n" }
Curses.attron(Curses.color_pair(24)) { win << "Should be green\n" }
Curses.attron(Curses.color_pair(24) | Curses::A_BOLD) { win << "Should be bold green\n" }
Curses.attron(Curses.color_pair(0) | Curses::A_NORMAL) { win << "Should be normal text, and below alternate charset\n" }
Curses.attron(Curses::A_ALTCHARSET) { win << "k,sdfjhsdfkjsdhfjkhsd\n" }
Curses.attron(Curses.color_pair(0) | Curses::A_REVERSE) { win << "Should be reversed\n" }
Curses.attron(Curses.color_pair(0) | Curses::A_UNDERLINE) { win << "Should be underlined\n" }

win << "Press ESC to exit\n"
while Curses.getch != ESC
end

Curses.close_screen

