require 'rails_helper'
require "milhoes_exceptions"

RSpec.describe Game, :type => :model do
    before(:all) do
        FactoryGirl.create(:person, :name => "First Name", :email => "mail1@mail.com")
        FactoryGirl.create(:person, :name => "Second Name", :email => "mail2@mail.com")
        FactoryGirl.create(:person, :name => "Third Name", :email => "mail3@mail.com")
        FactoryGirl.create(:game, :num => "E-062/2015", :winner_combination => "24 39 42 45 49 + 4 5")
        FactoryGirl.create(:game, :num => "M-006/2015", :winner_combination => "ASD 12345")
        FactoryGirl.create(:feed, :last_game_num => "E-062/2015")
        FactoryGirl.create(:feed, :last_game_num => "M-006/2015")
        Responsible.assign_responsible
    end
    after(:all) do
        DatabaseCleaner.clean_with(:truncation)
    end
  subject {FactoryGirl.build :game}
  describe "Bulk_parse" do
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
        expect(g.num).to eq "E-063/2015"
        expect(g.day).to eq Date.strptime("08/07/2015", "%m/%d/%Y")
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
        expect(g.num).to eq "E-001/2014"
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
  
  describe "Create games" do
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
        expect {
          expect(Game.create_games game_data).to be 1
        }.to change(ActionMailer::Base.deliveries, :size).by(1)
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
        expect {
          expect(Game.create_games game_data).to be 2
        }.to change(ActionMailer::Base.deliveries, :size).by(2)
      end
    end
  end
  
  
  describe "Bulk_parse_m1lhao" do
    describe "Success creation" do
      it "Single game bet" do
        game_data = %q(
319116843088
04/11/2016
M1lhão (Euromilhões)
Sorteio: 006/2016
4 códigos
DWS 21361
DWS 21362
DWS 21363
DWS 21364
€1,20
  )
        games = Game.bulk_parse game_data
        expect(games.length).to be 1
        g = games.first
        expect(g.prize).to be nil
        expect(g.num).to eq "M-006/2016"
        expect(g.day).equal? Date.strptime("04/11/2016", "%m/%d/%Y")
        expect(g.bets.length).to be 4
        
        expect(g.bets.first.bet).to eq "DWS 21361"
        expect(g.bets.second.bet).to eq "DWS 21362"
        expect(g.bets.third.bet).to eq "DWS 21363"
        expect(g.bets.fourth.bet).to eq "DWS 21364"
      end
      it "Two game bet" do
        game_data = %q(
319116843088
04/11/2016
M1lhão (Euromilhões)
Sorteio: 006/2016
4 códigos
DWS 21361
DWS 21362
DWS 21363
DWS 21364
€1,20


319116843088
05/11/2016
M1lhão (Euromilhões)
Sorteio: 007/2016
1 códigos
DWS 21361
€1,20
  )
        games = Game.bulk_parse game_data
        expect(games.length).to be 2
        g = games.second
        expect(g.prize).to be nil
        expect(g.num).to eq "M-007/2016"
        expect(g.day).equal? Date.strptime("05/11/2016", "%m/%d/%Y")
        expect(g.bets.length).to be 1
        
        expect(g.bets.first.bet).to eq "DWS 21361"
      end
    end
  end
  
  describe "Bulk_parse_with_all" do
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

319116843088
04/11/2016
M1lhão (Euromilhões)
Sorteio: 006/2016
4 códigos
DWS 21361
DWS 21362
DWS 21363
DWS 21364
€1,20
  )
        games = Game.bulk_parse game_data
        expect(games.length).to be 2
        
        g = games.first
        expect(g.prize).to be nil
        expect(g.num).to eq "E-063/2015"
        expect(g.day).to eq Date.strptime("08/07/2015", "%m/%d/%Y")
        expect(g.bets.length).to be 4
        
        expect(g.bets.second.first).to be 2
        expect(g.bets.second.second).to be 6
        expect(g.bets.second.third).to be 13
        expect(g.bets.second.forth).to be 39
        expect(g.bets.second.fifth).to be 46
        expect(g.bets.second.extra).to be 1
        expect(g.bets.second.extra_one).to be 3
        
        g = games.second
        expect(g.prize).to be nil
        expect(g.num).to eq "M-006/2016"
        expect(g.day).equal? Date.strptime("04/11/2016", "%m/%d/%Y")
        expect(g.bets.length).to be 4
        
        expect(g.bets.first.bet).to eq "DWS 21361"
        expect(g.bets.second.bet).to eq "DWS 21362"
        expect(g.bets.third.bet).to eq "DWS 21363"
        expect(g.bets.fourth.bet).to eq "DWS 21364"
      end
    end
  end
  
end
