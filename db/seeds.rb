# --------------------------------
# Event seeds
# --------------------------------
EVENTS = %w(TAB_CREATED TAB_REMOVED TAB_ACTIVATED TAB_MOVED TAB_UPDATED TAB_ATTACHED TAB_DETACHED)
EVENT_DESCS = [ 'New tab was opened', 'Tab was closed', 'Tab was focused', 'Tab was moved within window',
                'Tab was updated (ie. new url inserted)', 'Tab was moved between windows (docked to new)',
                'Tab was moved between windows (detached from old)' ]

# Clear events table
if Event.count != EVENTS.size
  Event.delete_all
  ActiveRecord::Base.connection.reset_pk_sequence!(Event.table_name)
  EVENTS.each_with_index do |event, index|
    Event.create!(name: event, desc: EVENT_DESCS[index])
  end
end

# --------------------------------
# Advice seeds
# --------------------------------
ADVICES = %w(TAB_DOMAIN_SORT)
ADVICE_DESCS = [ 'Will sort all opened tabs in current window by domain URLs' ]

if Advice.count != ADVICES.size
  Advice.delete_all
  ActiveRecord::Base.connection.reset_pk_sequence!(Advice.table_name)
  ADVICES.each_with_index do |advice, index|
    Advice.create!(name: advice, desc: ADVICE_DESCS[index])
  end
end

# --------------------------------
# Pattern seeds
# --------------------------------
PATTERN_SEQUENCES = [ 'TAB_ACTIVATED TAB_ACTIVATED TAB_ACTIVATED' ]
PATTERN_ADVICE_IDS = [ Advice.find_by(name: 'TAB_DOMAIN_SORT').id ]

if Pattern.count != PATTERN_SEQUENCES.size
  Pattern.delete_all
  ActiveRecord::Base.connection.reset_pk_sequence!(Pattern.table_name)
  PATTERN_SEQUENCES.each_with_index do |seq, index|
    Pattern.create!(sequence: seq, advice_id: PATTERN_ADVICE_IDS[index])
  end
end
