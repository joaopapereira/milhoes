require 'rails_helper'
require "milhoes_exceptions"

describe UserMailer, :type => :controller do

  describe "POST /signup (#signup)" do
    before(:all) do
        FactoryGirl.create(:person, :name => "First Name", :email => "mail1@mail.com")
        FactoryGirl.create(:person, :name => "Second Name", :email => "mail2@mail.com")
        FactoryGirl.create(:person, :name => "Third Name", :email => "mail3@mail.com")
        FactoryGirl.create :feed
    end
    after(:all) do
        DatabaseCleaner.clean_with(:truncation)
    end
    it "should deliver the email" do
        game = Game.new
      expect {
        UserMailer.bet_made(game).deliver
      }.to change(ActionMailer::Base.deliveries, :size).by(1)

      last_delivery = ActionMailer::Base.deliveries.last
      expect(last_delivery.to).to include "mail1@mail.com"
      expect(last_delivery.to).to include "mail2@mail.com"
      expect(last_delivery.to).to include "mail3@mail.com"
    end

  end

end