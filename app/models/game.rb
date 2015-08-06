class Game < ActiveRecord::Base
    has_many :bets, :autosave => true
    def self.find_by_date date
        self.where("day = ? ", (date) )
    end
    def self.create_games text
        total_added = 0
        Game.bulk_parse(text).each do |game|
            unless game.save
                return -1
            end
            UserMailer.bet_made(game).deliver
            total_added += 1
        end
        return total_added
    end
    def self.bulk_parse text
#248715564063
#07/08/2015	
#Euromilhões
#Aposta(s) Simples
#4 apostas
#Sorteio: 063/2015
#24 39 42 45 49 + 4 5
#2 6 13 39 46 + 1 3
#20 23 27 29 38 + 6 8
#7 8 11 25 37 + 6 10
#€ 8,00
        new_game = true
        games = []
        game = Game.new
        text.split(/\n+/).each do |line|
            game = Game.new if new_game
            new_game = false
            if line.match(/\d+\/\d+\/\d{4}/)
                game.day = Date.strptime(line, "%d/%m/%Y")
            elsif line.match(/Sorteio: \d+\/\d+/)
                game.num = line.match(/Sorteio: (\d+\/\d+)/).captures.first
            elsif line.match(Bet.line_regex)
                bet = Bet.new 
                bet.parse line
                game.bets << bet
            elsif line.match(/€ [\d,]+/)
                new_game = true
                games << game
            end
                
        end
        games
    end
end
