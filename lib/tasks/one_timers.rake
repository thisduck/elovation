namespace :one_timers do
  desc "Assign password 'temp' to all players"
  task :assign_default_passwords => :environment do
    Player.all.each do |player|
      player.password = 'temp'
      player.password_confirmation = 'temp'
      player.save
    end
  end

end
