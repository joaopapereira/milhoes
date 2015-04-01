require 'rails_helper'

RSpec.describe Person, :type => :model do
    describe "Person#next and Person#previous" do
        before(:all) do
            create(:person, :name => "First Name")
            create(:person, :name => "Second Name")
            create(:person, :name => "Third Name")
        end
        after(:all) do
            DatabaseCleaner.clean_with(:truncation)
        end
        describe "Person#next" do
            it "Check working" do
                p1 = Person.find_by_name("First Name")
                p2 = Person.find_by_name("Second Name")
                expect(p1.next).to eq(p2)
            end
            it "Next on last person" do
                p1 = Person.find_by_name("First Name")
                p2 = Person.find_by_name("Third Name")
                expect(p2.next).to eq(p1)
            end
        end
        describe "Person#previous" do
            it "Check working" do
                p1 = Person.find_by_name("First Name")
                p2 = Person.find_by_name("Second Name")
                expect(p2.previous).to eq(p1)
            end
            it "Previous on first person" do
                p1 = Person.find_by_name("First Name")
                p2 = Person.find_by_name("Third Name")
                expect(p1.previous).to eq(p2)
            end
        end
    end
    describe "Person#reorder" do
        before(:each) do
            DatabaseCleaner.clean_with(:truncation)
            create(:person, :name => "First Name")
            create(:person, :name => "Second Name")
            create(:person, :name => "Third Name")
            create(:person, :name => "Forth Name")
            create(:person, :name => "Fifth Name")
        end
        it "Reorder forward" do
            p1 = Person.find_by_name("Third Name")
            current_position = p1.position
            p1.position += 1
            p1.save
            p2 = Person.find_by_name("Forth Name")
            p3 = Person.find_by_name("Fifth Name")
            expect(p2.position).to eq(2)
            expect(p1.position).to eq(3)
            expect(p3.position).to eq(4)
        end
        it "Reorder backward" do
            p1 = Person.find_by_name("Third Name")
            current_position = p1.position
            p1.position = 0
            p1.save
            p2 = Person.find_by_name("Second Name")
            p3 = Person.find_by_name("First Name")
            p4 = Person.find_by_name("Forth Name")
            expect(p2.position).to eq(1)
            expect(p3.position).to eq(2)
            expect(p4.position).to eq(3)
        end
    end
end
