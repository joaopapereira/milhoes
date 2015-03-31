class Responsible < ActiveRecord::Base
    belongs_to :person
    def self.from_current_month
        self.where("month > ? ", (Date.today - 1.month) )
    end
    
    def self.assign_responsible
        all_resp = self.order("month ASC")
        if all_resp.last.month < (Date.today + 6.month) then
            
            new_resp = Responsible.new
            new_resp.person = all_resp.last.person.next
            new_resp.month = all_resp.last.month + 1.month
        end
    end
end
