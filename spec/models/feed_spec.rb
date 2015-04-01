require 'rails_helper'
require "milhoes_exceptions"

RSpec.describe Feed, :type => :model do
  before(:each) do
    DatabaseCleaner.clean_with(:truncation)
  end
  describe "feed#jackpot" do
    before(:each) do
      VCR.use_cassette('feeds') do
        Feed.read_feed
      end
    end
  
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
  describe "feed#no_jackpot" do
    before(:each) do
      VCR.use_cassette('feeds_no_jackopt') do
        Feed.read_feed
      end
    end
  
    it "one feed" do
        expect(Feed.all.size).to eq(1)
    end
    it "no change" do
        expect(Feed.all.first.as_jackpot).to eq(false)
        expect(Feed.all.first.prize).to eq(15000000)
        expect(Feed.all.first.last_key).to eq("1")
        expect(Feed.all.first.next_game_date).to eq("03/04/2015".to_date)
    end
  end
  describe "feed#no_prize" do
    it "one feed" do
        VCR.use_cassette('feeds_no_prize') do
          begin 
            Feed.read_feed
            StandardError.new "Should not have reached here"
          rescue FeedHasNoPrizeError
          
          end
        end
    end
  end
  describe "feed#already_present" do
    it "one feed" do
        VCR.use_cassette('feeds_no_jackopt') do
          Feed.read_feed
        end
        VCR.use_cassette('feeds_no_jackopt') do
          begin 
            Feed.read_feed
            StandardError.new "Should not have reached here"
          rescue FeedAlreadyExistsError
          end
        end
    end
  end
end
