class Bet < ActiveRecord::Base
    belongs_to :games
    def parse line
        return false unless line.match(Bet.line_regex)
        self.first, self.second, self.third, self.forth, self.fifth, self.extra, self.extra_one = line.match(Bet.line_regex).captures
        return true
    end
    def to_s
        "#{self.first} #{self.second} #{self.third} #{self.forth} #{fifth} + #{extra} #{extra_one}"
    end
    def self.line_regex
        /^\s*(\d+) (\d+) (\d+) (\d+) (\d+) \+ (\d+) (\d+)\s*$/
    end
end
