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

  desc "Implementation of trivial GSP like algorithm for finding the most common transactions"
  task :gsp do
    # Basic params
    window_size = 100_000
    min_gap = 0
    max_gap = 3_000
    min_transaction_size = 3
    sessions = UsageLog.select(:session_id).distinct.pluck(:session_id) # our 'customers'

    # Result sequences
    @sequences = Hash.new

    sessions.each do |session|
      # puts "Processing session: #{session}"
      @sequences[session] = get_sequences(window_size, min_gap, max_gap, min_transaction_size, ulogs_in_session(session))
    end

    # Now find the most common sequence
    min_support = 0.15 # 15 percent
  end

  private

  def get_sequences(win_size, min_gap, max_gap, min_transaction_size, ulogs)
    result = []
    sequences = []
    last_ulog = nil
    current_window_size = 0

    ulogs.each do |ulog|
      current_gap = last_ulog.nil? ? 0 : timestamp_gap(ulog, last_ulog)
      current_window_size += current_gap

      if last_ulog.nil? || (current_gap < max_gap && current_gap > min_gap && current_window_size < win_size)
        # inside the gap and window or first log in sequence
        sequences << ulog[:event_id]
        last_ulog = ulog
      else
        # ts gap or window is wider
        if sequences.size >= min_transaction_size
          result << sequences.dup
        end
        sequences.clear
        current_window_size = 0
        last_ulog = nil
      end
    end

    result
  end

  def timestamp_gap(ulog1, ulog2)
    ulog1[:timestamp] - ulog2[:timestamp]
  end

  def ulogs_in_session(session)
    UsageLog.in_session(session).select(:id, :session_id, :event_id, :timestamp).order(id: :asc)
  end
end
