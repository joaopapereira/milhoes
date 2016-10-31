class AddBetToBets < ActiveRecord::Migration
  def change
    add_column :bets, :bet, :string
  end
end
