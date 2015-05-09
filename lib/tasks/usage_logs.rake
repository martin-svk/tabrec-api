require 'csv'

namespace :ulogs do
  desc 'Exploratory analysis of usage logs.'
  task :stats do
    users_count = User.count
    active_users_count = UsageLog.uniq.pluck(:user_id).count
    ulogs_count = UsageLog.count
    sessions_count = UsageLog.select(:session_id).distinct.count

    puts '------------   BASICS   --------------'

    puts "Number of usage logs in DB: #{ulogs_count}"
    puts "Number of users in DB: #{users_count}"
    puts "Number of active users in DB: #{active_users_count}"
    puts "Number of sessions in DB: #{sessions_count}"

    ul = UsageLog.first
    puts "Example usage log: #{ul.attributes}"

    puts '-----------   AVERAGES   -------------'

    puts "Average logs/user #{ulogs_count / active_users_count}"
    puts "Average logs/session #{ulogs_count / sessions_count}"

    puts '------------   EVENTS   --------------'

    tab_created = UsageLog.where(event_id: 1).count
    tab_removed = UsageLog.where(event_id: 2).count
    tab_activated = UsageLog.where(event_id: 3).count
    tab_moved = UsageLog.where(event_id: 4).count
    tab_updated = UsageLog.where(event_id: 5).count
    tab_attached = UsageLog.where(event_id: 6).count
    tab_detached = UsageLog.where(event_id: 7).count

    puts "ULogs for TAB_CREATED: #{tab_created} => #{(tab_created / ulogs_count.to_f * 100).round(2)}%"
    puts "ULogs for TAB_REMOVED: #{tab_removed} => #{(tab_removed / ulogs_count.to_f * 100).round(2)}%"
    puts "ULogs for TAB_ACTIVATED: #{tab_activated} => #{(tab_activated / ulogs_count.to_f * 100).round(2)}%"
    puts "ULogs for TAB_UPDATED: #{tab_updated} => #{(tab_updated / ulogs_count.to_f * 100).round(2)}%"
    puts "ULogs for TAB_MOVED: #{tab_moved} => #{(tab_moved / ulogs_count.to_f * 100).round(2)}%"
    puts "ULogs for TAB_ATTACHED: #{tab_attached} => #{(tab_attached / ulogs_count.to_f * 100).round(2)}%"
    puts "ULogs for TAB_DETACHED: #{tab_detached} => #{(tab_detached / ulogs_count.to_f * 100).round(2)}%"
  end

  desc 'Discover the most common transactions (patterns)'
  task :discover do
    window_size = 100_000
    min_gap = 0
    max_gap = 5_000
    min_transaction_size = 3
    min_support = 0.5 # percent
    group = false

    seq_builder = SequenceBuilderService.new(window_size, min_gap, max_gap, min_transaction_size)
    pds = DiscoveryService.new(min_support, group, seq_builder)
    patterns = pds.discover

    puts
    puts 'Most common patterns:'
    puts
    puts "Events | #{Event.pluck(:id, :name)}"
    puts "Attributes | window size: #{window_size / 1000} sec | max gap: #{max_gap / 1000} sec "\
      "| grouped: #{group} | min support: #{min_support}% of transactions"
    puts

    patterns.each do |key, value|
      puts "Sequence: #{key} | Occured: #{value} times"
    end
  end

  desc 'Will transform and export usage logs data to CSV in wide column format and preprocessed (grouped) events'
  task :preprocess do
    filename = 'tabrec_ulogs_wide_format_' + Date.today.to_s + '.csv'
    es = ExportService.new(filename, true)
    es.export
  end

  desc 'Will export usage log data into CSV.'
  task :export do
    filename = 'tabrec_ulogs_' + Date.today.to_s + '.csv'
    es = ExportService.new(filename)
    es.export
  end
end
