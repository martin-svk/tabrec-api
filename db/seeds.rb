# More will be defined later
EVENTS = %w(TAB_CREATED TAB_REMOVED TAB_ACTIVATED TAB_MOVED TAB_UPDATED TAB_ATTACHED TAB_DETACHED)
DESCS = [
          'New tab was opened', 'Tab was closed', 'Tab was focused', 'Tab was moved within window',
          'Tab was updated (ie. new url inserted)', 'Tab was moved between windows (docked to new)',
          'Tab was moved between windows (detached from old)'
        ]

# Clear events table
if Event.count != EVENTS.size
  Event.delete_all
  EVENTS.each_with_index do |event, index|
    Event.create(name: event, desc: DESCS[index])
  end
end
