class Responsible < ActiveRecord::Base
    belongs_to :person
    def self.from_current_month
        self.where("month > ? ", (Date.today - 1.month) ).order(:month)
    end
    
    def self.this_month
        self.from_current_month.first
    end
    
    def self.assign_responsible
        while true do
            all_resp = self.order("month ASC")
            if all_resp.size == 0 then
                new_resp = Responsible.new
                new_resp.person = Person.all.order("position ASC").first
                new_resp.month = Date.today
                new_resp.save
            elsif all_resp.last.month < (Date.today + 6.month) then
                new_resp = Responsible.new
                new_resp.person = all_resp.last.person.next
                new_resp.month = all_resp.last.month + 1.month
                new_resp.save
            else
                break
            end
        end
    end
end
