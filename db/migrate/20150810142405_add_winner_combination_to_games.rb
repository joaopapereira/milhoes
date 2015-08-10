class AddWinnerCombinationToGames < ActiveRecord::Migration
  def change
    add_column :games, :winner_combination, :string
    add_column :feeds, :last_game_num, :string
  end
end
