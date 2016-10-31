require 'rails_helper'
require "milhoes_exceptions"
require 'byebug'

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
        # 025/2015
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
        expect(Feed.all.first.last_key).to eq(" 8 20 24 28 49 +  8 9")
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
  describe "feed#game_exists" do
    before(:each) do
      FactoryGirl.create :game, {:num => "E-025/2015"}
      VCR.use_cassette('feeds') do
        Feed.read_feed
      end
    end
    it "Correct values" do
      expect(Feed.all.first.as_jackpot).to eq(true)
      expect(Feed.all.first.prize).to eq(73000000)
      expect(Feed.all.first.last_key).to eq(" 2 30 32 39 44 +  6 10")
      expect(Feed.all.first.next_game_date).to eq("31/03/2015".to_date)
      expect(Game.all.length).to eq 1
      expect(Game.find_by_num("E-025/2015").winner_combination).to eq("2 30 32 39 44 +  6 10")
      # 025/2015
    end
  end
  describe "feed#with_m1lhoes" do
    before(:each) do
      VCR.use_cassette('feeds_m1lhoes') do
        Feed.read_feed
      end
    end
  
    it "one feed" do
        expect(Feed.all.size).to eq(2)
    end
    it "Correct EuroMIlhoes values" do
        expect(Feed.all.first.as_jackpot).to eq(false)
        expect(Feed.all.first.prize).to eq(17000000)
        expect(Feed.all.first.last_key).to eq(" 10 16 19 23 43 +  2 8")
        expect(Feed.all.first.next_game_date).to eq("01/11/2016".to_date)
        expect(Feed.all.first.last_game_num).to eq 'E-087/2016'
    end
    
    it "Correct M1lhoes values" do
        expect(Feed.all.second.as_jackpot).to eq(false)
        expect(Feed.all.second.prize).to eq(1000000)
        expect(Feed.all.second.last_key).to eq("DFJ 20960")
        expect(Feed.all.second.next_game_date).to eq("04/11/2016".to_date)
        expect(Feed.all.second.last_game_num).to eq 'M-005/2016'
    end
  end
end
