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

  def group_ulogs(ulogs)

  end

  def get_attributes
    %w(id session_id timestamp create create_bg close close_current focus move update attach detach)
  end

  private

  def group
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
