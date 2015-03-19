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

  desc "Implementation of trivial GSP like algorithm for finding the most common transactions"
  task :gsp do
    # Basic params
    window_size = 100_000
    min_gap = 0
    max_gap = 5_000
    min_transaction_size = 3
    sessions = UsageLog.select(:session_id).distinct.pluck(:session_id) # our 'customers'

    # Result sequences
    @sequences = Hash.new

    puts 'Extracting all sequences per session'
    sessions.each_with_index do |session, index|
      @sequences[session] = get_sequences(window_size, min_gap, max_gap, min_transaction_size, ulogs_in_session(session))
      print_progress(index, sessions.size / 100)
    end

    # Now find the most common sequence
    min_support = 0.03 # 3 percent

    puts
    puts 'Generating most common sequences'

    @patterns = get_patterns(@sequences, min_support)

    puts
    puts 'Most common patterns:'
    puts
    puts "Events | #{Event.pluck(:id, :name)}"
    puts "GSP | window size: #{window_size / 1000} sec | max gap: #{max_gap / 1000} sec | min support: #{min_support * 100}% of transactions"
    puts

    @patterns.each do |key, value|
      puts "Sequence: #{key} | Occured: #{value} times"
    end
  end

  desc "Will transform and export to CSV usage logs data in wide column format for events"
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

  private

  def ulogs_in_session(session)
    UsageLog.in_session(session).select(:id, :session_id, :event_id, :timestamp).order(id: :asc)
  end

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

  ##
  # Sequences look like this: {'session-uuid': [ [1, 3], [2, 4, 4, 5] ], 'session2-uuid': ... }
  # We firstly sort by sequence length and we store already processed sequences
  # in Set. Before processing another sequence we firstly check if this or its super-sequence
  # was not yet processed.
  ##
  def get_patterns(sequence_hash, min_support)
    progress_counter = 0
    sequences_counter = 0
    result = Hash.new
    compared = Set.new

    sequence_hash.each_value do |sequences_array|
      sequences_counter += sequences_array.length
      seq_array = sequences_array.sort_by(&:length).reverse

      seq_array.each do |seq|
        # Getting string from seq array
        seq = get_string_representation(seq)

        # Add to compared set and intialize (skip if sequence already was analyzed)
        if compared.add?(seq).nil?
          next
        else
          result[seq] = 0
        end

        # Compare with all sequences in sequence_hash (N^2 Loop)
        sequence_hash.each_value do |sequences_comparing_array|
          seq_comp_array = sequences_comparing_array.sort_by(&:length).reverse

          seq_comp_array.each do |seq_comparing|
            seq_comp = get_string_representation(seq_comparing)

            # Comparing sequences as strings (testing if subsequence/substring exists)
            if seq == seq_comp || seq_comp.include?(seq)
              result[seq] += 1
            end
          end
        end
      end

      # Printing progress
      print_progress(progress_counter, sequence_hash.size / 100)
      progress_counter += 1
    end

    # Sorting based on counter applicating min support and finally sorting by sequence lenght
    sorted = result.sort_by{ |_k, v| v }.reverse.to_h
    sorted_with_support = sorted.reject{ |_k, v| v < (sequences_counter * min_support) }
    sorted_with_support.sort_by{ |k, _v| k.length }.reverse.to_h
  end

  def timestamp_gap(ulog1, ulog2)
    ulog1[:timestamp] - ulog2[:timestamp]
  end

  def get_string_representation(array)
    result = ''
    array.each do |element|
      result += element.to_s
    end
    result
  end

  # Printing progress
  def print_progress(current, percent)
    if percent > 0
      if current % percent == 0
        print '-'
      end
    end
  end

  # Get array of 1 or 0 depending on with event is in usage log
  def event_array(ulog)
    array = []
    Event.count.times do
      array << 0
    end
    array[ulog.event_id - 1] = 1 # array number from 0, event id from 1
    array
  end
end
