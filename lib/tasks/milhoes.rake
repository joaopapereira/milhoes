namespace :milhoes do
  desc "TODO"
  task load_feed: :environment do
    Feed.read_feed
  end
  
  task assign_responsible: :environment do
    Responsible.assign_responsible
  end

end
