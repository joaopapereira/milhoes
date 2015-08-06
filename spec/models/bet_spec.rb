require 'rails_helper'
require "milhoes_exceptions"

RSpec.describe Bet, :type => :model do
  before(:each) do
    DatabaseCleaner.clean_with(:truncation)
  end
  describe "Check parsing" do
      subject {FactoryGirl.build :bet}
      describe "Wrong line" do
          it {expect(subject.parse "1 2 3 4 + 1 2").to be false}
          it {expect(subject.parse "123 2 33312 4 + 133 22222 ").to be false}
          it {expect(subject.parse "123 2 33312 4 5 6 + 133 22222 ").to be false}
          it {expect(subject.parse "123 2 33312 4 5 6 + 133 \n22222 ").to be false}
      end
      describe "Correct line" do
          it {
              expect(subject.parse "1 2 3 4 5 + 6 7").to be true
              expect(subject.first).to be 1
              expect(subject.second).to be 2
              expect(subject.third).to be 3
              expect(subject.forth).to be 4
              expect(subject.fifth).to be 5
              expect(subject.extra).to be 6
              expect(subject.extra_one).to be 7
          }
          it {
              expect(subject.parse "12 13 2 1 4 + 133 22222 ").to be true
              expect(subject.first).to be 12
              expect(subject.second).to be 13
              expect(subject.third).to be 2
              expect(subject.forth).to be 1
              expect(subject.fifth).to be 4
              expect(subject.extra).to be 133
              expect(subject.extra_one).to be 22222
          }
          it {
              expect(subject.parse " 12 13 2 1 4 + 133 22222 ").to be true
              expect(subject.first).to be 12
              expect(subject.second).to be 13
              expect(subject.third).to be 2
              expect(subject.forth).to be 1
              expect(subject.fifth).to be 4
              expect(subject.extra).to be 133
              expect(subject.extra_one).to be 22222
          }
      end
  end
end
