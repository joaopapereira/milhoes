class Bet < ActiveRecord::Base
    belongs_to :games
    def parse line
        return false unless line.match(Bet.line_regex)
        self.first, self.second, self.third, self.forth, self.fifth, self.extra, self.extra_one = line.match(Bet.line_regex).captures
        return true
    end
    def compare_with combination
        left_side, right_side = split_list combination
        output = to_bold(self.first, left_side)
        output += to_bold(self.second, left_side)
        output += to_bold(self.third, left_side)
        output += to_bold(self.forth, left_side)
        output += to_bold(self.fifth, left_side)
        output += "+ "
        output += to_bold(self.extra, right_side)
        output += to_bold(self.extra_one, right_side)
        output.strip
    end
    def number_correct combination
        left_side, right_side = split_list combination
        left = count_correct(self.first, left_side)
        left += count_correct(self.second, left_side)
        left += count_correct(self.third, left_side)
        left += count_correct(self.forth, left_side)
        left += count_correct(self.fifth, left_side)
        right = count_correct(self.extra, right_side)
        right += count_correct(self.extra_one, right_side)
        "#{left} + #{right}"
    end
    def to_s
        "#{self.first} #{self.second} #{self.third} #{self.forth} #{fifth} + #{extra} #{extra_one}"
    end
    def self.line_regex
        /^\s*(\d+) (\d+) (\d+) (\d+) (\d+) \+ (\d+) (\d+)\s*$/
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
