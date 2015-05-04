namespace :rec_logs do
  desc 'Exploratory analysis of recommendation logs.'
  task :stats do
    users_count = User.count
    logs_count = Log.count

    accepted_count = Log.accepted.count
    accepted_count += Log.yes.count

    rejected_count = Log.rejected.count
    rejected_count += Log.no.count

    reverted_count = Log.reverted.count
    automatic_count = Log.automatic.count

    puts '------------   BASICS   --------------'
    puts

    puts "Number of users in DB: #{users_count}"
    puts "Number of recommendation logs in DB: #{logs_count}"
    puts "Number of accepted advices in DB: #{accepted_count}"
    puts "Number of rejected advices in DB: #{rejected_count}"
    puts "Number of reverted advices in DB: #{reverted_count}"
    puts "Number of automatic advices in DB: #{automatic_count}"

    puts
    puts '-----------   STATS   -------------'
    puts

    puts "Average logs/user #{(logs_count.to_f / users_count).round(2)}"
    puts "Accepted advices #{(accepted_count.to_f / logs_count * 100).round(2)}%"
    puts "Rejected advices #{(rejected_count.to_f / logs_count * 100).round(2)}%"
    puts "Reverted advices #{(reverted_count.to_f / logs_count * 100).round(2)}%"
    puts "Automatic advices #{(automatic_count.to_f / logs_count * 100).round(2)}%"

    puts
    puts '-----------   PATTERNS   -------------'
    puts
    patterns = Pattern.select(:name, :sequence, :desc).joins(:advice).select('advices.name as advice_name')

    patterns.each do |pattern|
      puts pattern.attributes
    end

    puts
    puts '-----------   ADVICES   -------------'
    puts
    advices = Advice.select(:id, :name, :desc)

    advices.each do |advice|
      puts advice.attributes
    end

    puts
    puts '---   STATS PER PATTERN VERSION   ---'
    puts

    patterns.each do |pattern|
      pname = pattern.name

      puts
      puts pname
      puts

      logs_pv = Log.for_pattern(pname).count

      accepted_pv = Log.for_pattern(pname).accepted.count
      accepted_pv += Log.for_pattern(pname).yes.count

      rejected_pv = Log.for_pattern(pname).rejected.count
      rejected_pv += Log.for_pattern(pname).no.count

      reverted_pv = Log.for_pattern(pname).reverted.count
      automatic_pv = Log.for_pattern(pname).automatic.count

      puts "Provided advices #{logs_pv}"
      puts "Accepted advices #{(accepted_pv.to_f / logs_pv * 100).round(2)}%"
      puts "Rejected advices #{(rejected_pv.to_f / logs_pv * 100).round(2)}%"
      puts "Reverted advices #{(reverted_pv.to_f / logs_pv * 100).round(2)}%"
      puts "Automatic advices #{(automatic_pv.to_f / logs_pv * 100).round(2)}%"
    end
  end
end
