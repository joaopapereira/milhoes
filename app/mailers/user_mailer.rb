class UserMailer < ActionMailer::Base
  default from: "me@jpereira.co.uk"
  def bet_made game
    @next_beat_euromilhoes = {
      "date" => "01-01-2001",
      "as_jackpot" => "Yes",
      "number_beats" => 2
    }
    @next_beat_euromilhoes = Feed.euromilhoes[0]
    @responsibles = Responsible.from_current_month
    @games = Game.find_by_date @next_beat_euromilhoes.next_game_date
    @last_game = Game.find_by_num @next_beat_euromilhoes.last_game_num
    
    @next_bet_m1lhao = {
      "date" => "01-01-2001"
    }
    @next_bet_m1lhao = Feed.m1lhao[0]
    @games_m1lhao = Game.find_by_date @next_bet_m1lhao.next_game_date
    @last_game_m1lhao = Game.find_by_num @next_bet_m1lhao.last_game_num
    
    mail(
     :subject => "Nova aposta para o dia #{game.day}",
     :to  => Person.all_emails,
    )
  end
end
