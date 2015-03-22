require 'csv'
require 'pry'

namespace :ulogs do
  desc "Exploratory analysis of usage logs."
  task :stats do
    users_count = User.count
    ulogs_count = UsageLog.count
    sessions_count = UsageLog.select(:session_id).distinct.count

    puts "------------   BASICS   --------------"

    puts "Number of usage logs in DB: #{ulogs_count}"
    puts "Number of users in DB: #{users_count}"
    puts "Number of sessions in DB: #{sessions_count}"

    ul = UsageLog.first
    puts "Example usage log: #{ul.attributes}"

    puts "-----------   AVERAGES   -------------"

    puts "Average logs/user #{ulogs_count / users_count}"
    puts "Average logs/session #{ulogs_count / sessions_count}"

    puts "------------   EVENTS   --------------"

    puts "ULogs for TAB_CREATED: #{UsageLog.where(event_id: 1).count}"
    puts "ULogs for TAB_REMOVED: #{UsageLog.where(event_id: 2).count}"
    puts "ULogs for TAB_ACTIVATED: #{UsageLog.where(event_id: 3).count}"
    puts "ULogs for TAB_MOVED: #{UsageLog.where(event_id: 4).count}"
    puts "ULogs for TAB_UPDATED: #{UsageLog.where(event_id: 5).count}"
    puts "ULogs for TAB_ATTACHED: #{UsageLog.where(event_id: 6).count}"
    puts "ULogs for TAB_DETACHED: #{UsageLog.where(event_id: 7).count}"
  end

  desc "Extract the most common transactions (patterns)"
  task :extract do
    window_size = 100_000
    min_gap = 0
    max_gap = 5_000
    min_transaction_size = 3
    min_support = 5 # percent

    ps = PatternService.new(window_size, min_gap, max_gap, min_transaction_size, min_support)
    patterns = ps.extract

    puts
    puts 'Most common patterns:'
    puts
    puts "Events | #{Event.pluck(:id, :name)}"
    puts "GSP | window size: #{window_size / 1000} sec | max gap: #{max_gap / 1000} sec | min support: #{min_support}% of transactions"
    puts

    patterns.each do |key, value|
      puts "Sequence: #{key} | Occured: #{value} times"
    end
  end

  desc "Will transform and export usage logs data to CSV in wide column format for events"
  task :transform do
    filename = 'tabrec_ulogs_wide_format_' + Date.today.to_s + '.csv'

    ulogs = UsageLog.select(:id, :session_id, :event_id, :timestamp).order(id: :asc)
    ucount = UsageLog.count

    CSV.open(filename, "wb", col_sep: ',') do |csv|
      index = 0
      csv << ['sid', 'timestamp', 'create', 'remove', 'activate', 'move', 'update', 'attach', 'detach']

      ulogs.find_each do |ulog|
        row = [ulog.session_id, ulog.timestamp] + event_array(ulog)
        csv << row
        index += 1
        print_progress(index, ucount / 100)
      end
    end
  end

  desc "Will export usage logs to CSV"
  task :export do
  end
end
