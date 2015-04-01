require 'rails_helper'

RSpec.describe Responsible, :type => :model do
  let!(:today) { Date.today }
  describe "Responsible#assign_responsible" do
      before(:each) do
        DatabaseCleaner.clean_with(:truncation)
        @p1 = create(:person, :name => "p1")
        @p2 = create(:person, :name => "p2")
        @p3 = create(:person, :name => "p3")
        allow(Date).to receive(:today).and_return(Date.parse "11 Aug 2015")
      end
      it "no responsibles" do
          Responsible.assign_responsible
          all_resp = Responsible.from_current_month
          expect(all_resp.size).to eq(7)
          expect(all_resp[0].month).to eq(Date.parse "11 Aug 2015")
          expect(all_resp[0].person.name).to eq("p1")
          expect(all_resp[1].month).to eq(Date.parse "11 Sep 2015")
          expect(all_resp[1].person.name).to eq("p2")
          expect(all_resp[2].month).to eq(Date.parse "11 Oct 2015")
          expect(all_resp[2].person.name).to eq("p3")
          expect(all_resp[3].month).to eq(Date.parse "11 Nov 2015")
          expect(all_resp[3].person.name).to eq("p1")
          expect(all_resp[4].month).to eq(Date.parse "11 Dec 2015")
          expect(all_resp[4].person.name).to eq("p2")
          expect(all_resp[5].month).to eq(Date.parse "11 Jan 2016")
          expect(all_resp[5].person.name).to eq("p3")
          expect(all_resp[6].month).to eq(Date.parse "11 Feb 2016")
          expect(all_resp[6].person.name).to eq("p1")
      end
      it "one responsible" do
          r = Responsible.new
          r.person = @p2
          r.month = Date.parse "11 Dec 2015"
          r.save
          Responsible.assign_responsible
          allow(Date).to receive(:today).and_return(Date.parse "11 Dec 2015")
          all_resp = Responsible.from_current_month
          expect(all_resp.size).to eq(3)
          expect(all_resp[0].month).to eq(Date.parse "11 Dec 2015")
          expect(all_resp[0].person.name).to eq("p2")
          expect(all_resp[1].month).to eq(Date.parse "11 Jan 2016")
          expect(all_resp[1].person.name).to eq("p3")
          expect(all_resp[2].month).to eq(Date.parse "11 Feb 2016")
          expect(all_resp[2].person.name).to eq("p1")
      end
  end
end
