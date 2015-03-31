require 'rails_helper'

RSpec.describe Feed, :type => :model do
    before(:all) do
      VCR.use_cassette('feeds') do
        Feed.read_feed
      end
    end
  describe "feed#" do
    it "one feed" do
        expect(Feed.all.size).to eq(1)
    end
    it "Correct values" do
        expect(Feed.all.first.as_jackpot).to eq(true)
        expect(Feed.all.first.prize).to eq(73000000)
        expect(Feed.all.first.last_key).to eq(" 2 30 32 39 44 +  6 10")
        expect(Feed.all.first.next_game_date).to eq("31/03/2015".to_date)
    end
  end
end