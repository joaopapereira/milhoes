class CreateResponsibles < ActiveRecord::Migration
  def change
    create_table :responsibles do |t|
      t.date :month
      t.Person :person

      t.timestamps
    end
  end
end
