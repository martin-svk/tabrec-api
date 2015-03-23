class DiscoveryService
  attr_accessor :sequence_builder, :min_support

  def initialize(min_support, sequence_builder = SequenceBuilderService.new)
    @min_support = min_support / 100.0
    @sequence_builder = sequence_builder
  end

  def discover
    sequences = self.sequence_builder.get_sequences
    patterns = discover_patterns(sequences)
    patterns
  end

  private

  ##
  # Sequences look like this: { 'session-uuid': [ [{id: 1 eid: 2}, {id: 2, eid: 3}], [{id:4, eid: 5}] ] ... }
  # Old format was: {'session-uuid': [ [1, 3], [2, 4, 4, 5] ], 'session2-uuid': ... }
  # We firstly sort by sequence length and we store already processed sequences
  # in Set. Before processing another sequence we firstly check if this or its super-sequence
  # was not yet processed.
  ##
  def discover_patterns(all_sequences_hashes)
    sequences_counter = 0
    result = Hash.new
    compared = Set.new

    all_sequences_hashes.each_value do |sequence_hashes|
      sequences_array = []
      sequence_hashes.each do |sequence_hash|
        # Extract only event id from event hashes
        sequences_array << sequence_hash.each.map { |e| e[:eid] }
      end

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

        # Compare with all sequences in all_sequences_hash (N^2 Loop)
        all_sequences_hashes.each_value do |sequence_comparing_hashes|
          sequence_comparing_array = []
          sequence_comparing_hashes.each do |sequence_comparing_hash|
            # Extract only event id from event hashes
            sequence_comparing_array << sequence_comparing_hash.each.map { |e| e[:eid] }
          end

          seq_comp_array = sequence_comparing_array.sort_by(&:length).reverse

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
