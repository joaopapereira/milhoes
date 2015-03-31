require 'rails_helper'

RSpec.describe Person, :type => :model do
    before(:all) do
        create(:person, :name => "First Name")
        create(:person, :name => "Third Name")
        create(:person, :name => "Second Name")
    end
    describe "Person#next_person" do
        it "Check working" do
            p1 = Person.find_by_name("First Name")
            p2 = Person.find_by_name("Second Name")
            expect(p1.next).to eq(p2)
        end
    end
end
