# --------------------------------
# Data hashes
# --------------------------------

EVENTS_HASH = {
  TAB_CREATED: 'New tab was opened',
  TAB_REMOVED: 'Tab was closed',
  TAB_ACTIVATED: 'Tab was focused',
  TAB_MOVED: 'Tab was moved within window',
  TAB_UPDATED: 'Tab was updated (i.e. new url inserted)',
  TAB_ATTACHED: 'Tab was moved between windows (docked to new)',
  TAB_DETACHED: 'Tab was moved between windows (detached from old)'
}

ADVICES_HASH = {
  TAB_DOMAIN_SORT: 'Will sort all opened tabs in current window by domain URLs',
  TAB_DOMAIN_SORT_V2: 'Will sort all opened tabs in current window by domain URLs and wait some time after execution and dont trigger again.',
  NO_ADVICE: 'No action is performed'
}

RESOLUTIONS_HASH = {
  ACCEPTED: 'User manually accepted recommendation',
  REJECTED: 'User manually rejected recommendation',
  REVERTED: 'User accepted but later reverted recommendation',
  AUTOMATIC: 'Recommendation was automatically accepted',
  YES: 'User accepted our prediction',
  NO: 'User denied our prediction'
}

# --------------------------------
# Run in transactions
# --------------------------------

ActiveRecord::Base.transaction do
  # Event seeds
  Event.delete_all
  ActiveRecord::Base.connection.reset_pk_sequence!(Event.table_name)
  EVENTS_HASH.each  do |name, desc|
    Event.create!(name: name, desc: desc)
  end

  # Advice seeds
  Advice.delete_all
  ActiveRecord::Base.connection.reset_pk_sequence!(Advice.table_name)
  ADVICES_HASH.each do |name, desc|
    Advice.create!(name: name, desc: desc)
  end

  # Resolution seeds
  Resolution.delete_all
  ActiveRecord::Base.connection.reset_pk_sequence!(Resolution.table_name)
  RESOLUTIONS_HASH.each do |name, desc|
    Resolution.create!(name: name, desc: desc)
  end
end

# --------------------------------
# Patterns data
# --------------------------------

PATTERNS = [
  {
    name: 'MULTI_ACTIVATE',
    desc: 'User focused four tabs in a constant time gap.',
    sequence: 'TAB_ACTIVATED TAB_ACTIVATED TAB_ACTIVATED TAB_ACTIVATED',
    advice_id: Advice.find_by(name: 'TAB_DOMAIN_SORT').id
  },
  {
    name: 'MULTI_ACTIVATE_V2',
    desc: 'User focused four tabs in a constant time gap (excluding some time after accepting).',
    sequence: 'TAB_ACTIVATED TAB_ACTIVATED TAB_ACTIVATED TAB_ACTIVATED',
    advice_id: Advice.find_by(name: 'TAB_DOMAIN_SORT_V2').id
  },
  {
    name: 'MULTI_ACTIVATE_V3',
    desc: 'User focused four tabs (excluding tabs next to each other) in his running average time gap.',
    sequence: 'TAB_ACTIVATED TAB_ACTIVATED TAB_ACTIVATED TAB_ACTIVATED',
    advice_id: Advice.find_by(name: 'TAB_DOMAIN_SORT_V2').id
  },
  {
    name: 'MULTI_ACTIVATE_V4',
    desc: 'User focused four tabs (at least three different tab ids) in thresholded running average time gap.',
    sequence: 'TAB_ACTIVATED TAB_ACTIVATED TAB_ACTIVATED TAB_ACTIVATED',
    advice_id: Advice.find_by(name: 'TAB_DOMAIN_SORT_V2').id
  },
  {
    name: 'COMPARE_V0',
    desc: 'User is swiching between two tabs (at least four activates) in thresholded running average time gap.',
    sequence: 'TAB_ACTIVATED TAB_ACTIVATED TAB_ACTIVATED TAB_ACTIVATED',
    advice_id: Advice.find_by(name: 'NO_ADVICE').id
  },
  {
    name: 'REFRESH_V0',
    desc: 'User is monitoring (refreshing) specific tab three times in thresholded running average time gap.',
    sequence: 'TAB_UPDATED TAB_UPDATED TAB_UPDATED',
    advice_id: Advice.find_by(name: 'NO_ADVICE').id
  },
  {
    name: 'MULTI_CLOSE_V0',
    desc: 'User closed three tabs from same domain in thresholded running average time gap.',
    sequence: 'TAB_REMOVED TAB_REMOVED TAB_REMOVED',
    advice_id: Advice.find_by(name: 'NO_ADVICE').id
  }
]

# --------------------------------
# Pattern seeds in transaction
# --------------------------------
Pattern.transaction do
  Pattern.delete_all
  ActiveRecord::Base.connection.reset_pk_sequence!(Pattern.table_name)
  PATTERNS.each do |pattern_hash|
    Pattern.create!(
      name: pattern_hash[:name],
      desc: pattern_hash[:desc],
      sequence: pattern_hash[:sequence],
      advice_id: pattern_hash[:advice_id]
    )
  end
end
