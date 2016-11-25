class Bet < ActiveRecord::Base
    belongs_to :games
    def parse line 
        self.first = -1
        if line.match(Bet.line_regex) then
            self.first, self.second, self.third, self.forth, self.fifth, self.extra, self.extra_one = line.match(Bet.line_regex).captures
        elsif not line.match(Bet.m1lhoes_regex_line) then
            return false
        end
            
        self.bet = line.strip
        return true
    end
    def compare_with combination
        if self.first == -1
            if combination.nil?
                output = to_bold(self.bet, [])
            else
                output = to_bold(self.bet, [combination.strip])
            end
        else
            left_side, right_side = split_list combination
            output = to_bold(self.first, left_side)
            output += to_bold(self.second, left_side)
            output += to_bold(self.third, left_side)
            output += to_bold(self.forth, left_side)
            output += to_bold(self.fifth, left_side)
            output += "+ "
            output += to_bold(self.extra, right_side)
            output += to_bold(self.extra_one, right_side)
        end
        output.strip
    end
    def number_correct combination
        if self.first == -1
            return 1 if self.bet == combination
            return 0
        else
            left_side, right_side = split_list combination
            left = count_correct(self.first, left_side)
            left += count_correct(self.second, left_side)
            left += count_correct(self.third, left_side)
            left += count_correct(self.forth, left_side)
            left += count_correct(self.fifth, left_side)
            right = count_correct(self.extra, right_side)
            right += count_correct(self.extra_one, right_side)
            return "#{left} + #{right}"
        end
    end
    def to_s
        return self.bet if self.first == -1
        "#{self.first} #{self.second} #{self.third} #{self.forth} #{fifth} + #{extra} #{extra_one}"
    end
    def self.line_regex
        /^\s*(\d+) (\d+) (\d+) (\d+) (\d+) \+ (\d+) (\d+)\s*$/
    end
    
    def self.m1lhoes_regex_line
        /^\s*(\w\w\w +\d\d\d\d\d)\s*$/
    end
    private
        def to_bold value, list
            return "<b>#{value}</b> " if list.include? value
            return "#{value} "
        end
        def count_correct value, list
            return 1 if list.include? value
            return 0
        end
        def split_list list
            left, right = list.split "+"
            left_side = []
            left.split.each do |num|
                left_side << num.to_i
            end
            right_side = []
            right.split.each do |num|
                right_side << num.to_i
            end
            return [left_side, right_side]
        end
end
