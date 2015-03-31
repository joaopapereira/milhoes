require 'rails_helper'

RSpec.describe PlayingRules, :type => :model do
  before(:all) do
    @rule1=create(:playing_rule, :minor => 0, :major => 100, :number_beats => 1)
    @rule2=create(:playing_rule, :minor => 100, :major => 200, :number_beats => 2)
    @rule3=create(:playing_rule, :minor => 300, :major => 1000, :number_beats => 3)
  end
  describe "Check" do
      it "test1" do
          expect(@rule1.minor).to eq(0)
          expect(@rule1.major).to eq(100)
          expect(@rule1.number_beats).to eq(1)
      end
  end
  describe "PlayingRules#find_by_prize" do
      it "small" do
          total = PlayingRules.find_by_prize 50
          expect(total.size).to eq(1)
          expect(total[0].number_beats).to eq(1)
      end
      it "medium" do
          total = PlayingRules.find_by_prize 120
          expect(total.size).to eq(1)
          expect(total[0].number_beats).to eq(2)
      end
      it "greater" do
          total = PlayingRules.find_by_prize 400
          expect(total.size).to eq(1)
          expect(total[0].number_beats).to eq(3)
      end
  end
end
