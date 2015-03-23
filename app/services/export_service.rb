class ExportService
  attr_accessor :filename, :preprocess

  def initialize(filename, preprocess = false)
    @filename = filename
    @preprocess = preprocess
  end

  def export
    ulogs = if preprocess
      ps = PreprocessingService.new
      ps.preprocess(UsageLog.order(id: :asc))
    else
      UsageLog.order(id: :asc)
    end

    CSV.open(filename, "wb", col_sep: ',') do |csv|
      if preprocess
        csv << ps.get_attributes
        ulogs.find_each do |ulog|
          csv << ulog
        end
      else
        csv << export_attributes
        ulogs.find_each do |ulog|
          csv << ulog.attributes.values_at(*export_attributes)
        end
      end
    end
  end

  private

  def export_attributes
    %w(id user_id session_id event_id tab_id window_id url domain path subdomain timestamp)
  end
end
