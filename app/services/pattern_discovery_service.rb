class DiscoveryService
  attr_accessor :min_support

  def initialize(min_support)
    @min_support = min_support / 100.0
  end

  def discover
    ss = SequenceBuilderService.new
    sequences = ss.get_sequences
    patterns = discover_patterns(sequences)
    patterns
  end

  private

  ##
  # Sequences look like this: {'session-uuid': [ [1, 3], [2, 4, 4, 5] ], 'session2-uuid': ... }
  # We firstly sort by sequence length and we store already processed sequences
  # in Set. Before processing another sequence we firstly check if this or its super-sequence
  # was not yet processed.
  ##
  def discover_patterns(sequence_hash)
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

  def get_string_representation(array)
    result = ''
    array.each do |element|
      result += element.to_s
    end
    result
  end
end
