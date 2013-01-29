# Display 4 windows
# The key things here are the window refresh calls and the getch on the final window.
# If the main Curses.getch is called the other windows are not updated.
# If refresh is not called on each window only the final window is shown (the one with the getch)
# Another trick here is the use of Curses::A_ALTCHARSET to get the proper lines in the `box` call

require 'curses'

Curses.init_screen
Curses.start_color
Curses.ESCDELAY = 50
main = Curses.stdscr
main.clear
Curses.raw
main.keypad true
Curses.noecho
Curses.curs_set 0

ESC = 27

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

windows = [
  [1, 0, 0, x_center, y_center],
  [2, x_center + 1, 0, width - x_center - 1, y_center],
  [3, 0, y_center, x_center, height - y_center],
  [4, x_center + 1, y_center, width - x_center - 1, height - y_center]
].map do |n, x, y, w, h|
  panel = main.subwin(h, w, y, x)
  panel.attron(Curses::A_ALTCHARSET) { panel.box('x', 'q') }
  panel.write(1, 1, "Window #{n}")
  panel.write(1, 2, "#{x}, #{y}, #{w}x#{h}")
  panel.noutrefresh
  panel
end

window = main.subwin(height - 8, 80, 3, 20)
window.clear
window.attron(Curses::A_ALTCHARSET) { window.box('x', 'q') }
window.write(2, 2, 'Window 5')


windows.last.write(50, 5, "Press ESC to exit")
main.noutrefresh

Curses.doupdate

while main.getch != ESC
end

Curses.close_screen
