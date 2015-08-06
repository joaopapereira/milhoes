require 'rails_helper'
require "milhoes_exceptions"

describe UserMailer, :type => :controller do

  describe "Send email" do
    before(:all) do
        FactoryGirl.create(:person, :name => "First Name", :email => "mail1@mail.com")
        FactoryGirl.create(:person, :name => "Second Name", :email => "mail2@mail.com")
        FactoryGirl.create(:person, :name => "Third Name", :email => "mail3@mail.com")
        FactoryGirl.create :feed
        Responsible.assign_responsible
    end
    after(:all) do
        DatabaseCleaner.clean_with(:truncation)
    end
    it "should deliver the email" do
        game = Game.new
        game.day = Date.today
      expect {
        UserMailer.bet_made(game).deliver
      }.to change(ActionMailer::Base.deliveries, :size).by(1)

      last_delivery = ActionMailer::Base.deliveries.last
      expect(last_delivery.to).to include "mail1@mail.com"
      expect(last_delivery.to).to include "mail2@mail.com"
      expect(last_delivery.to).to include "mail3@mail.com"
      expect(last_delivery.subject).equal? "Nova aposta para o dia #{Date.today}"
    end

  end

end