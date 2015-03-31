class PlayingRules < ActiveRecord::Base
    def self.find_by_prize prize
        self.where("? BETWEEN minor and major", prize)
    end
end
