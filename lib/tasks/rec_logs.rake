namespace :rec_logs do
  desc "Exploratory analysis of recommendation logs."
  task :stats do
    users_count = User.count
    logs_count = Log.count
    accepted_count = Log.accepted.count
    rejected_count = Log.rejected.count
    reverted_count = Log.reverted.count
    automatic_count = Log.automatic.count

    puts "------------   BASICS   --------------"
    puts

    puts "Number of users in DB: #{users_count}"
    puts "Number of recommendation logs in DB: #{logs_count}"
    puts "Number of accepted advices in DB: #{accepted_count}"
    puts "Number of rejected advices in DB: #{rejected_count}"
    puts "Number of reverted advices in DB: #{reverted_count}"
    puts "Number of automatic advices in DB: #{automatic_count}"

    puts
    puts "-----------   STATS   -------------"
    puts

    puts "Average logs/user #{(logs_count.to_f / users_count).round(2)}"
    puts "Accepted advices #{(accepted_count.to_f / logs_count * 100).round(2)}%"
    puts "Rejected advices #{(rejected_count.to_f / logs_count * 100).round(2)}%"
    puts "Reverted advices #{(reverted_count.to_f / logs_count * 100).round(2)}%"
    puts "Automatic advices #{(automatic_count.to_f / logs_count * 100).round(2)}%"

    puts
    puts "-----------   PATTERNS   -------------"
    puts
    patterns = Pattern.select(:id, :sequence, :desc).joins(:advice).select('advices.name as advice_name')

    patterns.each do |pattern|
      puts pattern.attributes
    end

    puts
    puts "-----------   ADVICES   -------------"
    puts
    advices = Advice.select(:id, :name, :desc)

    advices.each do |advice|
      puts advice.attributes
    end
  end
end
