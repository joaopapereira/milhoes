
require 'milhoes_exceptions'
class Feed < ActiveRecord::Base
    def number_of_beats
        rule = PlayingRules.find_by_prize prize
        return nil if rule.size == 0
        rule[0].number_beats
    end
    scope :m1lhao, -> {where("last_game_num LIKE :prefix", prefix: "M-%")}
    scope :euromilhoes, -> {where("last_game_num LIKE :prefix", prefix: "E-%")}
    
    def self.read_feed
        feed_found = false
        feed = Feedjira::Feed.fetch_and_parse("http://www.jogossantacasa.pt/web/SCRss/rssFeedJackpots")
        feed.entries.each do |entry|
            if "Euromilhões" == entry.title then
                feed_found = true
                data = entry.summary
                my_feed = Feed.euromilhoes
                if my_feed.size == 0 then
                    my_feed = Feed.new
                else
                    my_feed = my_feed[0]
                end
                #Próximo Sorteio nº 026/2015, terça-feira dia 31/03/2015 - <b>Jackpot</b> - 1º prémio &euro;73.000.000,00<br><br>
                #Chave do Sorteio nº 025/2015 -  2 30 32 39 44 +  6 10
                
                new_date = /, .* (\d?\d\/\d\d\/\d\d\d\d)/.match(data)[1].to_date
                if my_feed.next_game_date == new_date then
                    raise FeedAlreadyExistsError.new 
                end
                my_feed.next_game_date = new_date
                if nil !=  /Jackpot/.match(data) then
                    my_feed.as_jackpot = true
                else
                    my_feed.as_jackpot = false
                end
                if /&euro;((\d|\.)+),00/.match(data) == nil then
                    raise FeedHasNoPrizeError.new
                end
                my_feed.prize = /&euro;((\d|\.)+),00/.match(data)[1].gsub(/\./, '').to_i
                game_and_key = /(\d+\/\d+) - ([\d ]+\+[\d ]+)/.match(data)
                my_feed.last_key =  game_and_key[2]
                my_feed.last_game_num = 'E-' + game_and_key[1]
                my_feed.save
                game = Game.find_by_num my_feed.last_game_num
                if game != nil then 
                    if game.instance_of? Game
                        game.winner_combination = my_feed.last_key.strip
                        game.save
                    end
                end
            elsif 'M1lhão' == entry.title then
                feed_found = true
                data = entry.summary
                my_feed = Feed.m1lhao
                if my_feed.size == 0 then
                    my_feed = Feed.new
                else
                    my_feed = my_feed[0]
                end
                # Próximo Sorteio nº 006/2016, sexta-feira dia 04/11/2016 - 1º prémio €1.000.000,00
                # Sorteio nº 005/2016: DFJ 20960 
                new_date = /, .* (\d?\d\/\d\d\/\d\d\d\d)/.match(data)[1].to_date
                if my_feed.next_game_date == new_date then
                    raise FeedAlreadyExistsError.new 
                end
                my_feed.next_game_date = new_date
                my_feed.as_jackpot = false
                if /&euro;((\d|\.)+),00/.match(data) == nil then
                    raise FeedHasNoPrizeError.new
                end
                my_feed.prize = /&euro;((\d|\.)+),00/.match(data)[1].gsub(/\./, '').to_i
                game_and_key = /(\d+\/\d+): (\w\w\w +\d\d\d\d\d)/.match(data)
                my_feed.last_key =  game_and_key[2]
                my_feed.last_game_num = 'M-' + game_and_key[1]
                my_feed.save
                game = Game.find_by_num my_feed.last_game_num
                if game != nil
                    if game.instance_of? Game
                        game.winner_combination = my_feed.last_key.strip
                        game.save
                    end
                end
            end
        end
        
        raise NoFeedFoundError.new if not feed_found
    end
end
