class AddPositionToPeople < ActiveRecord::Migration
  def change
    add_column :people, :position, :integer
    position = 0
    Person.all.each do |person|
      person.position = position
      person.save
      position += 1
    end
  end
end
