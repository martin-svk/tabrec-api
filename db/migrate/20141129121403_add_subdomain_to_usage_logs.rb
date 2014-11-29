class AddSubdomainToUsageLogs < ActiveRecord::Migration
  def change
    add_column :usage_logs, :subdomain, :string
  end
end
