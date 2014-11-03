# More will be defined later
EVENTS = %w(TAB_CREATE TAB_REMOVE TAB_ACTIVATE TAB_RELOAD)
DESCS = ['New tab was opened', 'Tab was closed', 'Tab was focused', 'Tab was reloaded.']

# Clear events table
if Event.count != EVENTS.size
  Event.delete_all
  EVENTS.each_with_index do |event, index|
    Event.create(name: event, desc: DESCS[index])
  end
end
