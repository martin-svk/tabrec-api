class TransformingService
  attr_accessor :filename

  def initialize(filename)
    @filename = filename
  end

  def transform
    ulogs = UsageLog.select(:id, :session_id, :event_id, :timestamp).order(id: :asc)
    count = Event.count

    CSV.open(filename, "wb", col_sep: ',') do |csv|
      csv << ['sid', 'timestamp', 'create', 'remove', 'activate', 'move', 'update', 'attach', 'detach']

      ulogs.find_each do |ulog|
        row = [ulog.session_id, ulog.timestamp] + event_array(ulog, count)
        csv << row
      end
    end
  end

  private

  # Get array of 1 or 0 depending on with event is in usage log
  def event_array(ulog, count)
    array = []
    count.times do
      array << 0
    end
    array[ulog.event_id - 1] = 1 # array number from 0, event id from 1
    array
  end
end
