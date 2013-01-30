# Work with colors and attributes
# Make sure you have env variable set: TERM=xterm-256color
# Don't mess with first 16 colors
# Press ESC to exit

ENV['TERM'] = 'xterm-256color' # This may need tweaking for other *nixes
ESC = 27

require 'curses' # You may want to include Curses in a class to wrap it


Curses.init_screen
Curses.ESCDELAY = 50
Curses.start_color
Curses.raw
Curses.noecho

main = Curses.stdscr
main.clear
main.keypad true

main << "Colors: #{Curses.colors}\n"
main << "Color pairs: #{Curses.color_pairs}\n\n"

if Curses.colors < 256
  main << "Available colors less than 256. Colors may not display correctly\n"
  main << "Ensure you have installed ncurses-term and that $TERM returns something like xterm-256color\n"
  main << "\n"
end

def set_color index, hex
  r, g, b = [hex[0..1], hex[2..3], hex[4..5]].map do |hex_component|
    (hex_component.to_i(16) / 255.0 * 1000).to_i
  end
  Curses.init_color(index, r, g, b)
  Curses.stdscr << "Set color #{index} to #{r}, #{g}, #{b}. "
  Curses.stdscr << "Reported colors are #{Curses.color_content(index).inspect}\n"
end

set_color(20, '2b2b2b')
set_color(21, '000000')
set_color(22, '4b4b4b')
set_color(23, '555555')
set_color(24, '005500')

Curses.init_pair(21, 20, 20)
Curses.init_pair(22, 22, 21)
Curses.init_pair(23, 23, 0)
Curses.init_pair(24, 24, 0)

Curses.attron(Curses.color_pair(22)) { main << "Should be gray on black\n" }
Curses.attron(Curses.color_pair(23)) { main << "Dark gray\n" }
Curses.attron(Curses.color_pair(24)) { main << "Should be green\n" }
Curses.attron(Curses.color_pair(24) | Curses::A_BOLD) { main << "Should be bold green\n" }
Curses.attron(Curses.color_pair(0) | Curses::A_NORMAL) { main << "Should be normal text, and below alternate charset\n" }
Curses.attron(Curses::A_ALTCHARSET) { main << "k,sdfjhsdfkjsdhfjkhsd\n" }
Curses.attron(Curses.color_pair(0) | Curses::A_REVERSE) { main << "Should be reversed\n" }
Curses.attron(Curses.color_pair(0) | Curses::A_UNDERLINE) { main << "Should be underlined\n" }

main << "Press ESC to exit\n"
while Curses.getch != ESC
end

Curses.close_screen

