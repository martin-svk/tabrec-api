class GroupingService
  attr_accessor :seq_builder

  def initialize(seq_builder = SequenceBuilderService.new)
    @seq_builder = seq_builder
  end

  def get_grouped_ulogs
    result = []
    sequences = self.seq_builder.get_sequences

    # Each seq has event_id and id
    sequences.find_each do |seq|
    end
  end

  def group(patterns)
    result = {}
    patterns.each do |seq, count|
      grouped = group_sequence(seq)
      result[grouped] = count
    end
    result
  end

  def get_attributes
    %w(id session_id timestamp create create_bg close close_current focus move update attach detach)
  end

  private

  def group_sequence(sequence)
    result = sequence.gsub("#{new_tab}", 'NEW_TAB > ')
    result = result.gsub("#{new_tab_bg}", 'NEW_TAB_BG > ')
    result = result.gsub("#{close_current_tab}", 'CLOSE_CURRENT_TAB > ')
    result = result.gsub("1", Event.find(1).name + ' > ')
    result = result.gsub("2", Event.find(2).name + ' > ')
    result = result.gsub("3", Event.find(3).name + ' > ')
    result = result.gsub("4", Event.find(4).name + ' > ')
    result = result.gsub("5", Event.find(5).name + ' > ')
    result = result.gsub("6", Event.find(6).name + ' > ')
    result = result.gsub("7", Event.find(7).name + ' > ')
    result
  end

  def new_tab
    # tab created + tab activated + tab updated
    "#{Event.find_by(name: 'TAB_CREATED').id}#{Event.find_by(name: 'TAB_ACTIVATED').id}#{Event.find_by(name: 'TAB_UPDATED').id}"
  end

  def new_tab_bg
    # tab created + tab updated
    "#{Event.find_by(name: 'TAB_CREATED').id}#{Event.find_by(name: 'TAB_UPDATED').id}"
  end

  def close_current_tab
    # tab removed + tab activated
    "#{Event.find_by(name: 'TAB_REMOVED').id}#{Event.find_by(name: 'TAB_ACTIVATED').id}"
  end
end
