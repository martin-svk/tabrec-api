class MigrateToNewRecModes < ActiveRecord::Migration
  def up
    User.find_each do |u|
      if u.rec_mode == 'semi-interactive'
        u.rec_mode = 'interactive'
      elsif u.rec_mode == 'aggressive'
        u.rec_mode = 'automatic'
      end
      u.save!
    end
  end
end
