class Person < ActiveRecord::Base
    before_create :add_order
    before_destroy :reorder_destroy
    after_update { |person| person.reorder_update if person.position_changed? }
    has_many :responsible
    def self.all_emails
        mails = []
        self.all.each do |user|
            mails << user.email
        end
        mails
    end
    def next
        all_persons = Person.order("position ASC").order("name ASC")
        return all_persons.first if self == all_persons.last
        Person.find_by_position(self.position + 1)
    end
    def previous
        all_persons = Person.order("position ASC").order("name ASC")
        return all_persons.last if self == all_persons.first
        Person.find_by_position(self.position - 1)
    end
    
    def reorder_update
        Person.all.order("position ASC").each do |person|
            next if person.position != self.position or person == self
            if person.position == self.position and person != self then
                person.position = self.position_was
                person.save
            end
        end
    end
    private
        def add_order
            last_person = Person.all.order("position ASC").last
            if last_person == nil then
                self.position = 0
            else
                self.position = last_person.position + 1
            end
        end
        def reorder_destroy
            current_number = 0
            Person.all.order("position ASC").each do |person|
                if person != self then
                    person.position = current_number
                    current_number += 1
                    person.save
                end
            end
        end
end
