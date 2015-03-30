class CreatePlayingRules < ActiveRecord::Migration
  def change
    create_table :playing_rules do |t|
      t.integer :minor
      t.integer :major
      t.integer :number_beats

      t.timestamps
    end
  end
end
