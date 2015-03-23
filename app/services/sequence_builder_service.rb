class SequenceBuilderService
  attr_accessor :window_size, :min_gap, :max_gap, :min_transaction_size

  def initialize(window_size = 100_000, min_gap = 0, max_gap = 3_000, min_transaction_size = 3)
    @window_size = window_size
    @min_gap = min_gap
    @max_gap = max_gap
    @min_transaction_size = min_transaction_size
  end

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

  private

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
end
