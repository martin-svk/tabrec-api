# More will be defined later
EVENTS = %w(TAB_OPEN TAB_CLOSE TAB_RELOAD)
DESCS = ['New tab was opened.', 'Tab was closed.', 'Tab was reloaded.']

# Clear events table
Event.delete_all

EVENTS.each_with_index do |event, index|
  Event.create(name: event, desc: DESCS[index])
end
