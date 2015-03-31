class Person < ActiveRecord::Base
    has_many :responsible
    def next
        Person.where("name > ?", name).order("name ASC").first
    end
    def previous
        Person.where("name < ?", name).order("name ASC").first
    end
end
