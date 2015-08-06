class UserMailer < ActionMailer::Base
  default from: "from@example.com"
  def bet_made game
    @next_beat = {
      "date" => "01-01-2001",
      "as_jackpot" => "Yes",
      "number_beats" => 2
    }
    @next_beat = Feed.all[0]
    @games = Game.find_by_date game.day
    mail(
     :subject => "Nova aposta para o dia #{game.day}",
     :to  => Person.all_emails,
     :from => Responsible.this_month.person.email
    )
  end
end
