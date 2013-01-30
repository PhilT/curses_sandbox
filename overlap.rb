# Emulate overlapping windows by redrawing an area that was
# previously covered by a window.
# Ruby curses does not have `touchwin` support so we must
# save an area before overwriting it so it can be restored

LOREM = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
TITLE = 20
NORMAL = 21
CURRENT = 22
ESC = 27

require 'curses'

Curses.init_screen
Curses.start_color
Curses.ESCDELAY = 50
Curses.raw
Curses.noecho
Curses.curs_set 0

height = Curses.lines
width = Curses.cols

y_center = height / 2
x_center = width / 2

module Curses
  class Window
    def write x, y, text
      setpos y, x
      addstr text
    end
  end
end

def set_color index, hex
  r, g, b = [hex[0..1], hex[2..3], hex[4..5]].map do |hex_component|
    (hex_component.to_i(16) / 255.0 * 1000).to_i
  end
  Curses.init_color(index, r, g, b)
end

set_color(0, '272822') # Sets the background color
set_color(20, 'f92672')
set_color(21, '002255')
set_color(22, 'dddddd')
set_color(23, '3c3d37')

Curses.init_pair(TITLE, 20, 0)
Curses.init_pair(NORMAL, 22, 0)
Curses.init_pair(CURRENT, 22, 23)
Curses.clear
Curses.refresh

main = Curses::Window.new(height, width, 0, 0)
main << LOREM << ' '
main.attron(Curses.color_pair(TITLE)) { main << LOREM }
main.refresh

main.getch

sub = main.subwin(height / 3, width / 3, 2, 2)
win_size = (height / 3 * width / 3)
rect = ''
sub.color_set(CURRENT)

# Need a way to store the color setting as well
win_size.times { rect << sub.inch; sub << ' ' }

sub.refresh

sub.getch

sub.color_set(NORMAL)
sub.setpos 0, 0
sub << rect

sub.close

main.getch

main.close
