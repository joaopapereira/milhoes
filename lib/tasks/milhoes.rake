namespace :milhoes do
  desc "TODO"
  task load_feed: :environment do
    Feed.read_feed
  end

end
