FactoryGirl.define do
  factory :feed do
    next_game_date Date.today
    as_jackpot true
    prize 100
  end

end
