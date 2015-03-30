class WelcomeController < ApplicationController
  def index
    @next_beat = {
      "date" => "01-01-2001",
      "as_jackpot" => "Yes",
      "number_beats" => 2
    }
    @responsibles = {}
  end
end
