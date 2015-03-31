class Feed < ActiveRecord::Base
    def number_of_beats
        rule = PlayingRules.find_by_prize prize
        return nil if rule.size == 0
        rule[0].number_beats
    end
    def self.read_feed
        feed = Feedjira::Feed.fetch_and_parse("http://www.jogossantacasa.pt/web/SCRss/rssFeedJackpots")
        feed.entries.each do |entry|
            if "Euromilhões" == entry.title then
                data = entry.summary
                my_feed = Feed.all
                if my_feed.size == 0 then
                    my_feed = Feed.new
                else
                    my_feed = my_feed[0]
                end
                #Próximo Sorteio nº 026/2015, terça-feira dia 31/03/2015 - <b>Jackpot</b> - 1º prémio &euro;73.000.000,00<br><br>
                #Chave do Sorteio nº 025/2015 -  2 30 32 39 44 +  6 10
                puts data
                
                new_date = /, .* (\d?\d\/\d\d\/\d\d\d\d)/.match(data)[1].to_date
                if my_feed.next_game_date == new_date then
                    raise ArgumentError.new "O resultado é igual ao que ja temos!"
                end
                my_feed.next_game_date = new_date
                if nil !=  /Jackpot/.match(data) then
                    my_feed.as_jackpot = true
                else
                    my_feed.as_jackpot = false
                end
                if /&euro;((\d|\.)+),00/.match(data) == nil then
                    raise ArgumentError.new "Ainda nao foi divulgado o premio!"
                end
                my_feed.prize = /&euro;((\d|\.)+),00/.match(data)[1].gsub(/\./, '').to_i
                my_feed.last_key =  /\d+\/\d+ - ([\d \+]+)/.match(data)[1]
                my_feed.save
                
                return true
            end
        end
        
        raise ArgumentError.new "Nao encontrou um resultado do Euromilhoes!"
    end
end
