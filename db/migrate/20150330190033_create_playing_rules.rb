class CreatePlayingRules < ActiveRecord::Migration
  def change
    create_table :playing_rules do |t|
      t.int :minor
      t.int :major
      t.int :number_beats

      t.timestamps
    end
  end
end
