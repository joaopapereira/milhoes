require 'rails_helper'
require "milhoes_exceptions"

RSpec.describe Game, :type => :model do
  before(:each) do
    DatabaseCleaner.clean_with(:truncation)
  end
  subject {FactoryGirl.build :game}
  describe "Success creation" do
    it "Single game bet" do
      game_data = %q(
248715564063
07/08/2015	
Euromilhões
Aposta(s) Simples
4 apostas
Sorteio: 063/2015
24 39 42 45 49 + 4 5
2 6 13 39 46 + 1 3
20 23 27 29 38 + 6 8
7 8 11 25 37 + 6 10
€ 8,00
)
      games = Game.bulk_parse game_data
      expect(games.length).to be 1
      g = games.first
      expect(g.prize).to be nil
      expect(g.num).equal? "063/2015"
      expect(g.day).equal? Date.strptime("08/07/2015", "%m/%d/%Y")
      expect(g.bets.length).to be 4
      
      expect(g.bets.second.first).to be 2
      expect(g.bets.second.second).to be 6
      expect(g.bets.second.third).to be 13
      expect(g.bets.second.forth).to be 39
      expect(g.bets.second.fifth).to be 46
      expect(g.bets.second.extra).to be 1
      expect(g.bets.second.extra_one).to be 3
    end
    it "Two game bet" do
      game_data = %q(
248715564063
07/08/2015	
Euromilhões
Aposta(s) Simples
4 apostas
Sorteio: 063/2015
24 39 42 45 49 + 4 5
2 6 13 39 46 + 1 3
20 23 27 29 38 + 6 8
7 8 11 25 37 + 6 10
€ 8,00


248715564063
13/08/2015	
Euromilhões
Aposta(s) Simples
1 apostas
Sorteio: 001/2014
1 2 3 4 5 + 6 7
€ 2,00
)
      games = Game.bulk_parse game_data
      expect(games.length).to be 2
      g = games.second
      expect(g.prize).to be nil
      expect(g.num).equal? "001/2014"
      expect(g.day).equal? Date.strptime("08/13/2015", "%m/%d/%Y")
      expect(g.bets.length).to be 1
      
      expect(g.bets.first.first).to be 1
      expect(g.bets.first.second).to be 2
      expect(g.bets.first.third).to be 3
      expect(g.bets.first.forth).to be 4
      expect(g.bets.first.fifth).to be 5
      expect(g.bets.first.extra).to be 6
      expect(g.bets.first.extra_one).to be 7
    end
  end
end
