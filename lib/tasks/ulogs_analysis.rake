namespace :ulogs do
  desc "Exploratory analysis of usage logs."
  task :exploratory do
    puts UsageLog.count
  end
end
