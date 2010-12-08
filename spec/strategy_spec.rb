require "spec_helper"

module DeviseLoginCookie

  describe Strategy do

    include DeviseLoginCookie::SpecHelpers

    describe "#valid?" do

      describe "with no cookies" do
        subject { create_strategy }
        it { should_not be_valid }
      end

      describe "with invalid cookie" do
        subject { create_strategy(:login_test_token => "blarg") }
        it { should_not be_valid }
      end

      describe "with valid cookie" do
        subject { create_valid_strategy }
        it { should be_valid }
      end

    end

  end

end
