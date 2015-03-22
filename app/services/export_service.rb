class ExportService
  attr_accessor :filename, :attributes

  def initialize(filename, attributes = [])
    @filename = filename
    @attributes = attributes
  end

  def export
    ulogs = UsageLog.order(id: :asc)

    CSV.open(filename, "wb", col_sep: ',') do |csv|
      csv << export_attributes

      ulogs.find_each do |user|
        csv << user.attributes.values_at(*export_attributes)
      end
    end
  end

  private

  def export_attributes
    %w(id user_id event_id tab_id window_id url domain path subdomain timestamp)
  end
end
