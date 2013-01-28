# Display 4 windows
# The key things here are the window refresh calls and the getch on the final window.
# If the main Curses.getch is called the other windows are not updated.
# If refresh is not called on each window only the final window is shown (the one with the getch)
# Another trick here is the use of Curses::A_ALTCHARSET to get the proper lines in the `box` call

ENV['TERM'] = 'xterm-256color'

require 'curses'

Curses.init_screen
Curses.start_color
Curses.ESCDELAY = 50
win = Curses.stdscr
win.clear
Curses.raw
win.keypad true
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

[
  [0, 0, x_center, y_center],
  [x_center + 1, 0, width - x_center - 1, y_center],
  [0, y_center, x_center, height - y_center],
  [x_center + 1, y_center, width - x_center - 1, height - y_center]
].each do |x, y, w, h|
  @w = Curses::Window.new(h, w, y, x)
  @w.attron(Curses::A_ALTCHARSET) { @w.box('x', 'q') }
  @w.write(2, 2, "x: #{x}")
  @w.write(2, 3, "y: #{y}")
  @w.write(2, 4, "width: #{w}")
  @w.write(2, 5, "height: #{h}")
  @w.refresh
  @window_height = h
end

@w.write(2, @window_height - 2, "Press ESC to exit")

while @w.getch != ESC
end

Curses.close_screen

