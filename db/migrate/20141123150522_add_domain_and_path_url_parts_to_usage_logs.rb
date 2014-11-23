class AddDomainAndPathUrlPartsToUsageLogs < ActiveRecord::Migration
  def change
    add_column :usage_logs, :domain, :string
    add_column :usage_logs, :path, :string
  end
end
