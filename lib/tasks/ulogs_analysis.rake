namespace :ulogs do
  desc "Exploratory analysis of usage logs."
  task :stats do
    users_count = User.count
    ulogs_count = UsageLog.count
    sessions_count = UsageLog.uniq.pluck(:session_id).size

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

    # puts "-------- SIMPLE SEQUENCES  -----------"
  end
end