class CreateResponsibles < ActiveRecord::Migration
  def change
    create_table :responsibles do |t|
      t.date :month
      t.belongs_to :person

      t.timestamps
    end
  end
end
