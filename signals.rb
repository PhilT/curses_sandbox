# Not strictly Curses but code should handle signals to correctly reset the screen

require 'curses'

$exiting = false

def on_signal(signal_id)
  unless $exiting
    $exiting = true
    Curses.close_screen
    puts "Handling signal. Exiting with code #{signal_id}. Press ENTER"
    gets
    exit signal_id
  end
end

program_errors = %w(FPE ILL SEGV BUS ABRT IOT SYS XCPU XFSZ)
exit_signals = %w(HUP INT QUIT TERM KILL TRAP)
alarms = %w(ALRM VTALRM PROF)
user_defined = %w(USR1 USR2)

all_signals = program_errors + exit_signals + alarms + user_defined
all_signals.each do |signal|
  trap(signal) { |signal_id| on_signal(signal_id) }
end

Curses.init_screen
win = Curses.stdscr
win.addstr 'Press CTRL+C'
Curses.getch
Curses.close_screen
puts 'Normal exit. Press ENTER'

gets
