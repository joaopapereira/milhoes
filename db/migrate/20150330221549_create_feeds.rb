class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.date :next_game_date
      t.boolean :as_jackpot
      t.integer :prize
      t.text :last_key

      t.timestamps
    end
  end
end
