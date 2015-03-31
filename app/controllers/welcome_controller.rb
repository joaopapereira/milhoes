class WelcomeController < ApplicationController
  def index
    @next_beat = {
      "date" => "01-01-2001",
      "as_jackpot" => "Yes",
      "number_beats" => 2
    }
    @next_beat = Feed.all[0]
    @responsibles = Responsible.from_current_month
  end
  def update
    begin
      Feed.read_feed
      gflash :success => "Encontrou novos resultados no feed"
    rescue ArgumentError => msg
      gflash :error => msg
    end
    redirect_to action: "index"
  end
end
