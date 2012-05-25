# Display 4 windows
# The key things here are the window refresh calls and the getch on the final window.
# If the main Curses.getch is called the other windows are not updated.
# If refresh is not called on each window only the final window is shown (the one with the getch)

require 'curses'
include Curses

Curses.init_screen
Curses.start_color
win = Curses.stdscr
win.clear
Curses.raw
win.keypad true
Curses.noecho

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

[
  [0, 0, x_center, y_center],
  [x_center + 1, 0, width - x_center - 1, y_center],
  [0, y_center, x_center, height - y_center],
  [x_center + 1, y_center, width - x_center - 1, height - y_center]
].each do |x, y, w, h|
  @w = Curses::Window.new(h, w, y, x)
  @w.box("|", "-")
  @w.write(2, 2, "x: #{x}")
  @w.write(2, 3, "y: #{y}")
  @w.write(2, 4, "width: #{w}")
  @w.write(2, 5, "height: #{h}")
  @w.refresh
end

@w.getch

Curses.close_screen

