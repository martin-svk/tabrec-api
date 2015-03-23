class PreprocessingService
  def initialize
  end

  def preprocess(ulogs)
    result = []

    ulogs.find_each do |ulog|
    end
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
