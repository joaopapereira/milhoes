class CreateBetsAndGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :num
      t.date :day
      t.integer :prize

      t.timestamps
    end
    create_table :bets do |t|
      t.integer :game_id
      t.integer :first
      t.integer :second
      t.integer :third
      t.integer :forth
      t.integer :fifth
      t.integer :extra
      t.integer :extra_one

      t.timestamps
    end
  end
end
