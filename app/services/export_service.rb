class ExportService
  attr_accessor :filename

  def initialize(filename)
    @filename = filename
  end

  def export
    ulogs = UsageLog.order(id: :asc)

    CSV.open(filename, "wb", col_sep: ',') do |csv|
      csv << export_attributes

      ulogs.find_each do |ulog|
        csv << ulog.attributes.values_at(*export_attributes)
      end
    end
  end

  private

  def export_attributes
    %w(id user_id session_id event_id tab_id window_id url domain path subdomain timestamp)
  end
end
