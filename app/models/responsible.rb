class Responsible < ActiveRecord::Base
    belongs_to :person
    def self.from_current_month
        self.where("month > ? ", (Date.today - 1.month) )
    end
end
