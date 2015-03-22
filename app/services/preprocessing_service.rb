class PreprocessingService
  def initialize
  end

  def preprocess
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
end
