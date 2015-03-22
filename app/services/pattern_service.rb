class PatternService
  attr_accessor :window_size, :min_gap, :max_gap, :min_transaction_size, :min_support

  def initialize(window_size, min_gap, max_gap, min_transaction_size, min_support)
    @window_size = window_size
    @min_gap = min_gap
    @max_gap = max_gap
    @min_transaction_size = min_transaction_size
    @min_support = min_support / 100.0
  end

  def extract
    sequences = get_sequences
    patterns = find_patterns(sequences)
    patterns
  end

  private

  ##
  # Will return all the sequences from all session
  # which are satisfying the parameter conditions (window size, min and max gap..)
  #
  def get_sequences
    sessions = UsageLog.select(:session_id).distinct.pluck(:session_id)
    sequences = Hash.new

    sessions.each_with_index do |session, index|
      sequences[session] = get_sequences_for(ulogs_in_session(session))
    end

    sequences
  end

  ##
  # Sequences look like this: {'session-uuid': [ [1, 3], [2, 4, 4, 5] ], 'session2-uuid': ... }
  # We firstly sort by sequence length and we store already processed sequences
  # in Set. Before processing another sequence we firstly check if this or its super-sequence
  # was not yet processed.
  ##
  def find_patterns(sequence_hash)
    sequences_counter = 0
    result = Hash.new
    compared = Set.new

    sequence_hash.each_value do |sequences_array|
      sequences_counter += sequences_array.length
      seq_array = sequences_array.sort_by(&:length).reverse

      seq_array.each do |seq|
        # Getting string from seq array
        seq = get_string_representation(seq)

        # Add to compared set and initialize (skip if sequence already was analyzed)
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
    end

    # Sorting based on counter applying min support and finally sorting by sequence length
    sorted = result.sort_by{ |_k, v| v }.reverse.to_h
    sorted_with_support = sorted.reject{ |_k, v| v < (sequences_counter * self.min_support) }
    sorted_with_support.sort_by{ |k, _v| k.length }.reverse.to_h
  end

  def get_sequences_for(ulogs)
    result = []
    sequences = []
    last_ulog = nil
    current_window_size = 0

    ulogs.each do |ulog|
      current_gap = last_ulog.nil? ? 0 : timestamp_gap(ulog, last_ulog)
      current_window_size += current_gap

      if last_ulog.nil? || (current_gap < self.max_gap && current_gap > self.min_gap && current_window_size < self.window_size)
        # inside the gap and window or first log in sequence
        sequences << ulog[:event_id]
        last_ulog = ulog
      else
        # ts gap or window is wider
        if sequences.size >= self.min_transaction_size
          result << sequences.dup
        end
        sequences.clear
        current_window_size = 0
        last_ulog = nil
      end
    end

    result
  end

  def ulogs_in_session(session)
    UsageLog.in_session(session).select(:id, :session_id, :event_id, :timestamp).order(id: :asc)
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
end
